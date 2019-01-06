//
//  GeneralTextView.swift
//  Zench
//
//  Created by Jesse Hao on 2018/12/12.
//  Copyright © 2018 Snoware. All rights reserved.
//

import Foundation

open class GeneralTextView : StandardTextView {
	open class var defaultForegroundTextColor:UIColor { return .black }
	open class var defaultPlaceholderTextColor:UIColor { return UIColor(red: 144 / 255.0, green: 144 / 255.0, blue: 144 / 255.0, alpha: 1) }
	
	public private(set) var isPlaceholderHidden:Bool = true
	
	/// The color of the text. (get-only)
	open override var textColor: UIColor? {
		get { return super.textColor }
		set {}
	}
	
	open override var selectedRange: NSRange {
		get { return self.isPlaceholderHidden ? super.selectedRange : .zero }
		set { super.selectedRange = self.isPlaceholderHidden ? newValue : .zero }
	}
	
	open var placeholder = "" {
		didSet {
			if !self.isPlaceholderHidden {
				self.showPlaceholderInContentTextField()
			}
		}
	}
	open var foregroundTextColor:UIColor? = GeneralTextView.defaultForegroundTextColor {
		didSet {
			if self.isPlaceholderHidden {
				super.textColor = self.foregroundTextColor
			}
		}
	}
	open var placeholderTextColor:UIColor? = GeneralTextView.defaultPlaceholderTextColor {
		didSet {
			if !self.isPlaceholderHidden {
				super.textColor = self.placeholderTextColor
			}
		}
	}
	
	override open var text: String! {
		get {
			return self.isPlaceholderHidden ? super.text : ""
		}
		set {
			if !self.isFirstResponder {
				if newValue == nil || newValue.isEmpty {
					self.showPlaceholderInContentTextField()
					return
				}
				self.hidePlaceholderInContentTextField()
			}
			super.text = newValue
		}
	}
	
	open override var attributedText: NSAttributedString? {
		get {
			return self.isPlaceholderHidden ? super.attributedText : nil
		}
		set {
			if !self.isFirstResponder {
				if newValue == nil || newValue?.string.isEmpty == true {
					self.showPlaceholderInContentTextField()
					return
				}
				self.hidePlaceholderInContentTextField()
			}
			super.attributedText = newValue
		}
	}
	
	// MARK: - Events
	@objc
	open func textViewTextDidBeginEditingReceived(notification:Notification) {
		guard self == notification.object as? GeneralTextView else { return }
		if !self.isPlaceholderHidden {
			self.hidePlaceholderInContentTextField()
		}
	}
	
	@objc
	open func textViewTextDidEndEditingNotificationReceived(notification:Notification) {
		guard self == notification.object as? GeneralTextView else { return }
		if self.text.isEmpty && self.isPlaceholderHidden {
			self.showPlaceholderInContentTextField()
		}
	}
	
	override open func setup() {
		super.setup()
		super.textColor = GeneralTextView.defaultForegroundTextColor
		self.addToNotificationCenter()
	}
	
	open func addToNotificationCenter() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.textViewTextDidBeginEditingReceived), name: UITextView.textDidBeginEditingNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.textViewTextDidEndEditingNotificationReceived), name: UITextView.textDidEndEditingNotification, object: nil)
	}
	
	open func showPlaceholderInContentTextField(force:Bool = false) {
		guard force || self.isPlaceholderHidden else { return }
		var attributes:[NSAttributedString.Key : Any] = [:]
		if let font = self.font {
			attributes[.font] = font
		}
		if let color = self.placeholderTextColor {
			attributes[.foregroundColor] = color
		}
		super.attributedText = self.placeholder.attributedString(withAttributes: attributes)
		self.isPlaceholderHidden = false
	}
	
	open func hidePlaceholderInContentTextField(force:Bool = false) {
		guard force || !self.isPlaceholderHidden else { return }
		var attributes:[NSAttributedString.Key : Any] = [:]
		if let font = self.font {
			attributes[.font] = font
		}
		if let color = self.foregroundTextColor {
			attributes[.foregroundColor] = color
		}
		super.attributedText = "".attributedString(withAttributes: attributes)
		self.isPlaceholderHidden = true
	}
}
