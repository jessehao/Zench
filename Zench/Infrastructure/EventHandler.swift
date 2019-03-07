//
//  EventHandler.swift
//  Zench
//
//  Created by Jesse Hao on 2019/3/7.
//  Copyright © 2019 Snoware. All rights reserved.
//

import Foundation

open class EventHandler<ParamType> {
	public typealias Action = (ParamType) -> Void
	private var actionMap:[UUID:Action] = [:]
	open func execute(param:ParamType) {
		self.actionMap.forEach { _, handler in
			handler(param)
		}
	}
	
	open func subscribe(_ new:@escaping Action) -> UUID {
		let token = UUID()
		self.actionMap[token] = new
		return token
	}
	
	open func invalid(_ token:UUID) {
		self.actionMap[token] = nil
	}
}

public extension EventHandler {
	static func += (handler:EventHandler, action:@escaping Action) -> UUID {
		return handler.subscribe(action)
	}
}
