//
//  ViewController.swift
//  RichEditorViewSample
//
//  Created by Caesar Wirth on 4/5/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit
import RichEditorView

class ViewController: UIViewController {

    @IBOutlet var editorView: RichEditorView!
    @IBOutlet var htmlTextView: UITextView!
    
    private lazy var editorOptions: [RichEditorDefaultOption] = {
        return RichEditorDefaultOption.all// [.header(1), .header(2), .header(3), .header(4), .header(5), .header(6)]
    }()

    private lazy var toolbar: RichEditorToolbar = {
        
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.delegate = self
        
        if #available(iOS 13.0, *) {
            toolbar.options = editorOptions
            editorView.inputAccessoryView = toolbar
        } else {
            toolbar.options = editorOptions
            editorView.inputAccessoryView = toolbar
        }
        
        toolbar.editor = editorView
        
        return toolbar
    }()
    
    private lazy var keyboardManager: KeyboardManager? = {
        if #available(iOS 13.0, *) {
            toolbar.editor = editorView
            return nil
        } else {
            
            var km = KeyboardManager(view: self.view, toolbar: self.toolbar)
            editorView.inputAccessoryView = self.toolbar
            return km
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editorView.delegate = self
        editorView.placeholder = "Edit here"
        
        editorView.html = "<b>Jesus is God.</b> He saves by grace through faith alone. Soli Deo gloria! <a href='https://perfectGod.com'>perfectGod.com</a>"
        
        // This will create a custom action that clears all the input text when it is pressed
        //        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
        //            toolbar?.editor?.html = ""
        //        }
        //
        //        var options = toolbar.options
        //        options.append(item)
        //        toolbar.options = options
    }
    
    func keyboardDisplayDoesNotRequireUserAction() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let km = self.keyboardManager {
            km.beginMonitoring()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if let km = self.keyboardManager {
            km.stopMonitoring()
        }
    }
}

extension ViewController: RichEditorDelegate {

    func richEditor(_ editor: RichEditorView, heightDidChange height: Int) { }

    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
            htmlTextView.text = "HTML Preview"
        } else {
            htmlTextView.text = content
        }
    }

    func richEditorTookFocus(_ editor: RichEditorView) {

    }
    
    func richEditorLostFocus(_ editor: RichEditorView) {

    }
    
    func richEditorDidLoad(_ editor: RichEditorView) {
        editorView.focus()
    }
    
    func richEditor(_ editor: RichEditorView, shouldInteractWith url: URL) -> Bool { return true }

    func richEditor(_ editor: RichEditorView, handleCustomAction content: String) { }
    
}

extension ViewController: RichEditorToolbarDelegate {

    fileprivate func randomColor() -> UIColor {
        let colors = [
            UIColor.red,
            UIColor.orange,
            UIColor.yellow,
            UIColor.green,
            UIColor.blue,
            UIColor.purple
        ]

        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }

    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }

    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }

    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        toolbar.editor?.insertImage("https://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
    }

    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
//        if let hasSelection = toolbar.editor?.rangeSelectionExists(), hasSelection {
//            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
//        }
    }
}
