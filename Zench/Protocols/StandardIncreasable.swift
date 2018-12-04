//
//  StandardIncreasable.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

postfix operator ++
prefix operator ++

public protocol StandardIncreasable {
    mutating func increaseOneUnit()
}

public extension StandardIncreasable {
	@discardableResult public static prefix func ++ (value:inout Self) -> Self {
		value.increaseOneUnit()
		return value
	}
	
	@discardableResult public static postfix func ++ (value:inout  Self) -> Self {
		defer { value.increaseOneUnit() }
		return value
	}
}

public extension BinaryInteger where Self : StandardIncreasable {
    mutating public func increaseOneUnit() {
		self += 1
	}
}

extension Int : StandardIncreasable {}
extension UInt : StandardIncreasable {}
