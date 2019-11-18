//
//  RichEditorToolbar.swift
//
//  Created by Caesar Wirth on 4/2/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit

/// RichEditorToolbarDelegate is a protocol for the RichEditorToolbar.
/// Used to receive actions that need extra work to perform (eg. display some UI)
@objc public protocol RichEditorToolbarDelegate: class {

    /// Called when the Back toolbar item is pressed.
    @objc optional func richEditorToolbarBackToRoot(_ toolbar: RichEditorToolbar)
    
    /// Called when the Text Color toolbar item is pressed.
    @objc optional func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar)

    /// Called when the Background Color toolbar item is pressed.
    @objc optional func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar)

    /// Called when the Insert Image toolbar item is pressed.
    @objc optional func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar)

    /// Called when the Insert Link toolbar item is pressed.
    @objc optional func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar)
    
    /// Called when the Font Sizes toolbar item is pressed.
    @objc optional func richEditorToolbarChangeFontSize(_ toolbar: RichEditorToolbar)
}

/// RichBarButtonItem is a subclass of UIBarButtonItem that takes a callback as opposed to the target-action pattern
@objcMembers open class RichBarButtonItem: UIBarButtonItem {
    open var actionHandler: (() -> Void)?
    
    private(set) var size: CGSize = .zero
    private(set) var font: UIFont = UIFont.systemFont(ofSize: 14)
    
    public convenience init(image: UIImage? = nil,
                            handler: (() -> Void)? = nil) {
        
        self.init(image: image, style: .plain, target: nil, action: nil)
        
        target = self
        action = #selector(RichBarButtonItem.buttonWasTapped)
        
        self.actionHandler = handler
        
        let minS = min(image?.size.width ?? 28, image?.size.height ?? 28)
        self.size = CGSize(width: minS, height: minS)
    }
    
    public convenience init(title: String = "",
                            font: UIFont = UIFont.systemFont(ofSize: 14),
                            handler: (() -> Void)? = nil) {
        
        self.init(title: title, style: .plain, target: nil, action: nil)
        
        target = self
        action = #selector(RichBarButtonItem.buttonWasTapped)
                
        self.actionHandler = handler
        self.font = font
        
        let attributes: [NSAttributedString.Key : Any] = [.font: self.font]
        self.setTitleTextAttributes(attributes, for: .normal)
        self.setTitleTextAttributes(attributes, for: .selected)

        let titleSize = title.size(withAttributes:[.font: self.font])
        let fixedSize = CGSize(width: titleSize.width + 12, height: titleSize.height)
        self.size = fixedSize
    }
    
    @objc func buttonWasTapped() {
        actionHandler?()
    }
}

/// RichEditorToolbar is UIView that contains the toolbar for actions that can be performed on a RichEditorView
@objcMembers open class RichEditorToolbar: UIView {

    /// The delegate to receive events that cannot be automatically completed
    open weak var delegate: RichEditorToolbarDelegate?

    /// A reference to the RichEditorView that it should be performing actions on
    open weak var editor: RichEditorView?
    
    /// Center or not the toolbar items
    open var centered: Bool = false

    /// The list of options to be displayed on the toolbar
    open var options: [RichEditorOption] = [] {
        didSet {
            updateToolbar()
        }
    }

    /// The tint color to apply to the toolbar background.
    open var barTintColor: UIColor? {
        get { return backgroundToolbar.barTintColor }
        set { backgroundToolbar.barTintColor = newValue }
    }

    private var toolbarScroll: UIScrollView
    private var toolbar: UIToolbar
    private var backgroundToolbar: UIToolbar
    
    private var decelerationRate: UIScrollView.DecelerationRate
    
    public override init(frame: CGRect) {
        toolbarScroll = UIScrollView()
        toolbar = UIToolbar()
        backgroundToolbar = UIToolbar()
        decelerationRate = .fast
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        toolbarScroll = UIScrollView()
        toolbar = UIToolbar()
        backgroundToolbar = UIToolbar()
        decelerationRate = .fast
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        autoresizingMask = .flexibleWidth
        backgroundColor = .clear

        backgroundToolbar.frame = bounds
        backgroundToolbar.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        toolbar.autoresizingMask = .flexibleWidth
        toolbar.backgroundColor = .clear
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

        toolbarScroll.frame = bounds
        toolbarScroll.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        toolbarScroll.showsHorizontalScrollIndicator = false
        toolbarScroll.showsVerticalScrollIndicator = false
        toolbarScroll.backgroundColor = .clear
        toolbarScroll.decelerationRate = decelerationRate

        toolbarScroll.addSubview(toolbar)

        addSubview(backgroundToolbar)
        addSubview(toolbarScroll)
        updateToolbar()
    }
    
    private func updateToolbar() {
        
        var buttons = [RichBarButtonItem]()
        
        for option in options {
            let handler = { [weak self] in
                if let strongSelf = self {
                    option.action(strongSelf)
                }
            }

            if let image = option.image {
                let button = RichBarButtonItem(image: image, handler: handler)
                buttons.append(button)
            } else {
                let title = option.title
                let button = RichBarButtonItem(title: title, handler: handler)
                buttons.append(button)
            }
        }
        
        if centered {
            buttons.insert(RichBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), at: 0)
            buttons.insert(RichBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), at: buttons.count)
        }
        
        toolbar.setItems(buttons, animated: true)

        let barButtonItemMargin: CGFloat = 12
        
        let width: CGFloat = buttons.reduce(0) { sofar, new in
            return sofar + (new.size.width + barButtonItemMargin)
        }
        
        if width < frame.size.width {
            toolbar.frame.size.width = frame.size.width + barButtonItemMargin
        } else {
            toolbar.frame.size.width = width + barButtonItemMargin
        }
        toolbar.frame.size.height = 44
        toolbarScroll.contentSize.width = width + barButtonItemMargin
    }
    
}
