//
//  Extensions.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

import Foundation

extension NSObject : StandardLeisurelyInitializer, StandardClassConfigurable, StandardClassConfigurableInitializer {}

extension UIControl.State : Hashable {
	public var hashValue: Int {
		return self.rawValue.hashValue
	}
}

extension UIFont {
	class func pingFangSCFont(ofSize size:CGFloat, weight:UIFont.Weight) -> UIFont {
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
