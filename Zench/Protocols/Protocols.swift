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

// MARK: - Notification Support
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

// MARK: - Pasteboard Support
public protocol StandardPasteboardSupport {
	func copyToGeneralPasteboard(withString string:String)
}

public extension StandardPasteboardSupport {
	func copyToGeneralPasteboard(withString string:String) {
		UIPasteboard.general.string = string
	}
}

// MARK: - Localizable
public protocol StandardLocalizable {
	func localizedDescription() -> String
}

public extension StandardLocalizable {
	static func combinedLocalizedDescription(for localizables:StandardLocalizable...) -> String {
		return localizables.reduce("") { $0 + $1.localizedDescription() }
	}
}

public extension StandardLocalizable where Self : RawRepresentable, Self.RawValue == String {
	func localizedDescription() -> String {
		return NSLocalizedString(self.rawValue, comment: "")
	}
}

// MARK: - ObjC Runtime
public protocol DynamicObjectAssociatable {
	func setAssociatedObject(_ object:Any?, forKey key:UnsafeRawPointer, withPolicy policy:objc_AssociationPolicy)
	func associatedObject(forKey key:UnsafeRawPointer) -> Any?
}

public extension DynamicObjectAssociatable {
	func setAssociatedObject(_ object:Any?, forKey key:UnsafeRawPointer, withPolicy policy:objc_AssociationPolicy) {
		objc_setAssociatedObject(self, key, object, policy)
	}
	
	func associatedObject(forKey key:UnsafeRawPointer) -> Any? {
		return objc_getAssociatedObject(self, key)
	}
}
