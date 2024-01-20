//
// Copyright 2015-present Ruslan Skorb, http://ruslanskorb.com/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this work except in compliance with the License.
// You may obtain a copy of the License in the LICENSE file, or at:
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

/// A light-weight UITextView subclass that adds support for placeholder.
@IBDesignable open class RSKPlaceholderTextView: UITextView {
    
    // MARK: - Private Properties
    
    private var placeholderAttributes: [NSAttributedString.Key: Any] {
        
        var placeholderAttributes = self.typingAttributes
        
        if placeholderAttributes[.font] == nil {
            
            placeholderAttributes[.font] = self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        
        if let paragraphStyle = placeholderAttributes[.paragraphStyle] as? NSParagraphStyle {
            
            if paragraphStyle.lineBreakMode != self.placeholderLineBreakMode {
                
                let mutableParagraphStyle = NSMutableParagraphStyle()
                mutableParagraphStyle.setParagraphStyle(paragraphStyle)
                mutableParagraphStyle.lineBreakMode = self.placeholderLineBreakMode
                placeholderAttributes[.paragraphStyle] = mutableParagraphStyle
            }
        }
        else {
            
            let mutableParagraphStyle = NSMutableParagraphStyle()
            mutableParagraphStyle.alignment = self.textAlignment
            mutableParagraphStyle.lineBreakMode = self.placeholderLineBreakMode
            placeholderAttributes[.paragraphStyle] = mutableParagraphStyle
        }
        
        placeholderAttributes[.foregroundColor] = self.placeholderColor
        
        return placeholderAttributes
    }
    
    private var placeholderLayoutManager: NSLayoutManager?
    
    private let placeholderTextContainer = NSTextContainer()
    
    private var _placeholderTextLayoutManager: NSObject?
    
    @available(iOS 16.0, *)
    private var placeholderTextLayoutManager: NSTextLayoutManager? { self._placeholderTextLayoutManager as? NSTextLayoutManager }
    
    // MARK: - Open Properties
    
    /// The attributed string that is displayed when there is no other text in the placeholder text view. This value is `nil` by default.
    @NSCopying open var attributedPlaceholder: NSAttributedString? {
        
        didSet {
            
            guard self.attributedPlaceholder != oldValue else {
                
                return
            }
            if let attributedPlaceholder = self.attributedPlaceholder {
                
                let attributes = attributedPlaceholder.attributes(at: 0, effectiveRange: nil)
                if let font = attributes[.font] as? UIFont,
                    self.font != font {
                    
                    self.font = font
                    
                    self.typingAttributes[.font] = font
                }
                if let foregroundColor = attributes[.foregroundColor] as? UIColor,
                    self.placeholderColor != foregroundColor {
                    
                    self.placeholderColor = foregroundColor
                }
                if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
                    
                    if self.placeholderLineBreakMode != paragraphStyle.lineBreakMode {
                        
                        self.placeholderLineBreakMode = paragraphStyle.lineBreakMode
                    }
                    if self.textAlignment != paragraphStyle.alignment {
                        
                        self.textAlignment = paragraphStyle.alignment
                        
                        let mutableTypingAttributesParagraphStyle = NSMutableParagraphStyle()
                        if let typingAttributesParagraphStyle = self.typingAttributes[.paragraphStyle] as? NSParagraphStyle {
                            
                            mutableTypingAttributesParagraphStyle.setParagraphStyle(typingAttributesParagraphStyle)
                        }
                        mutableTypingAttributesParagraphStyle.alignment = paragraphStyle.alignment
                        self.typingAttributes[.paragraphStyle] = mutableTypingAttributesParagraphStyle
                    }
                }
            }
            guard self.isEmpty == true else {
                
                return
            }
            self.setNeedsDisplay()
        }
    }
    
    /// Determines whether or not the placeholder text view contains text.
    open var isEmpty: Bool { return self.text.isEmpty }
    
    /// The string that is displayed when there is no other text in the placeholder text view. This value is `nil` by default.
    @IBInspectable open var placeholder: NSString? {
        
        get {
            
            return self.attributedPlaceholder?.string as NSString?
        }
        set {
            
            if let newValue = newValue as String? {
                
                self.attributedPlaceholder = NSAttributedString(string: newValue, attributes: self.placeholderAttributes)
            }
            else {
                
                self.attributedPlaceholder = nil
            }
        }
    }
    
    /// The color of the placeholder. This property applies to the entire placeholder. The default value of this property is `UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)`.
    @IBInspectable open var placeholderColor: UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0) {
        
        didSet {
            
            if let placeholder = self.placeholder as String? {
                
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }
    
    /// The technique for wrapping and truncating the placeholder. This property applies to the entire placeholder. The default value of this property is `NSLineBreakMode.byWordWrapping`.
    open var placeholderLineBreakMode: NSLineBreakMode = .byWordWrapping {
        
        didSet {
            
            if let placeholder = self.placeholder as String? {
                
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }
    
    // MARK: - Superclass Properties
    
    open override var attributedText: NSAttributedString! { didSet { self.setNeedsDisplay() } }
    
    open override var bounds: CGRect { didSet { self.setNeedsDisplay() } }
    
    open override var contentInset: UIEdgeInsets { didSet { self.setNeedsDisplay() } }
    
    open override var font: UIFont? {
        
        didSet {
            
            if let placeholder = self.placeholder as String? {
                
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }
    
    open override var textAlignment: NSTextAlignment {
        
        didSet {
            
            if let placeholder = self.placeholder as String? {
                
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }
    
    open override var textContainerInset: UIEdgeInsets { didSet { self.setNeedsDisplay() } }
    
    open override var typingAttributes: [NSAttributedString.Key: Any] {
        
        didSet {
            
            if let placeholder = self.placeholder as String? {
                
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }
    
    // MARK: - Object Lifecycle
    
    required public init?(coder aDecoder: NSCoder) {
        
        if #available(iOS 16.0, *) {
            
            let placeholderTextLayoutManager = NSTextLayoutManager()
            placeholderTextLayoutManager.textContainer = self.placeholderTextContainer
            self._placeholderTextLayoutManager = placeholderTextLayoutManager
        } 
        else {
            
            let placeholderLayoutManager = NSLayoutManager()
            placeholderLayoutManager.addTextContainer(self.placeholderTextContainer)
            self.placeholderLayoutManager = placeholderLayoutManager
        }
        
        super.init(coder: aDecoder)
        
        self.commonInitializer()
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        
        if #available(iOS 16.0, *) {
            
            let placeholderTextLayoutManager = NSTextLayoutManager()
            placeholderTextLayoutManager.textContainer = self.placeholderTextContainer
            self._placeholderTextLayoutManager = placeholderTextLayoutManager
        } 
        else {
            
            let placeholderLayoutManager = NSLayoutManager()
            placeholderLayoutManager.addTextContainer(self.placeholderTextContainer)
            self.placeholderLayoutManager = placeholderLayoutManager
        }
        
        super.init(frame: frame, textContainer: textContainer)
        
        self.commonInitializer()
    }
    
    @available(iOS 16.0, *)
    public convenience init(usingTextLayoutManager: Bool) {
        
        if usingTextLayoutManager {
            
            self.init(frame: .zero, textContainer: nil)
        } 
        else {
            
            let layoutManager = NSLayoutManager()
            let textStorage = NSTextStorage()
            textStorage.addLayoutManager(layoutManager)
            let textContainer = NSTextContainer()
            layoutManager.addTextContainer(textContainer)
            
            self.init(frame: .zero, textContainer: textContainer)
        }
    }
    
    // MARK: - Superclass API
    
    open override func caretRect(for position: UITextPosition) -> CGRect {
        
        guard self.text.isEmpty == true,
            let attributedPlaceholder = self.attributedPlaceholder,
            attributedPlaceholder.length > 0 else {
            
            return super.caretRect(for: position)
        }
        
        var caretRect = super.caretRect(for: position)
        
        if #available(iOS 16.0, *), let placeholderTextLayoutManager {
            
            let placeholderTextContentStorage = NSTextContentStorage()
            placeholderTextContentStorage.attributedString = attributedPlaceholder
            self.configurePlaceholderTextLayoutManager(placeholderTextLayoutManager, withPlaceholderTextContentStorage: placeholderTextContentStorage, textContainerSize: self.textContainer.size)
            
            var layoutFragmentFrame = CGRect.zero
            placeholderTextLayoutManager.enumerateTextLayoutFragments(from: nil) { textLayoutFragment -> Bool in
                
                layoutFragmentFrame = textLayoutFragment.layoutFragmentFrame
                return false
            }
            
            switch self.effectiveUserInterfaceLayoutDirection {
                
            case .rightToLeft:
                caretRect.origin.x = self.textContainerInset.left + layoutFragmentFrame.maxX
                if #unavailable(iOS 17.0) {
                    
                    caretRect.origin.x -= self.textContainer.lineFragmentPadding
                }
                
            case .leftToRight:
                fallthrough
                
            @unknown default:
                caretRect.origin.x = self.textContainerInset.left + layoutFragmentFrame.minX
                if #unavailable(iOS 17.0) {
                    
                    caretRect.origin.x += self.textContainer.lineFragmentPadding
                }
            }
        }
        else if let placeholderLayoutManager {
            
            let placeholderTextStorage = NSTextStorage(attributedString: attributedPlaceholder)
            self.configurePlaceholderLayoutManager(placeholderLayoutManager, withPlaceholderTextStorage: placeholderTextStorage, textContainerSize: self.textContainer.size)
            
            let lineFragmentUsedRect = placeholderLayoutManager.lineFragmentUsedRect(forGlyphAt: 0, effectiveRange: nil, withoutAdditionalLayout: true)
            
            switch self.effectiveUserInterfaceLayoutDirection {
                
            case .rightToLeft:
                caretRect.origin.x = self.textContainerInset.left + lineFragmentUsedRect.maxX - self.textContainer.lineFragmentPadding
                
            case .leftToRight:
                fallthrough
                
            @unknown default:
                caretRect.origin.x = self.textContainerInset.left + lineFragmentUsedRect.minX + self.textContainer.lineFragmentPadding
            }
        }
        else {
            
            assertionFailure()
            return caretRect
        }
        
        return caretRect
    }
    
    private func configurePlaceholderLayoutManager(_ placeholderLayoutManager: NSLayoutManager, withPlaceholderTextStorage placeholderTextStorage: NSTextStorage, textContainerSize: CGSize) {
        
        placeholderTextStorage.addLayoutManager(placeholderLayoutManager)
        
        self.placeholderTextContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding
        self.placeholderTextContainer.size = textContainerSize
        
        placeholderLayoutManager.ensureLayout(for: self.placeholderTextContainer)
    }
    
    @available(iOS 16.0, *)
    private func configurePlaceholderTextLayoutManager(_ placeholderTextLayoutManager: NSTextLayoutManager, withPlaceholderTextContentStorage placeholderTextContentStorage: NSTextContentStorage, textContainerSize: CGSize) {
        
        placeholderTextContentStorage.addTextLayoutManager(placeholderTextLayoutManager)
        
        self.placeholderTextContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding
        self.placeholderTextContainer.size = textContainerSize
        
        placeholderTextLayoutManager.textContainer = self.placeholderTextContainer
        placeholderTextLayoutManager.ensureLayout(for: placeholderTextLayoutManager.documentRange)
    }
    
    open override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        guard self.isEmpty == true else {
            
            return
        }
        
        guard let attributedPlaceholder = self.attributedPlaceholder else {
            
            return
        }
        
        let insets = UIEdgeInsets(
            
            top: self.contentInset.top + self.textContainerInset.top,
            left: self.contentInset.left + self.textContainerInset.left + self.textContainer.lineFragmentPadding,
            bottom: self.contentInset.bottom + self.textContainerInset.bottom,
            right: self.contentInset.right + self.textContainerInset.right + self.textContainer.lineFragmentPadding
        )
        let placeholderRect = rect.inset(by: insets)
        
        attributedPlaceholder.draw(in: placeholderRect)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        if self.isEmpty == true,
           let attributedPlaceholder = self.attributedPlaceholder,
           attributedPlaceholder.length > 0 {
            
            var textContainerSize = size
            textContainerSize.height -= self.textContainerInset.top + self.textContainerInset.bottom
            textContainerSize.width -= self.textContainerInset.left + self.textContainerInset.right
            
            var size: CGSize
            if #available(iOS 16.0, *), let placeholderTextLayoutManager {
                
                let placeholderTextContentStorage = NSTextContentStorage()
                placeholderTextContentStorage.attributedString = attributedPlaceholder
                
                self.configurePlaceholderTextLayoutManager(placeholderTextLayoutManager, withPlaceholderTextContentStorage: placeholderTextContentStorage, textContainerSize: textContainerSize)
                
                size = placeholderTextLayoutManager.usageBoundsForTextContainer.size
                size.width += self.textContainer.lineFragmentPadding * 2.0
            }
            else if let placeholderLayoutManager {
                
                let placeholderTextStorage = NSTextStorage(attributedString: attributedPlaceholder)
                
                self.configurePlaceholderLayoutManager(placeholderLayoutManager, withPlaceholderTextStorage: placeholderTextStorage, textContainerSize: textContainerSize)
                
                let usedRect = placeholderLayoutManager.usedRect(for: self.placeholderTextContainer)
                size = usedRect.size
            }
            else {
                
                assertionFailure()
                size = .zero
            }
            size.height += self.textContainerInset.top + self.textContainerInset.bottom
            size.width += self.textContainerInset.left + self.textContainerInset.right
            return size
        }
        else {
            
            return super.sizeThatFits(size)
        }
    }
    
    open override func sizeToFit() {
        
        self.bounds.size = self.sizeThatFits(.zero)
    }
    
    // MARK: - Private API
    
    private func commonInitializer() {
        
        if #available(iOS 16.0, *), self.textLayoutManager == nil {
            
            self._placeholderTextLayoutManager = nil
            
            let placeholderLayoutManager = NSLayoutManager()
            placeholderLayoutManager.addTextContainer(self.placeholderTextContainer)
            self.placeholderLayoutManager = placeholderLayoutManager
        }
        self.contentMode = .topLeft
        
        NotificationCenter.default.addObserver(self, selector: #selector(RSKPlaceholderTextView.handleTextViewTextDidChangeNotification(_:)), name: UITextView.textDidChangeNotification, object: self)
    }
    
    @objc internal func handleTextViewTextDidChangeNotification(_ notification: Notification) {
        
        guard let object = notification.object as? RSKPlaceholderTextView, object === self else {
            
            return
        }
        self.setNeedsDisplay()
    }
}
