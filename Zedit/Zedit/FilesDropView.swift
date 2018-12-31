//
//  FilesDropView.swift
//  Zedit
//
//  Created by Keith Irwin on 12/30/18.
//  Copyright © 2018 Zentrope. All rights reserved.
//

import Cocoa

class FilesDropView: NSView {

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.registerForDraggedTypes([NSPasteboard.PasteboardType.URL])
//        fatalError("init(coder:) has not been implemented")

    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        print("DRAGGING ENTERED")
        return .copy
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation  {
        return NSDragOperation.copy
    }

    override func draggingEnded(_ sender: NSDraggingInfo) {
        print("ENDED \(sender)")
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pb = sender.draggingPasteboard
        if let urls = pb.readObjects(forClasses: [NSURL.self], options: [:]) as? [URL] {
            for url in urls {
                print("- \(url)")
                let u = FileManager.default.isUbiquitousItem(at: url)
                print(" - ubiq? \(u)")
            }
        }
        return true
    }

}

