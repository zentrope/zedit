//
//  EditTextViewController.swift
//  
//
//  Created by Keith Irwin on 12/30/18.
//

import Cocoa

class EditTextViewController: NSViewController {

    // MARK: - Outlets

    @IBOutlet var textView: EditTextView!

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.textContainerInset = NSMakeSize(10, 10)
        textView.font = NSFont.userFixedPitchFont(ofSize: 12)

        textView.string = """
        # Markdown

        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
    }

    // MARK: - Actions
    @IBAction func onRefreshButtonClick(_ sender: NSButton) {
        print("Refresh button!")
    }
}
