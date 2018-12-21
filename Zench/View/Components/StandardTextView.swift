//
//  StandardTextView.swift
//  Zench
//
//  Created by Jesse Hao on 2018/12/12.
//  Copyright © 2018 Snoware. All rights reserved.
//

import Foundation

open class StandardTextView : BaseTextView {
	open class var defaultForegroundTextColor:UIColor { return .black }
	open class var defaultPlaceholderTextColor:UIColor { return UIColor(red: 144 / 255.0, green: 144 / 255.0, blue: 144 / 255.0, alpha: 1) }
	
	public private(set) var isPlaceholderHidden:Bool = false
	
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
	open var foregroundTextColor:UIColor? = StandardTextView.defaultForegroundTextColor {
		didSet {
			if self.isPlaceholderHidden {
				super.textColor = self.foregroundTextColor
			}
		}
	}
	open var placeholderTextColor:UIColor? = StandardTextView.defaultPlaceholderTextColor {
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
			if newValue == nil || newValue.isEmpty {
				self.showPlaceholderInContentTextField()
				return
			}
			self.hidePlaceholderInContentTextField()
			super.text = newValue
		}
	}
	
	// MARK: - Events
	@objc open func textViewTextDidBeginEditingReceived(notification:Notification) {
		guard self == notification.object as? StandardTextView else { return }
		if !self.isPlaceholderHidden {
			self.hidePlaceholderInContentTextField()
		}
	}
	
	@objc open func textViewTextDidEndEditingNotificationReceived(notification:Notification) {
		guard self == notification.object as? StandardTextView else { return }
		if self.text.isEmpty && self.isPlaceholderHidden {
			self.showPlaceholderInContentTextField()
		}
	}
	
	override open func setup() {
		super.setup()
		super.textColor = StandardTextView.defaultForegroundTextColor
		self.addToNotificationCenter()
		if self.hasText {
			self.hidePlaceholderInContentTextField()
		} else {
			self.showPlaceholderInContentTextField()
		}
	}
	
	open func addToNotificationCenter() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.textViewTextDidBeginEditingReceived), name: UITextView.textDidBeginEditingNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.textViewTextDidEndEditingNotificationReceived), name: UITextView.textDidEndEditingNotification, object: nil)
	}
	
	open func showPlaceholderInContentTextField() {
		super.text = self.placeholder
		super.textColor = self.placeholderTextColor
		self.isPlaceholderHidden = false
	}
	
	open func hidePlaceholderInContentTextField() {
		super.textColor = self.foregroundTextColor
		super.text = ""
		self.isPlaceholderHidden = true
	}
}
