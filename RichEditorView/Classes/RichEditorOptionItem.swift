//
//  RichEditorOptionItem.swift
//
//  Created by Caesar Wirth on 4/2/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit
import Gridicons

/// A RichEditorOption object is an object that can be displayed in a RichEditorToolbar.
/// This protocol is proviced to allow for custom actions not provided in the RichEditorOptions enum.
public protocol RichEditorOption {

    /// The image to be displayed in the RichEditorToolbar.
    var image: UIImage? { get }

    /// The title of the item.
    /// If `image` is nil, this will be used for display in the RichEditorToolbar.
    var title: String { get }

    /// The action to be evoked when the action is tapped
    /// - parameter editor: The RichEditorToolbar that the RichEditorOption was being displayed in when tapped.
    ///                     Contains a reference to the `editor` RichEditorView to perform actions on.
    func action(_ editor: RichEditorToolbar)
}

/// RichEditorOptionItem is a concrete implementation of RichEditorOption.
/// It can be used as a configuration object for custom objects to be shown on a RichEditorToolbar.
public struct RichEditorOptionItem: RichEditorOption {

    /// The image that should be shown when displayed in the RichEditorToolbar.
    public var image: UIImage?

    /// If an `itemImage` is not specified, this is used in display
    public var title: String

    /// The action to be performed when tapped
    public var handler: ((RichEditorToolbar) -> Void)

    public init(image: UIImage?, title: String, action: @escaping ((RichEditorToolbar) -> Void)) {
        self.image = image
        self.title = title
        self.handler = action
    }
    
    // MARK: RichEditorOption
    
    public func action(_ toolbar: RichEditorToolbar) {
        handler(toolbar)
    }
}

/// RichEditorOptions is an enum of standard editor actions
public enum RichEditorDefaultOption: RichEditorOption {

    case back
    case clear
    case undo
    case redo
    case bold
    case italic
    case `subscript`
    case superscript
    case strike
    case underline
    case textColor
    case textBackgroundColor
    case header(Int)
    case fontSize(Int)
    case paragraph
    case indent
    case outdent
    case orderedList
    case unorderedList
    case alignLeft
    case alignCenter
    case alignRight
    case alignJustify
    case image
    case link
    
    public static let all: [RichEditorDefaultOption] = [
        //.clear,
        .undo, .redo, .bold, .italic,
        .subscript, .superscript, .strike, .underline,
        .textColor, .textBackgroundColor,
        .fontSize(1), .fontSize(2), .fontSize(3), .fontSize(4), .fontSize(5), .fontSize(6), .fontSize(7),
        .paragraph,
        .header(1), .header(2), .header(3), .header(4), .header(5), .header(6),
        .indent, outdent, orderedList, unorderedList,
        .alignLeft, .alignCenter, .alignRight, .alignJustify, .image, .link
    ]

    // MARK: RichEditorOption

    public var image: UIImage? {
        var name = ""
        switch self {
        case .back: return Gridicon.iconOfType(.arrowLeft)
        case .clear: return Gridicon.iconOfType(.clearFormatting)
        case .undo: return Gridicon.iconOfType(.undo)
        case .redo: return Gridicon.iconOfType(.redo)
        case .bold: return Gridicon.iconOfType(.bold)
        case .italic: return Gridicon.iconOfType(.italic)
        case .subscript: return Gridicon.iconOfType(.arrowDown)
        case .superscript: return Gridicon.iconOfType(.arrowUp)
        case .strike: return Gridicon.iconOfType(.strikethrough)
        case .underline: return Gridicon.iconOfType(.underline)
        case .textColor: return Gridicon.iconOfType(.textColor)
        case .textBackgroundColor: name = "bg_color"
        case .header(let h):
            switch h {
            case 1:
                return Gridicon.iconOfType(.headingH1)
            case 2:
                return Gridicon.iconOfType(.headingH2)
            case 3:
                return Gridicon.iconOfType(.headingH3)
            case 4:
                return Gridicon.iconOfType(.headingH4)
            case 5:
                return Gridicon.iconOfType(.headingH5)
            case 6:
                return Gridicon.iconOfType(.headingH6)
            default:
                return Gridicon.iconOfType(.heading)
            }
        case .fontSize(let s): name = "\(s)"
        case .paragraph: return Gridicon.iconOfType(.heading)
        case .indent: return Gridicon.iconOfType(.indentLeft)
        case .outdent: return Gridicon.iconOfType(.indentRight)
        case .orderedList: return Gridicon.iconOfType(.listOrdered)
        case .unorderedList: return Gridicon.iconOfType(.listUnordered)
        case .alignLeft: return Gridicon.iconOfType(.alignLeft)
        case .alignCenter: return Gridicon.iconOfType(.alignCenter)
        case .alignRight: return Gridicon.iconOfType(.alignRight)
        case .alignJustify: return Gridicon.iconOfType(.alignJustify)
        case .image: return Gridicon.iconOfType(.addImage)
        case .link: return Gridicon.iconOfType(.link)
        }
        
        let bundle = Bundle(for: RichEditorToolbar.self)
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    public var title: String {
        switch self {
        case .back: return NSLocalizedString("tool_text_back", comment: "")
        case .clear: return NSLocalizedString("tool_text_clear", comment: "")
        case .undo: return NSLocalizedString("tool_text_undo", comment: "")
        case .redo: return NSLocalizedString("tool_text_redo", comment: "")
        case .bold: return NSLocalizedString("tool_text_bold", comment: "")
        case .italic: return NSLocalizedString("tool_text_italic", comment: "")
        case .subscript: return NSLocalizedString("tool_text_sub", comment: "")
        case .superscript: return NSLocalizedString("tool_text_super", comment: "")
        case .strike: return NSLocalizedString("tool_text_strike", comment: "")
        case .underline: return NSLocalizedString("tool_text_underline", comment: "")
        case .textColor: return NSLocalizedString("tool_text_color", comment: "")
        case .textBackgroundColor: return NSLocalizedString("tool_text_bg_color", comment: "")
        case .header(let h): return NSLocalizedString("H\(h)", comment: "")
        case .fontSize(let s): return NSLocalizedString("tool_text_size_\(s)", comment: "")
        case .paragraph: return NSLocalizedString("tool_text_paragraph", comment: "")
        case .indent: return NSLocalizedString("tool_text_indent", comment: "")
        case .outdent: return NSLocalizedString("tool_text_outdent", comment: "")
        case .orderedList: return NSLocalizedString("tool_text_ordered_list", comment: "")
        case .unorderedList: return NSLocalizedString("tool_text_unordered_list", comment: "")
        case .alignLeft: return NSLocalizedString("tool_text_align_left", comment: "")
        case .alignCenter: return NSLocalizedString("tool_text_align_center", comment: "")
        case .alignRight: return NSLocalizedString("tool_text_align_right", comment: "")
        case .alignJustify: return NSLocalizedString("tool_text_align_justified", comment: "")
        case .image: return NSLocalizedString("tool_text_image", comment: "")
        case .link: return NSLocalizedString("tool_text_link", comment: "")
        }
    }
    
    public func action(_ toolbar: RichEditorToolbar) {
        switch self {
        case .back: toolbar.delegate?.richEditorToolbarBackToRoot?(toolbar)
        case .clear: toolbar.editor?.removeFormat()
        case .undo: toolbar.editor?.undo()
        case .redo: toolbar.editor?.redo()
        case .bold: toolbar.editor?.bold()
        case .italic: toolbar.editor?.italic()
        case .subscript: toolbar.editor?.subscriptText()
        case .superscript: toolbar.editor?.superscript()
        case .strike: toolbar.editor?.strikethrough()
        case .underline: toolbar.editor?.underline()
        case .textColor: toolbar.delegate?.richEditorToolbarChangeTextColor?(toolbar)
        case .textBackgroundColor: toolbar.delegate?.richEditorToolbarChangeBackgroundColor?(toolbar)
        case .header(let h): toolbar.editor?.header(h)
        case .fontSize(let s): toolbar.editor?.setFontSize(s)
        case .paragraph: toolbar.editor?.paragraph()
        case .indent: toolbar.editor?.indent()
        case .outdent: toolbar.editor?.outdent()
        case .orderedList: toolbar.editor?.orderedList()
        case .unorderedList: toolbar.editor?.unorderedList()
        case .alignLeft: toolbar.editor?.alignLeft()
        case .alignCenter: toolbar.editor?.alignCenter()
        case .alignRight: toolbar.editor?.alignRight()
        case .alignJustify: toolbar.editor?.alignJustify()
        case .image: toolbar.delegate?.richEditorToolbarInsertImage?(toolbar)
        case .link: toolbar.delegate?.richEditorToolbarInsertLink?(toolbar)
        }
    }
}
