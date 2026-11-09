package com.vecvel.postcrate.share

import android.app.Activity
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ClipData
import android.content.ClipDescription
import android.content.ClipboardManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.PersistableBundle
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.File
import java.util.concurrent.Executors

/**
 * Sharing on "com.vecvel.postcrate/share". The caption also goes to the
 * clipboard because Facebook and Instagram drop EXTRA_TEXT. Files are shared
 * as FileProvider content:// URIs.
 */
class PostcrateSharePlugin :
  FlutterPlugin,
  MethodChannel.MethodCallHandler,
  ActivityAware,
  PluginRegistry.ActivityResultListener,
  PluginRegistry.NewIntentListener {

  companion object {
    const val CHANNEL = "com.vecvel.postcrate/share"
    private const val REQUEST_SHARE = 0x5C0A
    private const val ACTION_CHOSEN = "com.vecvel.postcrate.SHARE_TARGET_CHOSEN"
    private const val SHARE_DIR = "share"
  }

  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private var binding: ActivityPluginBinding? = null
  private val activity: Activity? get() = binding?.activity

  private var pendingResult: MethodChannel.Result? = null
  private var chosenTarget: String? = null
  private lateinit var inbox: IncomingInbox
  private val worker = Executors.newSingleThreadExecutor()
  private val main = Handler(Looper.getMainLooper())

  private val chosenReceiver = object : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
      val component: ComponentName? = if (Build.VERSION.SDK_INT >= 33) {
        intent.getParcelableExtra(Intent.EXTRA_CHOSEN_COMPONENT, ComponentName::class.java)
      } else {
        @Suppress("DEPRECATION") intent.getParcelableExtra(Intent.EXTRA_CHOSEN_COMPONENT)
      }
      chosenTarget = component?.flattenToString()
    }
  }

  // FlutterPlugin ---------------------------------------------------------------

  override fun onAttachedToEngine(flutter: FlutterPlugin.FlutterPluginBinding) {
    context = flutter.applicationContext
    channel = MethodChannel(flutter.binaryMessenger, CHANNEL)
    channel.setMethodCallHandler(this)
    inbox = IncomingInbox(context)
    ContextCompat.registerReceiver(context, chosenReceiver, IntentFilter(ACTION_CHOSEN), ContextCompat.RECEIVER_NOT_EXPORTED)
  }

  override fun onDetachedFromEngine(flutter: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    runCatching { context.unregisterReceiver(chosenReceiver) }
  }

  // ActivityAware ---------------------------------------------------------------

  override fun onAttachedToActivity(b: ActivityPluginBinding) {
    binding = b
    b.addActivityResultListener(this)
    b.addOnNewIntentListener(this)
    captureIncoming(b.activity.intent)
  }

  override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

  override fun onReattachedToActivityForConfigChanges(b: ActivityPluginBinding) = onAttachedToActivity(b)

  override fun onDetachedFromActivity() {
    binding?.removeActivityResultListener(this)
    binding?.removeOnNewIntentListener(this)
    binding = null
  }

  override fun onNewIntent(intent: Intent): Boolean {
    if (!inbox.accepts(intent)) return false
    captureIncoming(intent)
    return true
  }

  /** Saves a shared item to the inbox, then tells Dart to read it. */
  private fun captureIncoming(intent: Intent?) {
    if (intent == null || !inbox.accepts(intent)) return
    val copy = Intent(intent)
    // Consume it so a config change doesn't save the same item twice.
    intent.action = Intent.ACTION_MAIN
    worker.execute {
      val saved = runCatching { inbox.save(copy) }.getOrDefault(false)
      if (saved) main.post { channel.invokeMethod("onIncoming", null) }
    }
  }

  // Method calls ------------------------------------------------------------------

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "share" -> share(call, result)
      "installedApps" -> result.success(installedApps(call.argument<Map<String, List<String>>>("packages").orEmpty()))
      "openUrl" -> result.success(openUrl(call.argument<String>("url")))
      "incomingItems" -> worker.execute {
        val items = inbox.items()
        main.post { result.success(items) }
      }
      "removeIncoming" -> {
        inbox.remove(call.argument<String>("id").orEmpty())
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  private fun share(call: MethodCall, result: MethodChannel.Result) {
    val host = activity
    if (host == null) {
      result.success(mapOf("status" to "unavailable", "target" to ""))
      return
    }
    if (pendingResult != null) {
      result.error("busy", "A share is already in progress", null)
      return
    }

    val text = call.argument<String>("text").orEmpty().trim()
    val subject = call.argument<String>("subject")
    val targetPackages = call.argument<List<String>>("targetPackages").orEmpty()
    val files = call.argument<List<Map<String, String>>>("files").orEmpty()

    if (text.isNotEmpty()) copyToClipboard(text)

    val shared = try {
      prepareFiles(files)
    } catch (e: Exception) {
      result.error("files", e.message, null)
      return
    }
    val uris = shared.map { it.first }
    val mimes = shared.map { it.second }

    val intent = Intent().apply {
      if (uris.size > 1) {
        action = Intent.ACTION_SEND_MULTIPLE
        putParcelableArrayListExtra(Intent.EXTRA_STREAM, ArrayList(uris))
      } else {
        action = Intent.ACTION_SEND
        uris.firstOrNull()?.let { putExtra(Intent.EXTRA_STREAM, it) }
      }
      type = mimeTypeFor(mimes)
      if (text.isNotEmpty()) putExtra(Intent.EXTRA_TEXT, text)
      if (!subject.isNullOrBlank()) putExtra(Intent.EXTRA_SUBJECT, subject)
      if (uris.isNotEmpty()) {
        val clip = ClipData.newUri(context.contentResolver, "media", uris.first())
        uris.drop(1).forEach { clip.addItem(ClipData.Item(it)) }
        clipData = clip
        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
      }
    }

    val pm = context.packageManager
    val direct = targetPackages.firstOrNull { isInstalled(pm, it) }
    if (direct != null) {
      intent.setPackage(direct)
      try {
        host.startActivity(intent)
        result.success(mapOf("status" to "completed", "target" to direct))
      } catch (e: Exception) {
        result.success(mapOf("status" to "unavailable", "target" to direct))
      }
      return
    }

    chosenTarget = null
    pendingResult = result
    val callback = PendingIntent.getBroadcast(
      context,
      REQUEST_SHARE,
      Intent(ACTION_CHOSEN).setPackage(context.packageName),
      PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE,
    )
    val chooser = Intent.createChooser(intent, null, callback.intentSender)
    try {
      host.startActivityForResult(chooser, REQUEST_SHARE)
    } catch (e: Exception) {
      pendingResult = null
      result.success(mapOf("status" to "unavailable", "target" to ""))
    }
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (requestCode != REQUEST_SHARE) return false
    val result = pendingResult ?: return true
    pendingResult = null
    // The chooser rarely reports RESULT_OK; the picked component is the
    // reliable signal that the user chose an app.
    val target = chosenTarget
    chosenTarget = null
    if (target != null) {
      result.success(mapOf("status" to "completed", "target" to target))
    } else {
      result.success(mapOf("status" to "dismissed", "target" to ""))
    }
    return true
  }

  // Helpers -----------------------------------------------------------------------

  private fun copyToClipboard(text: String) {
    val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as? ClipboardManager ?: return
    val clip = ClipData.newPlainText("Post caption", text)
    if (Build.VERSION.SDK_INT >= 24) {
      clip.description.extras = PersistableBundle().apply {
        putBoolean(ClipDescription.EXTRA_IS_SENSITIVE, false)
      }
    }
    clipboard.setPrimaryClip(clip)
  }

  /** Copies each file into cacheDir/share and returns (content uri, mime). */
  private fun prepareFiles(files: List<Map<String, String>>): List<Pair<Uri, String>> {
    val dir = File(context.cacheDir, SHARE_DIR)
    dir.deleteRecursively()
    dir.mkdirs()
    val authority = "${context.packageName}.share"
    return files.mapIndexedNotNull { index, f ->
      val source = File(f["path"] ?: return@mapIndexedNotNull null)
      if (!source.exists()) return@mapIndexedNotNull null
      val name = (f["name"] ?: source.name).replace(Regex("[^A-Za-z0-9._ -]"), "_").ifBlank { "file$index" }
      val target = File(dir, "${index + 1}-$name")
      source.copyTo(target, overwrite = true)
      FileProvider.getUriForFile(context, authority, target) to (f["mimeType"] ?: "application/octet-stream")
    }
  }

  private fun mimeTypeFor(mimes: List<String>): String = when {
    mimes.isEmpty() -> "text/plain"
    mimes.size == 1 -> mimes.first()
    mimes.all { it.startsWith("image/") } -> "image/*"
    mimes.all { it.startsWith("video/") } -> "video/*"
    mimes.all { it.startsWith("audio/") } -> "audio/*"
    else -> "*/*"
  }

  private fun isInstalled(pm: PackageManager, pkg: String): Boolean = try {
    if (Build.VERSION.SDK_INT >= 33) {
      pm.getPackageInfo(pkg, PackageManager.PackageInfoFlags.of(0))
    } else {
      @Suppress("DEPRECATION") pm.getPackageInfo(pkg, 0)
    }
    true
  } catch (e: PackageManager.NameNotFoundException) {
    false
  }

  /** Returns platform ids with at least one installed package. */
  private fun installedApps(packages: Map<String, List<String>>): List<String> {
    val pm = context.packageManager
    return packages.filter { (_, pkgs) -> pkgs.any { isInstalled(pm, it) } }.keys.toList()
  }

  /** Opens a link; Android app links route it to the native app when installed. */
  private fun openUrl(url: String?): Boolean {
    val host = activity ?: return false
    if (url.isNullOrBlank()) return false
    return try {
      host.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)).addCategory(Intent.CATEGORY_BROWSABLE))
      true
    } catch (e: Exception) {
      false
    }
  }
}
