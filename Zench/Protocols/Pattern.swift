//
//  Pattern.swift
//  Zench
//
//  Created by Jesse Hao on 2018/12/5.
//  Copyright © 2018 Snoware. All rights reserved.
//

protocol BasePatternProtocol {
	func setup()
}

protocol ViewPatternProtocol : BasePatternProtocol {
	func prepareSubviews()
	func makeConstraints()
	func prepareTargets()
}

extension ViewPatternProtocol {
	func setup() {
		self.prepareSubviews()
		self.makeConstraints()
		self.prepareTargets()
	}
}

protocol ViewControllerPatternProtocol : BasePatternProtocol {}
