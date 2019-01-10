//
//  BufferManager.swift
//  Zedit
//
//  Created by Keith Irwin on 1/9/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Foundation

class BufferManager {

    static var shared = BufferManager()

    var folders = [Buffer]()
    var files = [Buffer]()
    var focused: Buffer?

    func remove(buffer: Buffer) {
        if buffer.isDirectory {
            folders.removeAll { $0 === buffer }
        } else {
            files.removeAll { $0 === buffer }
        }
    }

    func save(to buffer: Buffer, contents: String) throws {
        try buffer.save(content: contents)
    }

    func append(urls: [URL]) {
        urls.forEach {
            append(buffer: Buffer(at: $0))
        }
    }

    func append(buffer: Buffer) {
        if buffer.isDirectory  {
            if Set(self.folders).contains(buffer) {
                return
            }
            self.folders.append(buffer)
        } else {
            if Set(self.files).contains(buffer) {
                return
            }
            self.files.append(buffer)
        }
    }

}
