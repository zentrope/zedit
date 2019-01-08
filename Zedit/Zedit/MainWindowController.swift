//
//  MainWindowController.swift
//  Zedit
//
//  Created by Keith Irwin on 1/3/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    static var shared: MainWindowController?

    override func windowDidLoad() {
        super.windowDidLoad()
        MainWindowController.shared = self
    }

    static func show() {
        shared?.window?.makeKeyAndOrderFront(self)
    }

    @objc func openDocument(_ sender: NSMenuItem) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = true
        panel.canChooseFiles = true
        panel.resolvesAliases = true

        panel.beginSheetModal(for: self.window!) { response in
            if response == .OK {
                EventManager.pub(.AddFiles(panel.urls))
            }
        }
    }

}
