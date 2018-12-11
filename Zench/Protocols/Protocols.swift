//
//  Protocols.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

public protocol StandardNoParameterInitializable {
    init()
}

// MARK: - Copying
public protocol StandardDuplicatable {
    func duplicate() throws -> Self
}

public extension StandardDuplicatable where Self : Codable {
	public func duplicate() throws -> Self { return try JSONDecoder().decode(Self.self, from: try JSONEncoder().encode(self)) }
}

// MARK: - Supports
public protocol StandardNotificationSupport {
	/// add specific selector to observe a specific notification name of notification center.
	///
	/// - Parameters:
	///   - selector: the target selector when the notification received
	///   - notificationName: the notification name that you wanna observe
	func addSelector(_ selector:Selector, onNotificationName notificationName:Notification.Name)
	/// Listen to a specific notification name and handles event when received
	///
	/// - Parameters:
	///   - notificationName: the notification name that you wanna listen to
	///   - handler: a handler called when notification received
	func listenToNotificationName(_ notificationName:Notification.Name, using handler:@escaping (Notification) -> Void)
}

public extension StandardNotificationSupport {
	func addSelector(_ selector:Selector, onNotificationName notificationName:Notification.Name) {
		NotificationCenter.default.addObserver(self, selector: selector, name: notificationName, object: nil)
	}
	
	func listenToNotificationName(_ notificationName:Notification.Name, using handler:@escaping (Notification) -> Void) {
		NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil, using: handler)
	}
}
