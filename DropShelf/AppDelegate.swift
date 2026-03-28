import AppKit
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var statusItem: NSStatusItem
    var windowController: NSWindowController?
    var isWindowVisible = false
    var floatingWindow: FloatingPanel?
    

    override init() {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        super.init()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // Configure the status item's button
        if let button = statusItem.button {
            if let image = NSImage(systemSymbolName: "document.badge.plus", accessibilityDescription: "Add") {
                image.isTemplate = true // Use template so it adapts to light/dark menu bar
                button.image = image
            } else if let fallback = NSImage(named: "custom.document.badge.plus.rectangle.stack.fill") {
                fallback.isTemplate = true
                button.image = fallback
            }
            button.target = self
            button.action = #selector(statusBarClicked)
        }
        
    }

    @objc func statusBarClicked() {
        if isWindowVisible {
            showQuitMenu()
        } else {
            showWindow()
        }
    }
    
    func showQuitMenu() {
        // Create a basic menu
        let menu = NSMenu()
        menu.addItem(
            NSMenuItem(
                title: "Quit",
                action: #selector(quitApp),
                keyEquivalent: "q"
            )
        )
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }
    
    @objc func quitApp(){
        NSApplication.shared.terminate(nil)
    }
    
    func showWindow() {
        if windowController == nil {
            let panel = FloatingPanel(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
                backing: .buffered,
                defer: false
            )
            
            panel.center()
            panel.title = "DropDock"
            panel.isReleasedWhenClosed = false

            panel.delegate = self
            
            //Add DropView
            let dropView = DropFileView(frame: panel.contentRect(forFrameRect: panel.frame))
            dropView.autoresizingMask = [.width, .height]
            
            panel.contentView = dropView
            
            windowController = NSWindowController(window: panel)
        }
        
        windowController?.showWindow(self)
        //NSApp.activate(ignoringOtherApps: true)
        isWindowVisible = true
    }
    
    func windowWillClose(_ notification: Notification) {
        isWindowVisible = false
    }
}


