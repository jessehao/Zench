//
//  BaseTextView.swift
//  Zench
//
//  Created by 郝泽 on 2018/12/12.
//  Copyright © 2018 Snoware. All rights reserved.
//

import Foundation

open class BaseTextView : UITextView, ViewPatternProtocol {
	public override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		self.setup()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	open func setup() {
		self.prepareSubviews()
		self.makeConstraints()
		self.prepareTargets()
	}
	open func prepareSubviews() {}
	open func makeConstraints() {}
	open func prepareTargets() {}
}
