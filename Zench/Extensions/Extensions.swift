//
//  Extensions.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

// MARK: - NSObject
extension NSObject : StandardNoParameterInitializable, StandardClassConfigurable, StandardClassConfigurableInitializer {}

// MARK: - Bundle
extension Bundle {
	static weak var zench:Bundle? = Bundle.framework(of: "Zench")
	static func framework(of name:String) -> Bundle? {
		return Bundle.allFrameworks.first { $0.bundleURL.lastPathComponent.contains(name.stringWith(suffix: ".framework")) }
	}
}

// MARK: - Date
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

// MARK: Namespaced
extension DateFormatter : ZenchNamespaceWrappable {}
public extension ZenchNamespaceWrapper where T == DateFormatter {
	static let shared = DateFormatter()
	static let defaultDateStringParsingSet:Set<String> = [
		"y/MM/dd",
		"y-MM-dd",
		"y-MM"
	]
}

// MARK: - Notification Center
extension NotificationCenter {
	func post(name aName: NSNotification.Name) {
		self.post(name: aName, object: nil)
	}
}

// MARK: - JSONSerialization.WritingOptions
public extension JSONSerialization.WritingOptions {
	static var plain:JSONSerialization.WritingOptions { return JSONSerialization.WritingOptions(rawValue: 0) }
}

// MARK: - UnsafePointer
public extension UnsafePointer where Pointee == Int8 {
	var string:String { return String(cString: self) }
}
