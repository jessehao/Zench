//
//  CollectionExtensions.swift
//  Zench
//
//  Created by Jesse Hao on 2018/12/25.
//  Copyright © 2018 Snoware. All rights reserved.
//

public extension Collection where Element == Bool {
	func and() -> Bool {
		guard self.count > 0 else { return false }
		for i in self {
			if i == false { return false }
		}
		return true
	}
	
	func or() -> Bool {
		for i in self {
			if i == true { return true }
		}
		return false
	}
}

public extension Sequence where Element : Hashable {
	func set() -> Set<Element> {
		return Set(self)
	}
}

public extension RangeReplaceableCollection where Index : Hashable {
	mutating func remove(withIndexSet set:Set<Index>) {
		set.forEach { self.remove(at: $0) }
	}
}
