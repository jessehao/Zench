//
//  StandardIncreasable.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

postfix operator ++
prefix operator ++

protocol StandardIncreasable {
	mutating func increaseOneUnit()
}

extension StandardIncreasable {
	@discardableResult static prefix func ++ (value:inout Self) -> Self {
		value.increaseOneUnit()
		return value
	}
	
	@discardableResult static postfix func ++ (value:inout  Self) -> Self {
		defer { value.increaseOneUnit() }
		return value
	}
}

extension Int : StandardIncreasable {
	mutating func increaseOneUnit() {
		self += 1
	}
}
