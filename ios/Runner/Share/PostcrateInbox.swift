import Foundation

/// Items saved by the share extension into the app group as
/// incoming/<id>/ with an item.json written last.
enum PostcrateInbox {
  static let appGroup = "group.com.vecvel.postcrate"

  private static var root: URL? {
    FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)?
      .appendingPathComponent("incoming", isDirectory: true)
  }

  /// Every finished item, oldest first.
  static func items() -> [[String: Any]] {
    guard let root,
      let dirs = try? FileManager.default.contentsOfDirectory(
        at: root, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
    else { return [] }
    func created(_ url: URL) -> Date {
      (try? url.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? .distantPast
    }
    return dirs.sorted { created($0) < created($1) }.compactMap { dir in
      guard let data = try? Data(contentsOf: dir.appendingPathComponent("item.json")),
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
      else { return nil }
      let files = (json["files"] as? [[String: String]] ?? []).compactMap { f -> [String: String]? in
        guard let file = f["file"] else { return nil }
        return [
          "path": dir.appendingPathComponent(file).path,
          "name": f["name"] ?? file,
          "mimeType": f["mimeType"] ?? "application/octet-stream",
        ]
      }
      let text = (json["text"] as? String).flatMap { $0.isEmpty ? nil : $0 }
      return ["id": dir.lastPathComponent, "text": text as Any, "files": files]
    }
  }

  static func remove(_ id: String) {
    guard let root, !id.isEmpty, !id.contains("/"), !id.contains("..") else { return }
    try? FileManager.default.removeItem(at: root.appendingPathComponent(id, isDirectory: true))
  }
}
