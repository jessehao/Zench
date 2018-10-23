//
//  StandardConfigurable.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

protocol StandardConfigurable {
	@discardableResult mutating func withConfiguration(_ configuration:(inout Self) -> Void) -> Self
}

extension StandardConfigurable {
	@discardableResult mutating func withConfiguration(_ configuration:(inout Self) -> Void) -> Self {
		configuration(&self)
		return self
	}
}

protocol StandardClassConfigurable : class {}

extension StandardClassConfigurable {
	@discardableResult func withConfiguration(_ configuration:(Self) -> Void) -> Self {
		configuration(self)
		return self
	}
}

protocol StandardConfigurableInitializer {
	static func newWithConfiguration(_ configuration:(inout Self) -> Void) -> Self
}

extension StandardConfigurableInitializer where Self : StandardLeisurelyInitializer & StandardConfigurable {
	static func newWithConfiguration(_ configuration:(inout Self) -> Void) -> Self {
		var retval = Self()
		return retval.withConfiguration(configuration)
	}
}

protocol StandardClassConfigurableInitializer : class {}

extension StandardClassConfigurableInitializer where Self : StandardLeisurelyInitializer & StandardClassConfigurable {
	static func newWithConfiguration(_ configuration:(Self) -> Void) -> Self {
		let retval = Self()
		return retval.withConfiguration(configuration)
	}
}
