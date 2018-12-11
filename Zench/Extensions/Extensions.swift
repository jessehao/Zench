//
//  Extensions.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

import Foundation

extension NSObject : StandardNoParameterInitializable, StandardClassConfigurable, StandardClassConfigurableInitializer, StandardNotificationSupport {}
extension NSObject {
	var className:String { return object_getClassName(self).string }
}

extension UIControl.State : Hashable {
	public var hashValue: Int {
		return self.rawValue.hashValue
	}
}

public extension UIFont {
	public class func pingFangSCFont(ofSize size:CGFloat, weight:UIFont.Weight) -> UIFont {
		var fontStr = "PingFangSC-"
		switch weight {
		case Weight.semibold:
			fontStr += "Semibold"
		case Weight.light:
			fontStr += "Light"
		case Weight.medium:
			fontStr += "Medium"
		case Weight.bold:
			fontStr += "Bold"
		case Weight.regular:
			fontStr += "Regular"
		default:
			fontStr += "Regular"
		}
		return UIFont(name: fontStr, size: size)!
	}
}

public extension String {
	mutating func add(suffix:String) { self += suffix }
	mutating func add(prefix:String) { self = prefix + self }
	func stringWith(suffix:String) -> String { return self + suffix }
	func stringWith(prefix:String) -> String { return prefix + self }
	func stringWith(prefix:String, suffix:String) -> String { return "\(prefix)\(self)\(suffix)" }
    public var localizedString:String { return NSLocalizedString(self, comment: "") }
	func attributedString(withAttributes attributes:[NSAttributedString.Key:Any]) -> NSAttributedString { return NSAttributedString(string: self, attributes: attributes) }
	func mutableAttributedString(withAttributes attributes:[NSAttributedString.Key:Any]) -> NSMutableAttributedString { return NSMutableAttributedString(string: self, attributes: attributes) }
	func date(withFormat format:String? = nil) -> Date? {
		if let format = format {
			return DateFormatter.zench.shared.date(from: self, format: format)
		}
		for format in  DateFormatter.zench.defaultDateStringParsingSet {
			if let date = DateFormatter.zench.shared.date(from: self, format: format) {
				return date
			}
		}
		return nil
	}
}

public extension StringProtocol {
	var int:Int? { return Int(self) }
	var int8:Int8? { return Int8(self) }
	var int16:Int16? { return Int16(self) }
	var int32:Int32? { return Int32(self) }
	var int64:Int64? { return Int64(self) }
	var uint:UInt? { return UInt(self) }
	var uint8:UInt8? { return UInt8(self) }
	var uint16:UInt16? { return UInt16(self) }
	var uint32:UInt32? { return UInt32(self) }
	var uint64:UInt64? { return UInt64(self) }
	var double:Double? { return Double(self) }
}

public extension LosslessStringConvertible {
	var string:String { return String(self) }
}

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

public extension Date {
	static let microsecondsPerSecond:UInt32 = 1000000
	func string(withFormat format:String) -> String {
		return DateFormatter.zench.shared.string(from: self, format: format)
	}
}

public extension DateFormatter {
	func date(from raw:String, format:String) -> Date? {
		defer { self.dateFormat = self.dateFormat.string }
		self.dateFormat = format
		return self.date(from: raw)
	}

	func string(from date:Date, format:String) -> String {
		defer { self.dateFormat = self.dateFormat.string }
		self.dateFormat = format
		return self.string(from: date)
	}
}

extension NotificationCenter {
	func post(name aName: NSNotification.Name) {
		self.post(name: aName, object: nil)
	}
}

public extension JSONSerialization.WritingOptions {
	public static var plain:JSONSerialization.WritingOptions { return JSONSerialization.WritingOptions(rawValue: 0) }
}

public extension UICollectionView.ScrollPosition {
	public static var none:UICollectionView.ScrollPosition { return UICollectionView.ScrollPosition(rawValue: 0) }
}

extension UnsafePointer where Pointee == Int8 {
	var string:String { return String(cString: self) }
}

// MARK: - Namespaced
extension DateFormatter : ZenchNamespaceWrappable {}
public extension ZenchNamespaceWrapper where T == DateFormatter {
	public static let shared = DateFormatter()
	public static let defaultDateStringParsingSet:Set<String> = [
		"y/MM/dd",
		"y-MM-dd",
		"y-MM"
	]
}
