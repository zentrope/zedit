//
//  FilesViewController.swift
//  Zedit
//
//  Created by Keith Irwin on 12/30/18.
//  Copyright © 2018 Zentrope. All rights reserved.
//

import Cocoa

class ZFile: Hashable {

    var url: URL
    var isDirectory = false

    init(at url: URL, isDirectory flag: Bool = false) {
        self.url = url
        self.isDirectory = flag
    }

    static func == (lhs: ZFile, rhs: ZFile) -> Bool {
        return lhs.url == rhs.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }

}

enum Section: String {
    case folders = "Folders"
    case files = "Files"

    static let all: [Section] = [.folders, .files]
}


class FilesViewController: NSViewController {

    // MARK: - Definitions

    var folders = [ZFile]()
    var files = [ZFile]()

    // MARK: - Outlets

    @IBOutlet weak var outlineView: NSOutlineView!
    @IBOutlet var dropView: FilesDropView!

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dropView.delegate = self
        outlineView.dataSource = self
        outlineView.delegate = self

        outlineView.expandItem(Section.folders)
        outlineView.expandItem(Section.files)
    }

    private func appendFile(_ file: ZFile) {
        if file.isDirectory  {
            if Set(self.folders).contains(file) {
                return
            }
            self.folders.append(file)
        } else {
            if Set(self.files).contains(file) {
                return
            }
            self.files.append(file)
        }
    }

}

// MARK: - File Drop Delegate
extension FilesViewController: FilesDropViewDelegate {

    func droppedURLs(_ urls: [URL]) {
        let fm = FileManager.default
        for url in urls {
            print("-(FilesViewController) \(url)")
            let zf = ZFile(at: url, isDirectory: fm.isDirectory(at: url))
            if zf.isDirectory {
                self.appendFile(zf)
            } else {
                self.appendFile(zf)
            }
        }
        self.outlineView.reloadData()
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
                return files.count
            case .folders:
                return folders.count
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
                return files[index] as Any
            case .folders:
                return folders[index] as Any
            }
        }
        return "?"
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let _ = item as? Section {
            return true
        }
        if let f = item as? ZFile {
            return f.isDirectory
        }
        return false
    }

    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        if let f = item as? ZFile {
            return !f.isDirectory
        }
        return false
    }
}

// MARK: - Outline View Delegate
extension FilesViewController: NSOutlineViewDelegate {

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

        case let file as ZFile:
            let id = NSUserInterfaceItemIdentifier("DataCell")
            let view = outlineView.makeView(withIdentifier: id, owner: nil) as? NSTableCellView
            view?.textField?.stringValue = file.url.lastPathComponent
            view?.textField?.sizeToFit()
            return view

        default:
            return nil
        }
    }
}
