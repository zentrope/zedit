//
//  FileManager+Extension.swift
//  Zedit
//
//  Created by Keith Irwin on 1/3/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Foundation

extension FileManager {
    func isDirectory(at url: URL) -> Bool {
        var isDir: ObjCBool = false ;
        let path = url.path
        self.fileExists(atPath: path, isDirectory: &isDir)
        return isDir.boolValue
    }
}

