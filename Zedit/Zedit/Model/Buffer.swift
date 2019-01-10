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
    var isText: Bool { get { return isTextFile() }}
    var isDirty = false

    var count: Int { get { reload() ; return children.count }}
    var name: String { get { return url.lastPathComponent + (isDirty ? "*" : "") }}
    var icon: NSImage { get { return url.icon() }}

    private var url: URL
    private var children = [Buffer]()

    init(at url: URL) {
        if let actual = try? URL(resolvingAliasFileAt: url) {
            self.url = actual
        } else {
            self.url = url.resolvingSymlinksInPath()
        }
    }

    static func == (lhs: Buffer, rhs: Buffer) -> Bool {
        return lhs.url == rhs.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
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

    func save(content: String) throws {
        try content.write(to: url, atomically: true, encoding: .utf8)
    }

    subscript(index: Int) -> Buffer {
        return children[index]
    }

    private func isTextFile() -> Bool {
        if let uti = try? NSWorkspace.shared.type(ofFile: url.path) {
            let isText = NSWorkspace.shared.type(uti, conformsToType: "public.text")
            // print("uti=\(uti), isText=\(isText), url=\(url)")
            return isText
        }
        return false
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
