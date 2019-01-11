//
//  FilesViewController.swift
//  Zedit
//
//  Created by Keith Irwin on 12/30/18.
//  Copyright © 2018 Zentrope. All rights reserved.
//

import Cocoa


class FilesViewController: NSViewController {

    // MARK: - Definitions

    enum Section: String {
        case folders = "Folders"
        case files = "Files"

        static let all: [Section] = [.folders, .files]
    }

    // MARK: - Outlets

    @IBOutlet weak var outlineView: NSOutlineView!
    @IBOutlet var dropView: FilesDropView!

    // MARK: - Context menu items

    let removeFromSidebar = NSMenuItem(
        title: "Remove from navigator",
        action: #selector(removeFromNavigator),
        keyEquivalent: "")

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        outlineView.dataSource = self
        outlineView.delegate = self
        outlineView.menu?.delegate = self
        outlineView.expandItem(Section.folders)
        outlineView.expandItem(Section.files)
        EventManager.register(receiver: self)
    }

    // MARK: - Actions
    @IBAction func clicked(_ sender: NSOutlineView) {
        // Invoked on any row, regardless of selectability
        // print("clicked on \(sender.clickedRow)")
    }

    @IBAction func doubleClicked(_ sender: NSOutlineView) {
        let item = sender.item(atRow: sender.clickedRow)
        if sender.isItemExpanded(item) {
            sender.collapseItem(item)
        } else {
            sender.expandItem(item)
        }
    }

}

// MARK: - Event Manager Receiver
extension FilesViewController: EventReceiver {
    func receive(event: EventType) {
        switch event {

        case .AddFiles(let urls):
            BufferManager.shared.append(urls: urls)
            self.outlineView.reloadData()

        case .BufferDirtied(let buffer):
            outlineView.reloadItem(buffer)

        case .BufferSaved(let buffer):
            outlineView.reloadItem(buffer)

        case .BufferFocussed(let buffer):
            // When the buffer is switched via some other mechanism, make sure we
            // do what we can do see it before attempting to select it.
            outlineView.reloadData()
            let row = outlineView.row(forItem: buffer)
            if row > 0 {
                outlineView.selectRowIndexes(IndexSet([row]), byExtendingSelection: false)
            }
            
        default:
            break
        }
    }
}

// MARK: - Context Menu Delegate

extension FilesViewController: NSMenuDelegate {

    @objc func removeFromNavigator() {
        if let buffer = outlineView.item(atRow: outlineView.clickedRow) as? Buffer {
            BufferManager.shared.remove(buffer: buffer)
            outlineView.reloadData()
        }
    }

    func menuWillOpen(_ menu: NSMenu) {
        menu.removeAllItems()
        let item = outlineView.item(atRow: outlineView.clickedRow)
        if let _ = outlineView.parent(forItem: item) as? Section {
            menu.addItem(removeFromSidebar)
        }
    }
}

// MARK: - Data Source Delegate
extension FilesViewController: NSOutlineViewDataSource {

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return Section.all.count
        }
        if let section = item as? Section {
            switch section {
            case .files:
                return BufferManager.shared.files.count
            case .folders:
                return BufferManager.shared.folders.count
            }
        }

        if let zf = item as? Buffer {
            if zf.isDirectory {
                return zf.count
            }
        }
        return 0
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            switch index {
            case 0: return Section.folders
            case 1: return Section.files
            default: return Section.folders
            }
        }
        if let section = item as? Section {
            switch section {
            case .files:
                return BufferManager.shared.files[index]
            case .folders:
                return BufferManager.shared.folders[index]
            }
        }

        if let zf = item as? Buffer {
            return zf[index]
        }
        return "?"
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let _ = item as? Section {
            return true
        }
        if let f = item as? Buffer {
            return f.isDirectory
        }
        return false
    }

    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        if let f = item as? Buffer {
            return f.isText
        }
        return false
    }
}

// MARK: - Outline View Delegate
extension FilesViewController: NSOutlineViewDelegate {

    func outlineViewSelectionDidChange(_ notification: Notification) {
        // Invoked on items the delegate has deemed "selectable"
        let row = outlineView.selectedRow
        if row < 0 {
            print("Rejecting selection change \(row)")
            return
        }
        if let buffer = outlineView.item(atRow: row) as? Buffer {
            BufferManager.shared.focused = buffer
            EventManager.pub(.BufferVisited(buffer))
        }
    }

    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 22.0
    }

    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        if let _ = item as? Section {
            return true
        }
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        switch item {
        case let section as Section:
            let id = NSUserInterfaceItemIdentifier("HeaderCell")
            let view = outlineView.makeView(withIdentifier: id, owner: nil) as? NSTableCellView
            view?.textField?.stringValue = section.rawValue
            view?.textField?.sizeToFit()
            return view

        case let buffer as Buffer:
            let id = NSUserInterfaceItemIdentifier("DataCell")
            let view = outlineView.makeView(withIdentifier: id, owner: nil) as? NSTableCellView
            view?.textField?.stringValue = buffer.name
            view?.imageView?.image = buffer.icon
            if buffer.isText || buffer.isDirectory {
                view?.textField?.textColor = NSColor.controlColor
            } else {
                view?.textField?.textColor = NSColor.systemGray
            }
            view?.textField?.sizeToFit()
            return view

        default:
            return nil
        }
    }
}
