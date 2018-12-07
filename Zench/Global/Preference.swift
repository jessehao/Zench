//
//  Preference.swift
//  Zench
//
//  Created by 郝泽 on 2018/12/7.
//  Copyright © 2018 Snoware. All rights reserved.
//

import Foundation

final class Preference : NSObject {
	var dateStringParsingSet:Set<String> = DateFormatter.zench.defaultDateStringParsingSet
}

// MARK: - Singleton
extension Preference {
	static weak var registered:Preference?
	static func register() -> Preference {
		let retval = Preference()
		defer { Preference.registered = retval }
		return retval
	}
}
