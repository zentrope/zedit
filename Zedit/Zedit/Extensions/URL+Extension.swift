//
//  URL+Extension.swift
//  Zedit
//
//  Created by Keith Irwin on 1/4/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

extension URL {

    func isDirectory() -> Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
    }

    func isApplication() -> Bool {
        return (try? resourceValues(forKeys: [.isApplicationKey]))?.isApplication ?? false
    }

    func isPackage() -> Bool {
        return (try? resourceValues(forKeys: [.isPackageKey]))?.isPackage ?? false
    }

    func icon() -> NSImage {
        return NSWorkspace.shared.icon(forFile: self.path)
    }

    func fileReferenceURL() -> NSURL? {
        return (self as NSURL).fileReferenceURL() as NSURL?
    }

}
