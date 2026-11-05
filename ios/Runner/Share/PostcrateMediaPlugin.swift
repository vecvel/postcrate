import AVFoundation
import Flutter
import ImageIO
import PDFKit
import UIKit

/// Reads technical details from media files and renders preview frames, on
/// channel "com.vecvel.postcrate/media".
///
/// - probe(path): container, codecs (FourCC), size, rotation, duration,
///   bitrate, frame rate, audio sample rate and channels, color, HDR, pages.
/// - thumbnail(path, outPath, atMs, maxSize): JPEG of a video frame or the
///   first page of a PDF.
final class PostcrateMediaPlugin: NSObject, FlutterPlugin {
  static let channelName = "com.vecvel.postcrate/media"

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(PostcrateMediaPlugin(), channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    guard let path = args["path"] as? String else {
      result(FlutterError(code: "args", message: "Missing path", details: nil))
      return
    }
    let url = URL(fileURLWithPath: path)
    switch call.method {
    case "probe":
      Task {
        let info = await Self.probe(url)
        await MainActor.run { result(info) }
      }
    case "thumbnail":
      guard let out = args["outPath"] as? String else {
        result(false)
        return
      }
      let atMs = (args["atMs"] as? NSNumber)?.doubleValue ?? 0
      let maxSize = (args["maxSize"] as? NSNumber)?.doubleValue ?? 640
      Task {
        let ok = await Self.thumbnail(url, out: URL(fileURLWithPath: out), atMs: atMs, maxSize: maxSize)
        await MainActor.run { result(ok) }
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: Probe

  static func probe(_ url: URL) async -> [String: Any] {
    let ext = url.pathExtension.lowercased()
    if ext == "pdf" { return probePdf(url) }
    if ["jpg", "jpeg", "png", "heic", "heif", "webp", "gif", "avif"].contains(ext) { return probeImage(url) }
    if ["mp4", "mov", "m4v", "webm", "mp3", "m4a", "aac", "wav"].contains(ext) {
      return await probeAv(url, ext: ext)
    }
    return [:]
  }

  private static func probeImage(_ url: URL) -> [String: Any] {
    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
          let props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any] else { return [:] }
    var info: [String: Any] = [:]
    if let type = CGImageSourceGetType(source) as String? { info["container"] = imageFormatName(type) }
    info["width"] = props[kCGImagePropertyPixelWidth] as? Int
    info["height"] = props[kCGImagePropertyPixelHeight] as? Int
    if let orientation = props[kCGImagePropertyOrientation] as? Int {
      info["rotation"] = [6: 90, 8: 270, 3: 180, 5: 90, 7: 270, 4: 180][orientation] ?? 0
    }
    if let profile = props[kCGImagePropertyProfileName] as? String {
      info["colorSpace"] = profile
    } else if let model = props[kCGImagePropertyColorModel] as? String {
      info["colorSpace"] = model
    }
    let frames = CGImageSourceGetCount(source)
    if frames > 1 { info["pageCount"] = frames }
    return info.compactMapValues { $0 }
  }

  private static func imageFormatName(_ uti: String) -> String {
    switch uti {
    case "public.jpeg": return "JPEG"
    case "public.png": return "PNG"
    case "public.heic": return "HEIC"
    case "public.heif": return "HEIF"
    case "org.webmproject.webp": return "WebP"
    case "com.compuserve.gif": return "GIF"
    case "public.avif", "public.avci": return "AVIF"
    default: return uti
    }
  }

  private static func probePdf(_ url: URL) -> [String: Any] {
    guard let doc = PDFDocument(url: url) else { return ["container": "PDF"] }
    var info: [String: Any] = ["container": "PDF", "pageCount": doc.pageCount]
    if let page = doc.page(at: 0) {
      let box = page.bounds(for: .mediaBox)
      info["width"] = Int(box.width)
      info["height"] = Int(box.height)
    }
    return info
  }

  private static func probeAv(_ url: URL, ext: String) async -> [String: Any] {
    let asset = AVURLAsset(url: url)
    var info: [String: Any] = ["container": avContainerName(ext)]
    let fileSize = (try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? NSNumber)?.doubleValue

    if let duration = try? await asset.load(.duration), duration.isNumeric {
      let seconds = CMTimeGetSeconds(duration)
      info["durationMs"] = Int(seconds * 1000)
      if let size = fileSize, seconds > 0 { info["bitrate"] = Int(size * 8 / seconds) }
    }

    if let video = try? await asset.loadTracks(withMediaType: .video).first {
      if let (size, transform, fps, descriptions) = try? await video.load(
        .naturalSize, .preferredTransform, .nominalFrameRate, .formatDescriptions
      ) {
        info["width"] = Int(abs(size.width))
        info["height"] = Int(abs(size.height))
        let degrees = Int(round(atan2(transform.b, transform.a) * 180 / .pi))
        info["rotation"] = (degrees + 360) % 360
        if fps > 0 { info["frameRate"] = Double(fps) }
        if let desc = descriptions.first {
          info["videoCodec"] = fourCC(CMFormatDescriptionGetMediaSubType(desc))
          let ext = CMFormatDescriptionGetExtensions(desc) as? [CFString: Any]
          if let primaries = ext?[kCVImageBufferColorPrimariesKey] as? String {
            info["colorSpace"] = colorName(primaries)
          }
          if let transfer = ext?[kCVImageBufferTransferFunctionKey] as? String {
            info["hdr"] = transfer == (kCVImageBufferTransferFunction_ITU_R_2100_HLG as String)
              || transfer == (kCVImageBufferTransferFunction_SMPTE_ST_2084_PQ as String)
          }
        }
      }
    }

    if let audio = try? await asset.loadTracks(withMediaType: .audio).first,
       let descriptions = try? await audio.load(.formatDescriptions),
       let desc = descriptions.first {
      info["audioCodec"] = fourCC(CMFormatDescriptionGetMediaSubType(desc))
      if let asbd = CMAudioFormatDescriptionGetStreamBasicDescription(desc)?.pointee {
        info["sampleRate"] = Int(asbd.mSampleRate)
        info["channels"] = Int(asbd.mChannelsPerFrame)
      }
    }
    return info
  }

  private static func avContainerName(_ ext: String) -> String {
    switch ext {
    case "mov": return "QuickTime"
    case "mp4", "m4v": return "MPEG-4"
    case "m4a": return "MPEG-4 Audio"
    case "webm": return "WebM"
    case "mp3": return "MP3"
    case "aac": return "ADTS AAC"
    case "wav": return "WAVE"
    default: return ext.uppercased()
    }
  }

  private static func colorName(_ primaries: String) -> String {
    if primaries == (kCVImageBufferColorPrimaries_ITU_R_2020 as String) { return "Rec. 2020" }
    if primaries == (kCVImageBufferColorPrimaries_ITU_R_709_2 as String) { return "Rec. 709" }
    if primaries == (kCVImageBufferColorPrimaries_P3_D65 as String) { return "Display P3" }
    return primaries
  }

  private static func fourCC(_ code: FourCharCode) -> String {
    let bytes = [24, 16, 8, 0].map { UInt8((code >> $0) & 0xFF) }
    let text = String(bytes: bytes, encoding: .ascii) ?? "\(code)"
    return text.trimmingCharacters(in: .whitespacesAndNewlines.union(.controlCharacters))
  }

  // MARK: Thumbnail

  static func thumbnail(_ url: URL, out: URL, atMs: Double, maxSize: Double) async -> Bool {
    let image: CGImage?
    if url.pathExtension.lowercased() == "pdf" {
      image = pdfThumbnail(url, maxSize: maxSize)
    } else {
      image = await videoFrame(url, atMs: atMs, maxSize: maxSize)
    }
    guard let cg = image, let data = UIImage(cgImage: cg).jpegData(compressionQuality: 0.82) else { return false }
    do {
      try FileManager.default.createDirectory(at: out.deletingLastPathComponent(), withIntermediateDirectories: true)
      try data.write(to: out, options: .atomic)
      return true
    } catch {
      return false
    }
  }

  private static func videoFrame(_ url: URL, atMs: Double, maxSize: Double) async -> CGImage? {
    let generator = AVAssetImageGenerator(asset: AVURLAsset(url: url))
    generator.appliesPreferredTrackTransform = true
    generator.maximumSize = CGSize(width: maxSize, height: maxSize)
    let tolerance = CMTime(value: 1, timescale: 10)
    generator.requestedTimeToleranceBefore = tolerance
    generator.requestedTimeToleranceAfter = tolerance
    let time = CMTime(value: CMTimeValue(atMs), timescale: 1000)
    if #available(iOS 16, *) {
      return try? await generator.image(at: time).image
    }
    return try? generator.copyCGImage(at: time, actualTime: nil)
  }

  private static func pdfThumbnail(_ url: URL, maxSize: Double) -> CGImage? {
    guard let page = PDFDocument(url: url)?.page(at: 0) else { return nil }
    return page.thumbnail(of: CGSize(width: maxSize, height: maxSize), for: .mediaBox).cgImage
  }
}
