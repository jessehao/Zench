//
//  Localization.swift
//  Zench
//
//  Created by Jesse Hao on 2018/11/2.
//  Copyright © 2018 Snoware. All rights reserved.
//


enum Localization : String {
	case delete = "delete"
	case cancel = "cancel"
}

extension Localization : StandardLocalizable {
	func localizedDescription() -> String {
		return Bundle.zench?.localizedString(forKey: self.rawValue, value: nil, table: nil) ?? self.rawValue
	}
}
