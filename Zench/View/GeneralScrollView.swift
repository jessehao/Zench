//
//  GeneralScrollView.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

open class GeneralScrollView: BaseView {
	var defaultKeyboardDismissMode:UIScrollView.KeyboardDismissMode { return UIScrollView.KeyboardDismissMode.onDrag }
	
	// MARK: - Components
	public let scrollView = UIScrollView()
	public let contentView = UIView()
	
	// MARK: - Operations
	open override func setup() {
		super.setup()
		self.configScrollView(self.scrollView)
	}
	
	open func configScrollView(_ scrollView:UIScrollView) {
		if #available(iOS 11.0, *) {
			scrollView.contentInsetAdjustmentBehavior = .never
		}
		scrollView.keyboardDismissMode = self.defaultKeyboardDismissMode
		scrollView.backgroundColor = .clear
	}
	
	open override func prepareSubviews() {
		super.prepareSubviews()
		self.addSubview(self.scrollView)
		self.scrollView.addSubview(self.contentView)
	}
	
	open override func makeConstraints() {
		super.makeConstraints()
		if let superview = self.scrollView.superview {
			self.scrollView.translatesAutoresizingMaskIntoConstraints = false
			self.scrollView.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
			self.scrollView.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
			self.scrollView.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
			self.scrollView.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
		}
		if let superview = self.contentView.superview {
			self.contentView.translatesAutoresizingMaskIntoConstraints = false
			self.contentView.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
			self.contentView.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
			self.contentView.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
			self.contentView.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
		}
	}
}

class GeneralVerticalScrollView: GeneralScrollView {
	var alwaysBounce:Bool { return false }
	
	// MARK: - Operations
	override func setup() {
		super.setup()
		self.scrollView.alwaysBounceVertical = self.alwaysBounce
	}
	
	override func makeConstraints() {
		super.makeConstraints()
		if let superview = self.contentView.superview {
			self.contentView.widthAnchor.constraint(equalTo: superview.widthAnchor)
		}
	}
}

class GeneralHorizontalScrollView: GeneralScrollView {
	var alwaysBounce:Bool { return false }
	
	// MARK: - Operations
	override func setup() {
		super.setup()
		self.scrollView.alwaysBounceHorizontal = self.alwaysBounce
	}
	
	override func makeConstraints() {
		super.makeConstraints()
		if let superview = self.contentView.superview {
			self.heightAnchor.constraint(equalTo: superview.heightAnchor)
		}
	}
}
