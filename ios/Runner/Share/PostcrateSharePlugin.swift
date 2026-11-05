import Flutter
import UIKit

/// Flutter bridge for PostcrateShare on channel "com.vecvel.postcrate/share".
final class PostcrateSharePlugin: NSObject, FlutterPlugin {
  static let channelName = "com.vecvel.postcrate/share"

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(PostcrateSharePlugin(), channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "share":
      share(args, result: result)
    case "installedApps":
      result(installedApps(args["schemes"] as? [String: String] ?? [:]))
    case "openUrl":
      openUrl(args, result: result)
    case "takeIncomingText":
      // iOS receives links through a share extension (not built yet).
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func share(_ args: [String: Any], result: @escaping FlutterResult) {
    guard let presenter = Self.topViewController() else {
      result(["status": "unavailable", "target": ""])
      return
    }
    let files = (args["files"] as? [[String: Any]] ?? []).compactMap { f -> PostcrateShare.Item? in
      guard let path = f["path"] as? String, FileManager.default.fileExists(atPath: path) else { return nil }
      return PostcrateShare.Item(url: URL(fileURLWithPath: path), mimeType: f["mimeType"] as? String ?? "")
    }
    var rect: CGRect?
    if let o = args["origin"] as? [String: Double] {
      rect = CGRect(x: o["x"] ?? 0, y: o["y"] ?? 0, width: o["width"] ?? 0, height: o["height"] ?? 0)
    }

    PostcrateShare.share(
      files: files,
      text: args["text"] as? String ?? "",
      subject: args["subject"] as? String,
      from: presenter,
      sourceRect: rect
    ) { outcome in
      switch outcome {
      case .completed(let activity):
        result(["status": "completed", "target": activity])
      case .dismissed:
        result(["status": "dismissed", "target": ""])
      case .unavailable:
        result(["status": "unavailable", "target": ""])
      }
    }
  }

  /// Returns the platform ids whose URL scheme can be opened. Schemes must be
  /// listed in LSApplicationQueriesSchemes.
  private func installedApps(_ schemes: [String: String]) -> [String] {
    schemes.compactMap { id, scheme in
      guard let url = URL(string: "\(scheme)://") else { return nil }
      return UIApplication.shared.canOpenURL(url) ? id : nil
    }
  }

  /// Opens a link in its native app when one claims it (universal links),
  /// otherwise in the browser.
  private func openUrl(_ args: [String: Any], result: @escaping FlutterResult) {
    guard let raw = args["url"] as? String, let url = URL(string: raw) else {
      result(false)
      return
    }
    let preferApp = args["preferApp"] as? Bool ?? true
    guard preferApp else {
      UIApplication.shared.open(url) { result($0) }
      return
    }
    UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { openedInApp in
      if openedInApp {
        result(true)
      } else {
        UIApplication.shared.open(url) { result($0) }
      }
    }
  }

  static func topViewController() -> UIViewController? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    let window = scenes.flatMap(\.windows).first { $0.isKeyWindow } ?? scenes.first?.windows.first
    var top = window?.rootViewController
    while let presented = top?.presentedViewController {
      top = presented
    }
    return top
  }
}
