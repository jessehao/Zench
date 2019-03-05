//
//  StringExtensions.swift
//  Zench
//
//  Created by Jesse Hao on 2018/12/25.
//  Copyright © 2018 Snoware. All rights reserved.
//

public extension String {
	mutating func add(suffix:String) { self += suffix }
	mutating func add(prefix:String) { self = prefix + self }
	func stringWith(suffix:String) -> String { return self + suffix }
	func stringWith(prefix:String) -> String { return prefix + self }
	func stringWith(prefix:String, suffix:String) -> String { return "\(prefix)\(self)\(suffix)" }
	var localizedString:String { return NSLocalizedString(self, comment: "") }
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
	func withFormatArguments(_ args:CVarArg...) -> String {
		return String(format: self, arguments: args)
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

public extension NSString {
	func rangeOrNil(of searchString: String, options mask: NSString.CompareOptions = [], range rangeOfReceiverToSearch: NSRange? = nil, locale: Locale? = nil) -> NSRange? {
		if let searchRange = rangeOfReceiverToSearch {
			if let locale = locale {
				return self.range(of:searchString, options:mask, range: searchRange, locale:locale).nilIfNotFound
			}
			return self.range(of:searchString, options:mask, range: searchRange).nilIfNotFound
		}
		return self.range(of:searchString, options:mask).nilIfNotFound
	}
}
