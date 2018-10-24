//
//  StandardScrollView.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

class StandardScrollView: BaseView {
	var defaultKeyboardDismissMode:UIScrollView.KeyboardDismissMode { return UIScrollView.KeyboardDismissMode.onDrag }
	
	// MARK: - Components
	let scrollView = UIScrollView()
	let contentView = UIView()
	
	// MARK: - Operations
	override func setup() {
		super.setup()
		self.configScrollView(self.scrollView)
	}
	
	func configScrollView(_ scrollView:UIScrollView) {
		if #available(iOS 11.0, *) {
			scrollView.contentInsetAdjustmentBehavior = .never
		}
		scrollView.keyboardDismissMode = self.defaultKeyboardDismissMode
		scrollView.backgroundColor = .clear
	}
	
	override func prepareSubviews() {
		super.prepareSubviews()
		self.addSubview(self.scrollView)
		self.scrollView.addSubview(self.contentView)
	}
	
	override func makeConstraints() {
		super.makeConstraints()
		if let superview = self.scrollView.superview {
			self.scrollView.topAnchor.constraint(equalTo: superview.topAnchor)
			self.scrollView.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
			self.scrollView.leftAnchor.constraint(equalTo: superview.leftAnchor)
			self.scrollView.rightAnchor.constraint(equalTo: superview.rightAnchor)
		}
		if let superview = self.contentView.superview {
			self.contentView.topAnchor.constraint(equalTo: superview.topAnchor)
			self.contentView.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
			self.contentView.leftAnchor.constraint(equalTo: superview.leftAnchor)
			self.contentView.rightAnchor.constraint(equalTo: superview.rightAnchor)
		}
	}
}

class StandardVerticalScrollView: StandardScrollView {
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

class StandardHorizontalScrollView: StandardScrollView {
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