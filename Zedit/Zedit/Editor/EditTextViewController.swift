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
        EventManager.register(receiver: self)
        textView.textContainerInset = NSMakeSize(40, 20)
        textView.font = NSFont.userFixedPitchFont(ofSize: 12)
        textView.delegate = self

        textView.string = """
        # Markdown

        Click on a document in the sidebar to visit that document.
        """
    }

    private func visit(buffer: Buffer) {
        if !buffer.isText {
            return
        }
        if let text = buffer.contents() {
            textView.string = text
        }
    }
    
    // MARK: - Actions

    @IBAction func onRefreshButtonClick(_ sender: NSButton) {
        let c = type(of: self)
        print("[\(c)] Refresh button!")
    }

    // MARK: - Menu Actions

    @objc func saveDocument(_ sender: NSMenuItem) {
        print("got a save document request")
        if let b = BufferManager.shared.focused {
            do {
                try BufferManager.shared.save(to: b, contents: textView.string)
                b.isDirty = false
                EventManager.pub(.BufferSaved(b))
            }
            catch let error {
                print("ERROR: \(error)")
            }
        }
    }
}

// MARK: - Event Manager Receiver

extension EditTextViewController: EventReceiver {
    func receive(event: EventType) {
        switch event {
        case .BufferVisited(let buffer):
            visit(buffer: buffer)
        default:
            break
        }
    }
}

// MARK: - Text View Delegate

extension EditTextViewController: NSTextViewDelegate {

    func textDidChange(_ notification: Notification) {
        if let b = BufferManager.shared.focused {
            if !b.isDirty {
                print("setting buffer to dirty")
                b.isDirty = true
                EventManager.pub(.BufferDirtied(b))
            }
        }
    }

}
