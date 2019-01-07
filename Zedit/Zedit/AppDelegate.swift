//
//  AppDelegate.swift
//  Zedit
//
//  Created by Keith Irwin on 12/30/18.
//  Copyright © 2018 Zentrope. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        let urls = filenames.map { URL(fileURLWithPath: $0)}
        EventManager.pub(.AddFiles(urls))
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        // This will make the main window appear if it has been closed
        // and the user clicks the app icon, or ⌘-Tabs to the app.

        func noVisibleWindows() -> Bool {
            for w in NSApp.windows {
                if w.isVisible {
                    return false
                }
            }
            return true
        }

        if noVisibleWindows() {
            MainWindowController.show()
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // When the user clicks on the app-icon and there's no window, open a window.

        if !flag {
            MainWindowController.show()
        }
        return true
    }

}

