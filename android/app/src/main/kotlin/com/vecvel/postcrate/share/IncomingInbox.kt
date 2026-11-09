package com.vecvel.postcrate.share

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.OpenableColumns
import android.webkit.MimeTypeMap
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.util.UUID

/**
 * Items shared into Postcrate, stored as filesDir/incoming/<id>/ with the
 * copied files and an item.json written last. The same layout is used by the
 * iOS share extension, so the Dart side reads both the same way.
 */
class IncomingInbox(private val context: Context) {
  private val root = File(context.filesDir, "incoming")

  /** True when [intent] carries something to save. */
  fun accepts(intent: Intent?): Boolean =
    intent?.action == Intent.ACTION_SEND || intent?.action == Intent.ACTION_SEND_MULTIPLE

  /** Copies the shared text and files out of [intent]. Run off the main thread. */
  fun save(intent: Intent): Boolean {
    val text = listOfNotNull(
      intent.getStringExtra(Intent.EXTRA_TEXT)?.trim()?.takeIf { it.isNotEmpty() },
    ).joinToString("\n")
    val streams = streamsOf(intent)
    if (text.isEmpty() && streams.isEmpty()) return false

    val id = UUID.randomUUID().toString()
    val dir = File(root, id).apply { mkdirs() }
    val files = JSONArray()
    streams.forEachIndexed { index, uri ->
      val copied = runCatching { copy(uri, dir, index) }.getOrNull() ?: return@forEachIndexed
      files.put(JSONObject().put("file", copied.first).put("name", copied.second).put("mimeType", copied.third))
    }
    if (text.isEmpty() && files.length() == 0) {
      dir.deleteRecursively()
      return false
    }
    val json = JSONObject().put("text", text).put("files", files)
    File(dir, "item.json.tmp").apply { writeText(json.toString()) }.renameTo(File(dir, "item.json"))
    return true
  }

  /** Every finished item, oldest first. */
  fun items(): List<Map<String, Any?>> {
    val dirs = root.listFiles { f -> f.isDirectory }?.sortedBy { it.lastModified() } ?: return emptyList()
    return dirs.mapNotNull { dir ->
      val manifest = File(dir, "item.json")
      if (!manifest.exists()) return@mapNotNull null
      val json = runCatching { JSONObject(manifest.readText()) }.getOrNull() ?: return@mapNotNull null
      val files = json.optJSONArray("files") ?: JSONArray()
      mapOf(
        "id" to dir.name,
        "text" to json.optString("text").takeIf { it.isNotEmpty() },
        "files" to (0 until files.length()).map { i ->
          val f = files.getJSONObject(i)
          mapOf(
            "path" to File(dir, f.getString("file")).path,
            "name" to f.optString("name"),
            "mimeType" to f.optString("mimeType"),
          )
        },
      )
    }
  }

  fun remove(id: String) {
    if (id.isBlank() || id.contains('/') || id.contains("..")) return
    File(root, id).deleteRecursively()
  }

  @Suppress("DEPRECATION")
  private fun streamsOf(intent: Intent): List<Uri> = when (intent.action) {
    Intent.ACTION_SEND_MULTIPLE -> if (Build.VERSION.SDK_INT >= 33) {
      intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM, Uri::class.java).orEmpty()
    } else {
      intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM).orEmpty()
    }
    else -> listOfNotNull(
      if (Build.VERSION.SDK_INT >= 33) {
        intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
      } else {
        intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
      },
    )
  }

  /** Returns (stored file name, display name, mime type). */
  private fun copy(uri: Uri, dir: File, index: Int): Triple<String, String, String> {
    val resolver = context.contentResolver
    val mime = resolver.getType(uri) ?: "application/octet-stream"
    var name = when (uri.scheme) {
      "content" -> resolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use { c ->
        if (c.moveToFirst()) c.getString(0) else null
      }
      "file" -> uri.lastPathSegment
      else -> null
    }?.replace(Regex("[/\\\\]"), "_")?.takeIf { it.isNotBlank() } ?: "shared-${index + 1}"
    if (!name.contains('.')) {
      MimeTypeMap.getSingleton().getExtensionFromMimeType(mime)?.let { name = "$name.$it" }
    }
    val stored = "${index + 1}-${name.replace(Regex("[^A-Za-z0-9._ -]"), "_")}"
    resolver.openInputStream(uri)!!.use { input ->
      File(dir, stored).outputStream().use { input.copyTo(it) }
    }
    return Triple(stored, name, mime)
  }
}
