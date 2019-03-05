//
//  Supports.swift
//  Zench
//
//  Created by Jesse Hao on 2019/2/21.
//  Copyright © 2019 Snoware. All rights reserved.
//

import Foundation

// MARK: - Standard Collection Support
public protocol StandardCollectionSupport : StandardNullable {}
extension Array : StandardCollectionSupport {}
extension Dictionary : StandardCollectionSupport {}
extension Set : StandardCollectionSupport {}

extension String : StandardNullable {
	public var orNil: String? {
		return self.isEmpty ? nil : self
	}
}

public extension Collection where Self : StandardCollectionSupport {
	var orNil:Self? {
		return self.isEmpty ? nil : self
	}
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

// MARK: - ConvenientRightNavigationBarButtonItemSupport
/// Conform this protocol could help you set right navigation bar button item really fast.
///
///	all you need to do is:
/// 1. write `func rightNavigationBarButtonItemTouched(sender:UIBarButtonItem)` in your adopter body.
///	2. if adopted by a UIViewController or its subclass, invoke `setRightNavigationBarButtonItem(_ onConfig:(UIBarButtonItem) -> Void)` after the navigation controller loaded the destination view controller.
@objc
public protocol ConvenientRightNavigationBarButtonItemSupport : class {
	@objc
	func rightNavigationBarButtonItemTouched(sender:UIBarButtonItem)
	
	var navigationItem: UINavigationItem { get }
}

public extension ConvenientRightNavigationBarButtonItemSupport {
	func setRightNavigationBarButtonItem(_ onConfig:(UIBarButtonItem) -> Void) {
		let item = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(self.rightNavigationBarButtonItemTouched(sender:)))
		onConfig(item)
		self.navigationItem.rightBarButtonItem = item
	}
}

public protocol TableViewUpdateSupport {}
public extension TableViewUpdateSupport where Self : UITableView {
	func updates(_ operation:((Self) -> Void)? = nil) {
		self.beginUpdates()
		operation?(self)
		self.endUpdates()
	}
}
