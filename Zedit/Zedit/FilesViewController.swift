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

    let headers = ["Folders", "Files"]

    // MARK: - Outlets

    @IBOutlet weak var outlineView: NSOutlineView!
    @IBOutlet var dropView: FilesDropView!

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dropView.delegate = self
        outlineView.dataSource = self
        outlineView.delegate = self
    }

}

extension FilesViewController: FilesDropViewDelegate {

    func droppedURLs(_ urls: [URL]) {
        for url in urls {
            let u = FileManager.default.isUbiquitousItem(at: url)
            print("- \(url) :: iCloud? \(u)")
        }
    }
}

extension FilesViewController: NSOutlineViewDataSource {

    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        print("acceptDrop")
        return true
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return headers.count
        }
        return 0
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return headers[index]
        }
        return "?"
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }

    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        return false
    }
}

extension FilesViewController: NSOutlineViewDelegate {

    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 22.0
    }

    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        switch item {
        case let h as String:
            let id = NSUserInterfaceItemIdentifier("HeaderCell")
            let view = outlineView.makeView(withIdentifier: id, owner: nil) as? NSTableCellView
            view?.textField?.stringValue = h
            view?.textField?.sizeToFit()
            return view

        default:
            return nil
        }
    }
}
