//
//  CollectionExtensions.swift
//  Zench
//
//  Created by Jesse Hao on 2018/12/25.
//  Copyright © 2018 Snoware. All rights reserved.
//

public extension Collection {
	func element(at index:Self.Index) -> Element? {
		guard (self.startIndex..<self.endIndex).contains(index) else { return nil }
		return self[index]
	}
}

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

public extension RangeReplaceableCollection {
	mutating func replaceAll(with value:Element) {
		self = Self(repeating: value, count: self.count)
	}
	
	@discardableResult
	mutating func appendIfNonnull(_ newElement: Element?) -> Bool {
		if let new = newElement {
			self.append(new)
			return true
		}
		return false
	}
	
	static func += (collection:inout Self, newElement:Element) {
		collection.append(newElement)
	}
}

public extension RangeReplaceableCollection where Element : Equatable {
	@discardableResult
	mutating func remove(_ element:Element) -> Bool {
		guard let index = self.index(of: element) else { return false }
		self.remove(at: index)
		return true
	}
	
	@discardableResult
	mutating func appendUnique(_ newElement:Element) -> Bool {
		guard !(self.contains { $0 == newElement }) else { return false }
		self.append(newElement)
		return true
	}
}

public extension Sequence {
	func array() -> [Element] {
		return Array(self)
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
