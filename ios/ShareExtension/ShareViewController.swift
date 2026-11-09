import UIKit
import UniformTypeIdentifiers

/// "Save to Postcrate". Copies the shared text and files into the app group
/// as incoming/<id>/ with an item.json written last, then offers to open the
/// app, which turns the item into a post.
final class ShareViewController: UIViewController {
  static let appGroup = "group.com.vecvel.postcrate"
  static let openURL = URL(string: "postcrate://incoming")!

  private let card = UIView()
  private let spinner = UIActivityIndicatorView(style: .medium)
  private let titleLabel = UILabel()
  private let detailLabel = UILabel()
  private let openButton = UIButton(type: .system)
  private let doneButton = UIButton(type: .system)

  override func viewDidLoad() {
    super.viewDidLoad()
    buildUI()
    show(title: "Saving to Postcrate…", detail: nil, saved: false)
    Task { await save() }
  }

  // MARK: Saving

  private struct Saved {
    var text: [String] = []
    var files: [[String: String]] = []
    var images = 0, videos = 0, audio = 0, documents = 0, links = 0
  }

  private func save() async {
    guard let group = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Self.appGroup) else {
      show(title: "Couldn't save", detail: "Postcrate's shared folder isn't available.", saved: false)
      return
    }
    let id = UUID().uuidString
    let dir = group.appendingPathComponent("incoming/\(id)", isDirectory: true)
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)

    var saved = Saved()
    let providers = (extensionContext?.inputItems as? [NSExtensionItem] ?? []).flatMap { $0.attachments ?? [] }
    for (index, provider) in providers.enumerated() {
      await load(provider, index: index, into: dir, saved: &saved)
    }

    let text = saved.text.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    guard !text.isEmpty || !saved.files.isEmpty else {
      try? FileManager.default.removeItem(at: dir)
      show(title: "Nothing to save", detail: "Postcrate saves text, links, photos, videos, audio and documents.", saved: false)
      return
    }
    let manifest: [String: Any] = ["text": text, "files": saved.files]
    if let data = try? JSONSerialization.data(withJSONObject: manifest) {
      let tmp = dir.appendingPathComponent("item.json.tmp")
      try? data.write(to: tmp)
      try? FileManager.default.moveItem(at: tmp, to: dir.appendingPathComponent("item.json"))
    }
    show(title: "Saved to Postcrate", detail: summary(saved), saved: true)
  }

  private func load(_ provider: NSItemProvider, index: Int, into dir: URL, saved: inout Saved) async {
    let types = provider.registeredTypeIdentifiers.compactMap(UTType.init)
    func first(_ base: UTType) -> UTType? { types.first { $0.conforms(to: base) } }

    if let t = first(.movie) ?? first(.image) ?? first(.audio) ?? first(.pdf) {
      if let file = await copyFile(provider, type: t, index: index, into: dir) {
        saved.files.append(file)
        if t.conforms(to: .movie) { saved.videos += 1 }
        else if t.conforms(to: .image) { saved.images += 1 }
        else if t.conforms(to: .audio) { saved.audio += 1 }
        else { saved.documents += 1 }
        return
      }
      // Some apps only hand over an in-memory image.
      if t.conforms(to: .image), let file = await copyImageItem(provider, index: index, into: dir) {
        saved.files.append(file)
        saved.images += 1
        return
      }
    }
    if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
      if let url = try? await provider.loadItem(forTypeIdentifier: UTType.url.identifier) as? URL {
        if url.isFileURL {
          if let file = copyLocal(url, index: index, into: dir) {
            saved.files.append(file)
            saved.documents += 1
          }
        } else {
          saved.text.append(url.absoluteString)
          saved.links += 1
        }
        return
      }
    }
    if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier),
      let text = try? await provider.loadItem(forTypeIdentifier: UTType.plainText.identifier) as? String
    {
      saved.text.append(text)
      return
    }
    if let t = first(.data), let file = await copyFile(provider, type: t, index: index, into: dir) {
      saved.files.append(file)
      saved.documents += 1
    }
  }

  private func copyFile(_ provider: NSItemProvider, type: UTType, index: Int, into dir: URL) async -> [String: String]? {
    await withCheckedContinuation { done in
      _ = provider.loadFileRepresentation(forTypeIdentifier: type.identifier) { url, _ in
        // The file is deleted when this handler returns, so copy it now.
        done.resume(returning: url.flatMap { self.copyLocal($0, index: index, into: dir, type: type) })
      }
    }
  }

  private func copyImageItem(_ provider: NSItemProvider, index: Int, into dir: URL) async -> [String: String]? {
    let item = try? await provider.loadItem(forTypeIdentifier: UTType.image.identifier)
    let data: Data?
    switch item {
    case let image as UIImage: data = image.jpegData(compressionQuality: 0.92)
    case let raw as Data: data = UIImage(data: raw)?.jpegData(compressionQuality: 0.92)
    default: data = nil
    }
    guard let data else { return nil }
    let name = "Photo \(index + 1).jpg"
    let stored = "\(index + 1)-photo.jpg"
    guard (try? data.write(to: dir.appendingPathComponent(stored))) != nil else { return nil }
    return ["file": stored, "name": name, "mimeType": "image/jpeg"]
  }

  nonisolated private func copyLocal(_ url: URL, index: Int, into dir: URL, type: UTType? = nil) -> [String: String]? {
    let scoped = url.startAccessingSecurityScopedResource()
    defer { if scoped { url.stopAccessingSecurityScopedResource() } }
    var name = url.lastPathComponent
    let fileType = type ?? UTType(filenameExtension: url.pathExtension)
    if url.pathExtension.isEmpty, let ext = fileType?.preferredFilenameExtension { name += ".\(ext)" }
    let safe = String(name.map { $0.isLetter || $0.isNumber || ".-_ ".contains($0) ? $0 : "_" })
    let stored = "\(index + 1)-\(safe)"
    do {
      try FileManager.default.copyItem(at: url, to: dir.appendingPathComponent(stored))
    } catch {
      return nil
    }
    return ["file": stored, "name": name, "mimeType": fileType?.preferredMIMEType ?? "application/octet-stream"]
  }

  private func summary(_ s: Saved) -> String {
    func count(_ n: Int, _ one: String, _ many: String) -> String? { n == 0 ? nil : n == 1 ? "1 \(one)" : "\(n) \(many)" }
    let notes = s.text.count - s.links
    let parts = [
      count(s.images, "photo", "photos"), count(s.videos, "video", "videos"), count(s.audio, "audio file", "audio files"),
      count(s.documents, "document", "documents"), count(s.links, "link", "links"), notes > 0 ? "text" : nil,
    ].compactMap { $0 }
    let list = parts.count > 1 ? parts.dropLast().joined(separator: ", ") + " and " + parts.last! : parts.first ?? ""
    return "\(list.prefix(1).uppercased() + list.dropFirst()). Open Postcrate to make it a post."
  }

  // MARK: UI

  private func buildUI() {
    view.backgroundColor = UIColor.black.withAlphaComponent(0.25)

    card.backgroundColor = .secondarySystemGroupedBackground
    card.layer.cornerRadius = 22
    card.layer.cornerCurve = .continuous
    card.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(card)

    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.textAlignment = .center
    detailLabel.font = .preferredFont(forTextStyle: .subheadline)
    detailLabel.textColor = .secondaryLabel
    detailLabel.textAlignment = .center
    detailLabel.numberOfLines = 0

    var open = UIButton.Configuration.filled()
    open.title = "Open Postcrate"
    open.cornerStyle = .large
    open.buttonSize = .large
    openButton.configuration = open
    openButton.addTarget(self, action: #selector(openApp), for: .touchUpInside)

    var done = UIButton.Configuration.plain()
    done.title = "Done"
    done.buttonSize = .large
    doneButton.configuration = done
    doneButton.addTarget(self, action: #selector(finish), for: .touchUpInside)

    let stack = UIStackView(arrangedSubviews: [spinner, titleLabel, detailLabel, openButton, doneButton])
    stack.axis = .vertical
    stack.spacing = 10
    stack.setCustomSpacing(18, after: detailLabel)
    stack.setCustomSpacing(4, after: openButton)
    stack.translatesAutoresizingMaskIntoConstraints = false
    card.addSubview(stack)

    NSLayoutConstraint.activate([
      card.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      card.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      card.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
      card.widthAnchor.constraint(lessThanOrEqualToConstant: 460),
      stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 24),
      stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
      stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
      stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
    ])
  }

  private func show(title: String, detail: String?, saved: Bool) {
    titleLabel.text = title
    detailLabel.text = detail
    detailLabel.isHidden = detail == nil
    openButton.isHidden = !saved
    let working = detail == nil && !saved
    spinner.isHidden = !working
    if working { spinner.startAnimating() } else { spinner.stopAnimating() }
    doneButton.isHidden = working
  }

  @objc private func finish() {
    extensionContext?.completeRequest(returningItems: nil)
  }

  /// Share extensions can't call UIApplication.open directly, so find the
  /// app in the responder chain and send it the open-URL message.
  @objc private func openApp() {
    let selector = NSSelectorFromString("openURL:options:completionHandler:")
    var responder: UIResponder? = self
    while let current = responder {
      if let app = current as? UIApplication, app.responds(to: selector) {
        typealias Open = @convention(c) (AnyObject, Selector, NSURL, NSDictionary, AnyObject?) -> Void
        let open = unsafeBitCast(app.method(for: selector), to: Open.self)
        open(app, selector, Self.openURL as NSURL, NSDictionary(), nil)
        break
      }
      responder = current.next
    }
    finish()
  }
}
