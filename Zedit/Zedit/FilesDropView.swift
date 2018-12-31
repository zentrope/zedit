//
//  FilesDropView.swift
//  Zedit
//
//  Created by Keith Irwin on 12/30/18.
//  Copyright © 2018 Zentrope. All rights reserved.
//

import Cocoa

protocol FilesDropViewDelegate {
    func droppedURLs(_ urls: [URL])
}

class FilesDropView: NSView {

    var delegate: FilesDropViewDelegate?

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

    override func draggingEnded(_ sender: NSDraggingInfo) {
        print("ENDED \(sender)")
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pb = sender.draggingPasteboard
        if let urls = pb.readObjects(forClasses: [NSURL.self], options: [:]) as? [URL] {
            delegate?.droppedURLs(urls)
        }
        return true
    }

}

