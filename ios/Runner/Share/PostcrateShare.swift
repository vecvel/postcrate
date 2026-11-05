import UIKit

/// Native sharing for Postcrate. See docs/sharing-architecture.md.
///
/// 1. The caption is written to UIPasteboard before anything opens, so apps
///    that strip pre-filled text (Facebook, Instagram) can be pasted into.
/// 2. Images go in as UIImage, other media as file URLs.
/// 3. Text goes in through an item source that withholds it from apps known
///    to drop or mishandle text alongside media.
/// 4. The iPad popover is always anchored, so the sheet never crashes there.
enum PostcrateShare {
  /// Activity types (or fragments of them) that ignore pre-filled text.
  static let textStrippingActivities = [
    "com.facebook.Facebook.ShareExtension",
    "com.burbn.instagram.shareextension",
    "com.zhiliaoapp.musically",
    "com.toyopagroup.picaboo",
  ]

  struct Item {
    let url: URL
    let mimeType: String
  }

  enum Outcome {
    case completed(activity: String)
    case dismissed
    case unavailable
  }

  /// Convenience for the common case: one image plus a caption.
  static func share(
    image: UIImage,
    text: String,
    from presenter: UIViewController,
    sourceRect: CGRect? = nil,
    completion: @escaping (Outcome) -> Void
  ) {
    present(items: [image], text: text, subject: nil, from: presenter, sourceRect: sourceRect, completion: completion)
  }

  /// Shares files (any supported type) plus text.
  static func share(
    files: [Item],
    text: String,
    subject: String?,
    from presenter: UIViewController,
    sourceRect: CGRect?,
    completion: @escaping (Outcome) -> Void
  ) {
    var items: [Any] = []
    for file in files {
      // GIFs stay as files to keep animation; other images go in as UIImage.
      if file.mimeType.hasPrefix("image/"), file.mimeType != "image/gif",
         let image = UIImage(contentsOfFile: file.url.path) {
        items.append(image)
      } else {
        items.append(file.url)
      }
    }
    present(items: items, text: text, subject: subject, from: presenter, sourceRect: sourceRect, completion: completion)
  }

  private static func present(
    items media: [Any],
    text: String,
    subject: String?,
    from presenter: UIViewController,
    sourceRect: CGRect?,
    completion: @escaping (Outcome) -> Void
  ) {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    if !trimmed.isEmpty {
      UIPasteboard.general.string = trimmed
    }

    var items = media
    if !trimmed.isEmpty {
      items.append(CaptionItemSource(text: trimmed, subject: subject, hasMedia: !media.isEmpty))
    }
    guard !items.isEmpty else {
      completion(.unavailable)
      return
    }

    let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
    controller.excludedActivityTypes = [.assignToContact, .addToReadingList, .openInIBooks]

    if let popover = controller.popoverPresentationController {
      popover.sourceView = presenter.view
      if let rect = sourceRect, !rect.isEmpty {
        popover.sourceRect = rect
        popover.permittedArrowDirections = .any
      } else {
        let bounds = presenter.view.bounds
        popover.sourceRect = CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0)
        popover.permittedArrowDirections = []
      }
    }

    controller.completionWithItemsHandler = { activityType, completed, _, error in
      if completed, let type = activityType {
        completion(.completed(activity: type.rawValue))
      } else if error != nil {
        completion(.unavailable)
      } else {
        completion(.dismissed)
      }
    }

    presenter.present(controller, animated: true)
  }

  /// Text item that is withheld from apps which strip text when media is attached.
  private final class CaptionItemSource: NSObject, UIActivityItemSource {
    let text: String
    let subject: String?
    let hasMedia: Bool

    init(text: String, subject: String?, hasMedia: Bool) {
      self.text = text
      self.subject = subject
      self.hasMedia = hasMedia
    }

    func activityViewControllerPlaceholderItem(_ controller: UIActivityViewController) -> Any {
      text
    }

    func activityViewController(_ controller: UIActivityViewController, itemForActivityType type: UIActivity.ActivityType?) -> Any? {
      guard let raw = type?.rawValue else { return text }
      if hasMedia, PostcrateShare.textStrippingActivities.contains(where: { raw.hasPrefix($0) }) {
        return nil
      }
      return text
    }

    func activityViewController(_ controller: UIActivityViewController, subjectForActivityType type: UIActivity.ActivityType?) -> String {
      subject ?? ""
    }
  }
}
