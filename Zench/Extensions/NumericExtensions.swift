//
//  NumericExtensions.swift
//  Zench
//
//  Created by Jesse Hao on 2018/12/25.
//  Copyright © 2018 Snoware. All rights reserved.
//

public extension Numeric {
	/// false if 0
	var bool:Bool { return self != 0 }
}

// MARK: - Integer
public extension BinaryInteger {
	var int:Int { return Int(self) }
	var int8:Int8 { return Int8(self) }
	var int16:Int16 { return Int16(self) }
	var int32:Int32 { return Int32(self) }
	var int64:Int64 { return Int64(self) }
	var uint:UInt { return UInt(self) }
	var uint8:UInt8 { return UInt8(self) }
	var uint16:UInt16 { return UInt16(self) }
	var uint32:UInt32 { return UInt32(self) }
	var uint64:UInt64 { return UInt64(self) }
	var double:Double { return Double(self) }
	var cgFloat:CGFloat { return CGFloat(self) }
	var date:Date { return self.double.date }
}

// MARK: - Floating Point
public extension BinaryFloatingPoint {
	var int:Int { return Int(self) }
	var int8:Int8 { return Int8(self) }
	var int16:Int16 { return Int16(self) }
	var int32:Int32 { return Int32(self) }
	var int64:Int64 { return Int64(self) }
	var uint:UInt { return UInt(self) }
	var uint8:UInt8 { return UInt8(self) }
	var uint16:UInt16 { return UInt16(self) }
	var uint32:UInt32 { return UInt32(self) }
	var uint64:UInt64 { return UInt64(self) }
	var double:Double { return Double(self) }
	var cgFloat:CGFloat { return CGFloat(self) }
	var date:Date { return Date(timeIntervalSince1970: self.double) }
}

public extension BinaryFloatingPoint where Self : CVarArg {
	func formattedString(withDecimalPlace place:UInt) -> String {
		return String(format: "%.\(place)f", self)
	}
}

// MARK: - Bool
public extension Bool {
	var int:Int { return self ? 1 : 0 }
	
	var negation:Bool { return !self }
	
	@discardableResult
	mutating func negate() -> Bool {
		self = !self
		return self
	}
}

// MARK: - Range
public extension NSRange {
	static var zero:NSRange { return NSRange(location: 0, length: 0) }
	var nilIfNotFound:NSRange? { return self.location == NSNotFound ? nil : self }
}
