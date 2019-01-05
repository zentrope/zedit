//
//  Buffer.swift
//  Zedit
//
//  Created by Keith Irwin on 1/4/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

class Buffer: Hashable {
    // Not sure 'Buffer' is quite the right word, here, but neither is file.
    
    var isDirectory: Bool { get { return url.isDirectory() }}
    var count: Int { get { reload() ; return children.count }}
    var name: String { get { return url.lastPathComponent }}
    var icon: NSImage { get { return url.icon() }}
    
    private var url: URL
    private var children = [Buffer]()

    init(at url: URL) {
        self.url = url
    }

    static func == (lhs: Buffer, rhs: Buffer) -> Bool {
        return lhs.url == rhs.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }

    subscript(index: Int) -> Buffer {
        return children[index]
    }

    func contents() -> String? {
        if isDirectory {
            return nil
        }
        if let data = FileManager.default.contents(atPath: url.path) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    private func reload() {
        var results: [Buffer] = [Buffer]()
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsPackageDescendants]
        let props: [URLResourceKey] = [.isPackageKey, .isApplicationKey, .isDirectoryKey]
        let fm = FileManager.default
        do {
            let urls = try fm.contentsOfDirectory(at: url, includingPropertiesForKeys: props, options: options)
            for url in urls {
                if url.isPackage() || url.isApplication() {
                    continue
                }
                results.append(Buffer(at: url))
            }
        }
        catch let err {
            print("ERROR: \(err)")
        }
        children = results
    }
}
