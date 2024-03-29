//
//  StandardConfigurable.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

public protocol StandardConfigurable {
	@discardableResult mutating func withConfiguration(_ configuration:(inout Self) throws -> Void) rethrows -> Self
}

public extension StandardConfigurable {
	@discardableResult mutating func withConfiguration(_ configuration:(inout Self) throws -> Void) rethrows -> Self {
		try configuration(&self)
		return self
	}
}

public protocol StandardClassConfigurable : class {}

public extension StandardClassConfigurable {
	@discardableResult func withConfiguration(_ configuration:(Self) throws -> Void) rethrows -> Self {
		try configuration(self)
		return self
	}
}

public protocol StandardConfigurableInitializer {
	static func newWithConfiguration(_ configuration:(inout Self) throws -> Void) rethrows -> Self
}

public extension StandardConfigurableInitializer where Self : StandardNoParameterInitializable & StandardConfigurable {
	static func newWithConfiguration(_ configuration:(inout Self) throws -> Void) rethrows -> Self {
		var retval = Self()
		return try retval.withConfiguration(configuration)
	}
}

public protocol StandardClassConfigurableInitializer : class {}

public extension StandardClassConfigurableInitializer where Self : StandardNoParameterInitializable & StandardClassConfigurable {
	static func newWithConfiguration(_ configuration:(Self) throws -> Void) rethrows -> Self {
		let retval = Self()
		return try retval.withConfiguration(configuration)
	}
}
