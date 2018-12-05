//
//  Extensions.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

import Foundation

extension NSObject : StandardNoParameterInitializable, StandardClassConfigurable, StandardClassConfigurableInitializer {}

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
}

public extension LosslessStringConvertible {
	var string:String { return String(self) }
}
