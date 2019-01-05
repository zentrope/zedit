//
//  EditTextViewController.swift
//  
//
//  Created by Keith Irwin on 12/30/18.
//

import Cocoa

class EditTextViewController: NSViewController {

    // MARK: - References

    static var shared: EditTextViewController?

    // MARK: - Outlets

    @IBOutlet var textView: EditTextView!

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        EditTextViewController.shared = self

        textView.textContainerInset = NSMakeSize(40, 20)
        textView.font = NSFont.userFixedPitchFont(ofSize: 12)

        textView.string = """
        # Markdown

        Click on a document in the sidebar to visit that document.
        """
    }

    func visit(buffer: Buffer) {
        if let text = buffer.contents() {
            textView.string = text
        } else {
            textView.string = "_Can't get data for '\(buffer.name)'._"
        }
    }
    
    // MARK: - Actions
    @IBAction func onRefreshButtonClick(_ sender: NSButton) {
        let c = type(of: self)
        print("[\(c)] Refresh button!")
    }
}
