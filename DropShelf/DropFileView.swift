import AppKit
import OSLog

let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.kruti.MenuBar-POC",
    category: "file-actions"
)

class DropFileView: NSView {
    
    private var clearButton: NSButton?
    
    // Storage
    private(set) var fileStorage: [URL] = []

    // Finder-style layout constants
    private let itemWidth: CGFloat = 96
    private let itemHeight: CGFloat = 110
    private let itemSpacing: CGFloat = 16

    private let contentInset = NSEdgeInsets(
        top: 16,
        left: 16,
        bottom: 16,
        right: 16
    )

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        registerForDraggedTypes([.fileURL])
    }

    // MARK: - Drop files into the panel
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if sender.draggingSource is FileItemView {
            return []
        }
        return .copy
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard

        guard let urls = pasteboard.readObjects(
            forClasses: [NSURL.self]
        ) as? [URL] else {
            return false
        }

        let startIndex = fileStorage.count
        fileStorage.append(contentsOf: urls)
        
        if !fileStorage.isEmpty {
            if clearButton == nil {
                let button = NSButton(title: "Clear Shelf", target: self, action: #selector(clearShelf))
                button.setButtonType(NSButton.ButtonType.momentaryPushIn)
                button.bezelStyle = .rounded
                // Place the button in the top-right inside content inset
                let buttonSize = NSSize(width: 100, height: 30)
                let x = bounds.width - contentInset.right - buttonSize.width
                let y = bounds.height - contentInset.top - buttonSize.height
                button.frame = NSRect(origin: CGPoint(x: x, y: y), size: buttonSize)
                addSubview(button)
                clearButton = button
            }
        }

        for (offset, url) in urls.enumerated() {
            addFileItem(for: url, at: startIndex + offset)
        }

        logger.info("Files stored: \(self.fileStorage)")
        return true
    }
    
    // MARK: - Actions
    @objc private func clearShelf() {
        // Clear storage
        fileStorage.removeAll()
        // Remove file item subviews (leave the button for now)
        for subview in subviews {
            if !(subview is NSButton) {
                subview.removeFromSuperview()
            }
        }
        // Remove and clear the button reference
        clearButton?.removeFromSuperview()
        clearButton = nil
        // Trigger layout update
        needsLayout = true
    }
    
    // MARK: - File Item Rendering
    private func addFileItem(for fileURL: URL, at index: Int) {
        let itemView = FileItemView(fileURL: fileURL)
        itemView.frame.origin = originForItem(at: index)
        addSubview(itemView)
    }

    // MARK: - Layout Helpers
    private func originForItem(at index: Int) -> CGPoint {

        let usableWidth = bounds.width
            - contentInset.left
            - contentInset.right

        let columns = max(
            Int(usableWidth / (itemWidth + itemSpacing)),
            1
        )

        let row = index / columns
        let column = index % columns

        let x = contentInset.left
            + CGFloat(column) * (itemWidth + itemSpacing)

        let y = bounds.height
            - contentInset.top
            - CGFloat(row + 1) * (itemHeight + itemSpacing)

        return CGPoint(x: x, y: y)
    }

    // MARK: - Relayout on Resize
    override func layout() {
        super.layout()

        for (index, view) in subviews.enumerated() {
            view.frame.origin = originForItem(at: index)
        }
        
        if let button = clearButton {
            let buttonSize = button.frame.size
            let x = bounds.width - contentInset.right - buttonSize.width
            let y = bounds.height - contentInset.top - buttonSize.height
            button.frame.origin = CGPoint(x: x, y: y)
        }
    }
}


