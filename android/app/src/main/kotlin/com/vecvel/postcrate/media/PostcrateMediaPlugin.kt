package com.vecvel.postcrate.media

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.pdf.PdfRenderer
import android.media.ExifInterface
import android.media.MediaExtractor
import android.media.MediaFormat
import android.media.MediaMetadataRetriever
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.ParcelFileDescriptor
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.concurrent.Executors

/**
 * Reads technical details from media files and renders preview frames, on
 * channel "com.vecvel.postcrate/media".
 *
 * - probe(path): container, codecs (MIME), size, rotation, duration, bitrate,
 *   frame rate, audio sample rate and channels, color, HDR, pages.
 * - thumbnail(path, outPath, atMs, maxSize): JPEG of a video frame or the
 *   first page of a PDF.
 */
class PostcrateMediaPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
  companion object {
    const val CHANNEL = "com.vecvel.postcrate/media"
    private val IMAGE_EXT = setOf("jpg", "jpeg", "png", "heic", "heif", "webp", "gif", "avif")
    private val AV_EXT = setOf("mp4", "mov", "m4v", "webm", "mp3", "m4a", "aac", "wav")
  }

  private lateinit var channel: MethodChannel
  private val worker = Executors.newSingleThreadExecutor()
  private val main = Handler(Looper.getMainLooper())

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, CHANNEL)
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    worker.shutdown()
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    val path = call.argument<String>("path")
    if (path == null) {
      result.error("args", "Missing path", null)
      return
    }
    when (call.method) {
      "probe" -> worker.execute {
        val info = runCatching { probe(File(path)) }.getOrDefault(emptyMap())
        main.post { result.success(info) }
      }
      "thumbnail" -> {
        val out = call.argument<String>("outPath")
        val atMs = call.argument<Number>("atMs")?.toLong() ?: 0L
        val maxSize = call.argument<Number>("maxSize")?.toInt() ?: 640
        if (out == null) {
          result.success(false)
          return
        }
        worker.execute {
          val ok = runCatching { thumbnail(File(path), File(out), atMs, maxSize) }.getOrDefault(false)
          main.post { result.success(ok) }
        }
      }
      else -> result.notImplemented()
    }
  }

  // Probe ---------------------------------------------------------------------------

  private fun probe(file: File): Map<String, Any?> {
    val ext = file.extension.lowercase()
    return when {
      ext == "pdf" -> probePdf(file)
      ext in IMAGE_EXT -> probeImage(file)
      ext in AV_EXT -> probeAv(file, ext)
      else -> emptyMap()
    }
  }

  private fun probeImage(file: File): Map<String, Any?> {
    val opts = BitmapFactory.Options().apply { inJustDecodeBounds = true }
    BitmapFactory.decodeFile(file.path, opts)
    val info = mutableMapOf<String, Any?>(
      "container" to (opts.outMimeType?.substringAfter('/')?.uppercase() ?: file.extension.uppercase()),
      "width" to opts.outWidth.takeIf { it > 0 },
      "height" to opts.outHeight.takeIf { it > 0 },
    )
    if (Build.VERSION.SDK_INT >= 26) info["colorSpace"] = opts.outColorSpace?.name
    runCatching {
      val orientation = ExifInterface(file.path).getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL)
      info["rotation"] = when (orientation) {
        ExifInterface.ORIENTATION_ROTATE_90, ExifInterface.ORIENTATION_TRANSPOSE -> 90
        ExifInterface.ORIENTATION_ROTATE_180, ExifInterface.ORIENTATION_FLIP_VERTICAL -> 180
        ExifInterface.ORIENTATION_ROTATE_270, ExifInterface.ORIENTATION_TRANSVERSE -> 270
        else -> 0
      }
    }
    return info.filterValues { it != null }
  }

  private fun probePdf(file: File): Map<String, Any?> {
    ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY).use { fd ->
      PdfRenderer(fd).use { renderer ->
        val info = mutableMapOf<String, Any?>("container" to "PDF", "pageCount" to renderer.pageCount)
        if (renderer.pageCount > 0) {
          renderer.openPage(0).use { page ->
            info["width"] = page.width
            info["height"] = page.height
          }
        }
        return info
      }
    }
  }

  private fun probeAv(file: File, ext: String): Map<String, Any?> {
    val info = mutableMapOf<String, Any?>("container" to containerName(ext))

    val retriever = MediaMetadataRetriever()
    try {
      retriever.setDataSource(file.path)
      retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull()?.let { info["durationMs"] = it }
      retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_BITRATE)?.toLongOrNull()?.let { info["bitrate"] = it }
      retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION)?.toIntOrNull()?.let { info["rotation"] = it }
      retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH)?.toIntOrNull()?.let { info["width"] = it }
      retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT)?.toIntOrNull()?.let { info["height"] = it }
      if (Build.VERSION.SDK_INT >= 28) {
        val frames = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_FRAME_COUNT)?.toDoubleOrNull()
        val ms = (info["durationMs"] as? Long)?.toDouble()
        if (frames != null && ms != null && ms > 0) info["frameRate"] = frames * 1000.0 / ms
      }
    } catch (_: Exception) {
      // Unsupported container; MediaExtractor below may still read it.
    } finally {
      runCatching { retriever.release() }
    }

    val extractor = MediaExtractor()
    try {
      extractor.setDataSource(file.path)
      for (i in 0 until extractor.trackCount) {
        val format = extractor.getTrackFormat(i)
        val mime = format.getString(MediaFormat.KEY_MIME) ?: continue
        if (mime.startsWith("video/") && info["videoCodec"] == null) {
          info["videoCodec"] = mime
          intOf(format, MediaFormat.KEY_WIDTH)?.let { info.putIfAbsent("width", it) }
          intOf(format, MediaFormat.KEY_HEIGHT)?.let { info.putIfAbsent("height", it) }
          numberOf(format, MediaFormat.KEY_FRAME_RATE)?.let { info["frameRate"] = it }
          if (Build.VERSION.SDK_INT >= 24) {
            intOf(format, MediaFormat.KEY_COLOR_STANDARD)?.let {
              info["colorSpace"] = when (it) {
                MediaFormat.COLOR_STANDARD_BT2020 -> "Rec. 2020"
                MediaFormat.COLOR_STANDARD_BT709 -> "Rec. 709"
                else -> "Standard $it"
              }
            }
            intOf(format, MediaFormat.KEY_COLOR_TRANSFER)?.let {
              info["hdr"] = it == MediaFormat.COLOR_TRANSFER_ST2084 || it == MediaFormat.COLOR_TRANSFER_HLG
            }
          }
        } else if (mime.startsWith("audio/") && info["audioCodec"] == null) {
          info["audioCodec"] = mime
          intOf(format, MediaFormat.KEY_SAMPLE_RATE)?.let { info["sampleRate"] = it }
          intOf(format, MediaFormat.KEY_CHANNEL_COUNT)?.let { info["channels"] = it }
        }
        if (info["durationMs"] == null && format.containsKey(MediaFormat.KEY_DURATION)) {
          info["durationMs"] = format.getLong(MediaFormat.KEY_DURATION) / 1000
        }
      }
    } catch (_: Exception) {
      // Keep what the retriever found.
    } finally {
      extractor.release()
    }

    if (info["bitrate"] == null) {
      val ms = (info["durationMs"] as? Number)?.toDouble()
      if (ms != null && ms > 0) info["bitrate"] = (file.length() * 8 * 1000 / ms).toLong()
    }
    return info.filterValues { it != null }
  }

  private fun intOf(f: MediaFormat, key: String): Int? =
    if (f.containsKey(key)) runCatching { f.getInteger(key) }.getOrNull() else null

  private fun numberOf(f: MediaFormat, key: String): Double? {
    if (!f.containsKey(key)) return null
    return runCatching { f.getInteger(key).toDouble() }.getOrNull()
      ?: runCatching { f.getFloat(key).toDouble() }.getOrNull()
  }

  private fun containerName(ext: String) = when (ext) {
    "mov" -> "QuickTime"
    "mp4", "m4v" -> "MPEG-4"
    "m4a" -> "MPEG-4 Audio"
    "webm" -> "WebM"
    "mp3" -> "MP3"
    "aac" -> "ADTS AAC"
    "wav" -> "WAVE"
    else -> ext.uppercase()
  }

  // Thumbnail -----------------------------------------------------------------------

  private fun thumbnail(file: File, out: File, atMs: Long, maxSize: Int): Boolean {
    val bitmap = if (file.extension.lowercase() == "pdf") pdfPage(file, maxSize) else videoFrame(file, atMs, maxSize)
    bitmap ?: return false
    out.parentFile?.mkdirs()
    FileOutputStream(out).use { bitmap.compress(Bitmap.CompressFormat.JPEG, 82, it) }
    bitmap.recycle()
    return true
  }

  private fun videoFrame(file: File, atMs: Long, maxSize: Int): Bitmap? {
    val retriever = MediaMetadataRetriever()
    return try {
      retriever.setDataSource(file.path)
      val us = atMs * 1000
      val frame = if (Build.VERSION.SDK_INT >= 27) {
        retriever.getScaledFrameAtTime(us, MediaMetadataRetriever.OPTION_CLOSEST_SYNC, maxSize, maxSize)
      } else {
        retriever.getFrameAtTime(us, MediaMetadataRetriever.OPTION_CLOSEST_SYNC)
      }
      frame?.let { scaleDown(it, maxSize) }
    } catch (_: Exception) {
      null
    } finally {
      runCatching { retriever.release() }
    }
  }

  private fun pdfPage(file: File, maxSize: Int): Bitmap? {
    ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY).use { fd ->
      PdfRenderer(fd).use { renderer ->
        if (renderer.pageCount == 0) return null
        renderer.openPage(0).use { page ->
          val scale = maxSize.toFloat() / maxOf(page.width, page.height)
          val bmp = Bitmap.createBitmap(
            (page.width * scale).toInt().coerceAtLeast(1),
            (page.height * scale).toInt().coerceAtLeast(1),
            Bitmap.Config.ARGB_8888,
          )
          bmp.eraseColor(Color.WHITE)
          page.render(bmp, null, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY)
          return bmp
        }
      }
    }
  }

  private fun scaleDown(src: Bitmap, maxSize: Int): Bitmap {
    val longest = maxOf(src.width, src.height)
    if (longest <= maxSize) return src
    val scale = maxSize.toFloat() / longest
    val scaled = Bitmap.createScaledBitmap(src, (src.width * scale).toInt(), (src.height * scale).toInt(), true)
    if (scaled != src) src.recycle()
    return scaled
  }
}
