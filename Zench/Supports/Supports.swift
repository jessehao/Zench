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

// MARK: - ViewController Automatic Close BarButtonItem Support
@objc
public protocol ViewControllerAutomaticCloseBarButtonItemSupport : class {
	@objc
	func cancelBarButtonTouched()
}

public extension ViewControllerAutomaticCloseBarButtonItemSupport where Self : UIViewController {
	@discardableResult
	func prepareAutomaticCloseBarButtonItemSupport() -> UIBarButtonItem? {
		if !self.canPopSelfFromNavigationController {
			let retval = UIBarButtonItem(image: UIImage(named: "task_icon_close"), style: .plain, target: self, action: #selector(self.cancelBarButtonTouched))
			self.navigationItem.leftBarButtonItem = retval
			return retval
		}
		return nil
	}
}

// MARK: - Convenient Right NavigationBarButtonItem Support
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
	@discardableResult
	func prepareRightNavigationBarButtonItemSupport(_ title:String? = nil) -> UIBarButtonItem {
		let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.rightNavigationBarButtonItemTouched(sender:)))
		self.navigationItem.rightBarButtonItem = item
		return item
	}
}

// MARK: - Convenient RefreshControl Support
@objc
public protocol ConvenientRefreshControlSupport : class {
	@objc
	func refreshControlValueChanged(sender:UIRefreshControl)
}

public extension ConvenientRefreshControlSupport {
	@discardableResult
	func prepareRefreshControlSupport(for scrollView:UIScrollView) -> UIRefreshControl {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
		if #available(iOS 10.0, *) {
			scrollView.refreshControl = refreshControl
		} else {
			scrollView.addSubview(refreshControl)
		}
		return refreshControl
	}
}

// MARK: - TableView Update Support
public protocol TableViewUpdateSupport {}
public extension TableViewUpdateSupport where Self : UITableView {
	func updates(_ operation:((Self) -> Void)? = nil) {
		self.beginUpdates()
		operation?(self)
		self.endUpdates()
	}
}
