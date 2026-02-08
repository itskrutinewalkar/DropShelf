<!-- README.md (Markdown) -->

# DropShelf 🗂️

**DropShelf** is a lightweight macOS utility that acts as a **temporary file shelf**. It allows users to drag files from anywhere, park them temporarily, and later drag them out to a destination folder — reducing the friction of multi-file drag-and-drop workflows on macOS.

Think of it as a **clipboard for files**, but visual, persistent, and drag-friendly.

---

## 🚀 Motivation

On macOS, moving multiple files across folders, spaces, or apps often requires:

* Keeping a Finder window open
* Holding long drag paths
* Using cut–paste workflows that lack visibility

DropShelf solves this by providing:

* A **temporary holding area** for files
* A **visual overview** of what you’re moving
* A **drag-anytime, drop-anywhere** experience

---

## ✨ Features

* 📥 **Drag files into DropShelf** from Finder or Desktop
* 📤 **Drag files out** to any folder or app that accepts file drops
* 🧾 **Finder-style file icons and full filenames**
* 🧩 **Menu bar–based lightweight UI** (non-intrusive)
* 🗃️ **Temporary storage only** — no permanent file duplication
* ⚡ Native macOS implementation using AppKit

---

## 🧠 How It Works (High-Level)

1. Files dropped into DropShelf are **referenced**, not duplicated
2. Metadata such as:

   * File URL
   * Display name
   * Finder icon
     is extracted and stored temporarily
3. When a user drags files out:

   * A new `NSDraggingSession` is initiated
   * The original file URLs are provided to the destination
4. Once the app is closed, the shelf is cleared

---

## 🛠️ Tech Stack

* **Language:** Swift
* **Framework:** AppKit (macOS native)
* **Architecture:** MVC-style
* **Key APIs Used:**

  * `NSDraggingDestination`
  * `NSDraggingSource`
  * `NSDraggingSession`
  * `NSFilePromiseProvider`
  * `NSImage(forFile:)`

---

## 📂 Project Structure (Simplified)

```
DropShelf/
│
├── AppDelegate.swift        # App lifecycle & menu bar setup
├── DropFileView.swift       # Custom NSView handling drag & drop
├── ShelfItem.swift          # Model representing a dropped file
├── Main.storyboard          # UI layout
├── Assets.xcassets          # App icons & assets
└── README.md
```

---

## 🖥️ UI Overview

* **Menu Bar Icon**: Opens the DropShelf panel
* **Shelf Panel**:

  * Displays dropped files
  * Finder-sized icons
  * Full filenames with padding
* **Drag Interaction**:

  * Click + drag any file from the shelf

---

## 🧪 Current Status

✅ Core drag-in / drag-out functionality implemented
✅ UI prototype working
⚠️ No persistence (by design)
⚠️ No cloud sync (future scope)

---

## 🔮 Future Enhancements

* ⏱️ Auto-clear shelf after configurable time
* 📌 Pin frequently used files
* 🧹 Clear / Remove individual items
* 🖱️ Keyboard shortcuts
* 📁 Multiple shelves or categories
* 🔒 Sandboxing & security hardening

---

## 🆚 Why Not Just Cmd + X / Cmd + V?

| Cmd + X / V | DropShelf           |
| ----------- | ------------------- |
| Invisible   | Visual shelf        |
| One-time    | Multi-step workflow |
| No preview  | Icons + names       |
| Error-prone | Controlled drag     |

DropShelf is about **clarity, control, and flow** — not just copying files.

---

## 📦 Installation

> Currently in development (POC / Prototype)

To run locally:

1. Clone the repository
2. Open in Xcode
3. Build & run on macOS

---

## 🤝 Contribution

This project is currently experimental and educational.

Suggestions, architectural feedback, and UX ideas are welcome.

---

## 👩‍💻 Author

**Kruti Newalkar**
Information Technology | macOS & Systems Enthusiast
Focused on system design, security, and native tooling

---

## 📜 License

MIT License (planned)

---

> *DropShelf is designed to reduce cognitive load and improve everyday developer and power-user workflows on macOS.*
