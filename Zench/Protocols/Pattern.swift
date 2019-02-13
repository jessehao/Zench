//
//  Pattern.swift
//  Zench
//
//  Created by Jesse Hao on 2018/12/5.
//  Copyright © 2018 Snoware. All rights reserved.
//

public protocol BasePatternProtocol {
	func setup()
}

public protocol ViewPatternProtocol : BasePatternProtocol, TargetActionPatternProtocol {
	func prepareSubviews()
	func makeConstraints()
}

public extension ViewPatternProtocol {
	func setup() {
		self.prepareSubviews()
		self.makeConstraints()
		self.prepareTargets()
	}
}

public protocol ViewControllerPatternProtocol : BasePatternProtocol, TargetActionPatternProtocol {}

public protocol TargetActionPatternProtocol {
	func prepareTargets()
}
