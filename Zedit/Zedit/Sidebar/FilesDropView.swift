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
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation  {
        return .copy
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pb = sender.draggingPasteboard
        if let urls = pb.readObjects(forClasses: [NSURL.self], options: [:]) as? [URL] {
            EventManager.pub(.AddFiles(urls))
        }
        return true
    }

}

