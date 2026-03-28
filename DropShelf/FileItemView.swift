import AppKit
import UniformTypeIdentifiers

final class FileItemView: NSView, NSDraggingSource {

    // Finder-like constants
    private let iconSize: CGFloat = 64
    private let labelWidth: CGFloat = 96
    private let labelHeight: CGFloat = 34
    private let spacing: CGFloat = 6

    private let iconView = NSImageView()
    private let nameLabel = NSTextField(labelWithString: "")
    private var fileHolder: URL

    init(fileURL: URL) {
        self.fileHolder = fileURL
        super.init(frame: .zero)
        setupIcon(fileURL)
        setupLabel(fileURL)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //On mouseDragged, create an NSDraggingItem and start a dragging session
    override func mouseDragged(with event: NSEvent) {
        // Prepare a file URL pasteboard writer (NSURL conforms to NSPasteboardWriting)
        let pbWriter: NSPasteboardWriting = fileHolder as NSURL

        // Create a dragging item using the pasteboard writer
        let draggingItem = NSDraggingItem(pasteboardWriter: pbWriter)

        // Configure the drag preview image (use the iconView image and bounds)
        let dragImage: NSImage
        if let image = iconView.image {
            dragImage = image
        } else {
            // Fallback to a generic file icon if none is set
            dragImage = NSWorkspace.shared.icon(for: UTType.item)
            dragImage.size = NSSize(width: iconSize, height: iconSize)
        }

        // Use iconView's frame as the visual rect for the drag image
        let draggingFrame = iconView.frame
        draggingItem.setDraggingFrame(draggingFrame, contents: dragImage)

        // Begin a dragging session
        let session = beginDraggingSession(with: [draggingItem], event: event, source: self)
        // Prefer copy by default; the destination (like Finder) decides final operation
        session.draggingFormation = .none
    }

    private func setupIcon(_ fileURL: URL) {
        let icon = NSWorkspace.shared.icon(forFile: fileURL.path)
        icon.size = NSSize(width: iconSize, height: iconSize)

        iconView.image = icon
        iconView.imageScaling = .scaleProportionallyUpOrDown
        iconView.frame = NSRect(
            x: (labelWidth - iconSize) / 2,
            y: labelHeight + spacing,
            width: iconSize,
            height: iconSize
        )
    }

    private func setupLabel(_ fileURL: URL) {
        nameLabel.stringValue = fileURL.lastPathComponent
        nameLabel.alignment = .center
        nameLabel.font = NSFont.systemFont(ofSize: 12)
        nameLabel.maximumNumberOfLines = 2
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.preferredMaxLayoutWidth = labelWidth
        nameLabel.toolTip = fileURL.lastPathComponent

        nameLabel.frame = NSRect(
            x: 0,
            y: 0,
            width: labelWidth,
            height: labelHeight
        )
    }

    private func setupView() {
        frame.size = NSSize(
            width: labelWidth,
            height: iconSize + labelHeight + spacing
        )

        addSubview(iconView)
        addSubview(nameLabel)
    }

    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        switch context {
        case .withinApplication:
            return []
        case .outsideApplication:
            return [.copy, .move]
        @unknown default:
            return [.copy]
        }
    }
    func ignoreModifierKeys(for session: NSDraggingSession) -> Bool {
        // Let modifier keys (Option/Command) influence copy vs move in Finder
        return false
    }

    // Remove the item from the shelf after a successful external drop
    func draggingSession(_ session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        // Only remove if the drop succeeded. In the source delegate, we can't reliably know the destination window.
        // A non-empty operation indicates the drop completed successfully somewhere (e.g., Finder).
        if operation != [] {
            // Clear heavy references to help ARC reclaim memory
            iconView.image = nil
            nameLabel.stringValue = ""
            // Remove from view hierarchy
            removeFromSuperview()
        }
    }
}


