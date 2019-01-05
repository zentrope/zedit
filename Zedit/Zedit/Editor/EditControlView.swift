//
//  EditControlView.swift
//  Zedit
//
//  Created by Keith Irwin on 12/30/18.
//  Copyright © 2018 Zentrope. All rights reserved.
//

import Cocoa

class EditControlView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        self.wantsLayer = true
        if let l = self.layer {
            l.backgroundColor = NSColor.textBackgroundColor.cgColor
        }
    }
    
}
