//
//  StandardDiscretable.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

postfix operator ++
prefix operator ++
postfix operator --
prefix operator --

public protocol StandardSelfIncreasable {
    mutating func selfIncrease()
}

public extension StandardSelfIncreasable {
	@discardableResult
	public static prefix func ++ (value:inout Self) -> Self {
		value.selfIncrease()
		return value
	}
	
	@discardableResult
	public static postfix func ++ (value:inout  Self) -> Self {
		defer { value.selfIncrease() }
		return value
	}
}

public protocol StandardSelfDecreasable {
	mutating func selfDecrease()
}

public extension StandardSelfDecreasable {
	@discardableResult
	public static prefix func -- (value:inout Self) -> Self {
		value.selfDecrease()
		return value
	}
	
	@discardableResult
	public static postfix func -- (value:inout  Self) -> Self {
		defer { value.selfDecrease() }
		return value
	}
}



public extension BinaryInteger where Self : StandardSelfIncreasable {
    mutating public func selfIncrease() {
		self += 1
	}
}

public extension BinaryInteger where Self : StandardSelfDecreasable {
	mutating public func selfDecrease() {
		self -= 1
	}
}

extension Int : StandardSelfIncreasable, StandardSelfDecreasable {}
extension Int8 : StandardSelfIncreasable, StandardSelfDecreasable {}
extension Int16 : StandardSelfIncreasable, StandardSelfDecreasable {}
extension Int32 : StandardSelfIncreasable, StandardSelfDecreasable {}
extension Int64 : StandardSelfIncreasable, StandardSelfDecreasable {}
extension UInt : StandardSelfIncreasable, StandardSelfDecreasable {}
extension UInt8 : StandardSelfIncreasable, StandardSelfDecreasable {}
extension UInt16 : StandardSelfIncreasable, StandardSelfDecreasable {}
extension UInt32 : StandardSelfIncreasable, StandardSelfDecreasable {}
extension UInt64 : StandardSelfIncreasable, StandardSelfDecreasable {}
