//
//  ViewController.swift
//  RichEditorViewSample
//
//  Created by Caesar Wirth on 4/5/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit
import RichEditorView
import Gridicons

class ViewController: UIViewController {

    @IBOutlet var editorView: RichEditorView!
    @IBOutlet var htmlTextView: UITextView!
    
    private lazy var editorOptions: [RichEditorOption] = {
        var options: [RichEditorOption] = [self.fontSizesItem,
                                           RichEditorDefaultOption.bold,
                                           RichEditorDefaultOption.italic,
                                           RichEditorDefaultOption.underline,
                                           self.alignItem]
        
        //options.insert(self.alignItem, at: options.count)
        //options.insert(self.fontSizesItem, at: options.count)

        return options
    }()
    
    private lazy var fontSizesEditorOptions: [RichEditorDefaultOption] = {
        return [.fontSize(1),
                .fontSize(2),
                .fontSize(3),
                .fontSize(4),
                .fontSize(5),
                .fontSize(6),
                .fontSize(7)]
    }()
    
    private lazy var alignTextEditorOptions: [RichEditorDefaultOption] = {
        return [.alignLeft,
                .alignCenter,
                .alignRight,
                .alignJustify]
    }()
    
    private lazy var backItem: RichEditorOptionItem = RichEditorOptionItem(image: Gridicon.iconOfType(.arrowLeft), title: "tool_text_back") { toolbar in
        toolbar.options = self.editorOptions
    }
    
    private lazy var fontSizesItem: RichEditorOptionItem = RichEditorOptionItem(image: UIImage(named: "text_size_icon",
                                                                                               in: Bundle(for: RichEditorView.self),
                                                                                               compatibleWith: nil), title: "tool_text_sizes") { toolbar in
                                                                                                
                                                                                                var options: [RichEditorOption] = self.fontSizesEditorOptions
                                                                                                options.insert(self.backItem, at: 0)
                                                                                                
                                                                                                toolbar.options = options
    }
    
    private lazy var alignItem: RichEditorOptionItem = RichEditorOptionItem(image: Gridicon.iconOfType(.alignLeft), title: "tool_text_alignments") { toolbar in
        
        var options: [RichEditorOption] = self.alignTextEditorOptions
        options.insert(self.backItem, at: 0)
        toolbar.options = options
    }

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
    
}
