//
//  StandardViewController.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

/// The base view controller of Zench. `ViewType` is type of the view which the controller retained.
/// **DO NOT** override initializer if you **REALLY** need to.
open class StandardViewController<ViewType:UIView>: BaseViewController, UIGestureRecognizerDelegate {
	// MARK: - Interface
	/// The unique main view which the controller retained. Use this property after `viewDidLoad`.
	public let mainView = ViewType()
	/// The flag of force the view controller using the `cancelBarButtonItem` in spite it could pop from the navigation controller.
	/// - `nil`: automatic determines whether need to shows the `cancelBarButtonItem`
	open var forceUsingCancelBarButtonItem:Bool? { return nil }
	/// The flag of whether the view controller using the `defaultRightNavigationBarButtonItem`.
	open var defaultRightNavigationBarButtonItemConfiguration:((UIBarButtonItem) -> Void)? { return nil }
	/// The default title of the controller
	open var defaultTitle:String? { return nil }
	
	/// The flag of whether the navigation bar is hidden by default. The view controller detect this flag when view will appear.
	open var isNavigationBarHiddenByDefault:Bool { return false }
	
	open var automaticallyAdjustsScrollViewInsetsByDefault:Bool { return false }
	
	// MARK: - Components
	/// Returns a bar button item that dismiss the controller. **configured in `StandardViewController.configNavigationItem`**
	open var cancelBarButtonItem:UIBarButtonItem? { return self.navigationItem.leftBarButtonItem }
	/// Returns a bar button item that as a default on the right side of navigation bar. Add this when you need it. **configured in `StandardViewController.configNavigationItem`**
	open var defaultRightNavigationBarButtonItem:UIBarButtonItem? { return self.navigationItem.rightBarButtonItem }
	
	// MARK: - Lifecycle
	open override func loadView() {
		self.view = self.mainView
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.interactivePopGestureRecognizer?.delegate = self
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		self.configNavigationItem(self.navigationItem)
		self.configMainView(self.mainView)
		self.prepareTargets()
		self.addToNotificationCenter()
	}
	
	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(self.isNavigationBarHiddenByDefault, animated: true)
	}
	
	open override func viewWillDisappear(_ animated: Bool) {
		self.endEditing()
		super.viewWillDisappear(animated)
	}
	
	// MARK: - Actions
	
	/// the touch event handler of the default right navigation bar button item.
	///
	/// - Parameter sender: the action sender
	@objc open func defaultRightNavigationBarButtonTouched(sender:UIBarButtonItem) {}
	
	/// the touch event handler of the cancel bar button item.
	@objc open func cancelBarButtonTouched() { self.dismiss(animated: true) }
	
	/// Called immediately prior to the display of the keyboard. **configured in `StandardViewController.addToNotificationCenter`**
	///
	/// - Parameter userInfo: The userInfo contains information about the keyboard.
	open func keyboardWillShow(userInfo:StandardKeyboardNotificationUserInfo) {}
	
	/// Called immediately prior to the dismissal of the keyboard.  **configured in `StandardViewController.addToNotificationCenter`**
	///
	/// - Parameter userInfo: The userInfo contains information about the keyboard.
	open func keyboardWillHide(userInfo:StandardKeyboardNotificationUserInfo) {}
	
	/// Called immediately prior to a change in the keyboard’s frame.  **configured in `StandardViewController.addToNotificationCenter`**
	///
	/// - Parameter userInfo: The userInfo contains information about the keyboard.
	open func keyboardWillChangeFrame(userInfo:StandardKeyboardNotificationUserInfo) {}
	
	open func keyboardDidShow(userInfo:StandardKeyboardNotificationUserInfo) {}
	
	// MARK: - Operations
	open override func setup() {
		super.setup()
		self.title = self.defaultTitle
		self.configTabBarItem(self.tabBarItem)
		self.automaticallyAdjustsScrollViewInsets = self.automaticallyAdjustsScrollViewInsetsByDefault
	}
	/// override this when configure the main view.
	///
	/// - Parameter mainView: the main view instance of the controller.
	open func configMainView(_ mainView:ViewType) {}
	
	/// override this function when configure the navigation item.
	///
	/// - Parameter navigationItem: the navigationItem instance of the controller.
	open func configNavigationItem(_ navigationItem:UINavigationItem) {
		if let configuration = self.defaultRightNavigationBarButtonItemConfiguration {
			let item = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(defaultRightNavigationBarButtonTouched(sender:)))
			configuration(item)
			navigationItem.rightBarButtonItem = item
			
		}
		if self.forceUsingCancelBarButtonItem == true || (self.forceUsingCancelBarButtonItem == nil && !self.canPopSelfFromNavigationController) {
			navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelBarButtonTouched))
		}
	}
	
	open func configTabBarItem(_ tabBarItem:UITabBarItem) {}
	
	/// override when you need to observe some `Notification.Name` s, and you don't have to remove them because the `StandardViewController` will handle it.
	open func addToNotificationCenter() {
		self.listenToNotificationName(UIResponder.keyboardWillShowNotification) { [weak self] in
			guard let `self` = self else { return }
			self.keyboardWillShow(userInfo: StandardKeyboardNotificationUserInfo(withUserInfoDict: $0.userInfo!))
		}
		self.listenToNotificationName(UIResponder.keyboardWillHideNotification) { [weak self] in
			guard let `self` = self else { return }
			self.keyboardWillHide(userInfo: StandardKeyboardNotificationUserInfo(withUserInfoDict: $0.userInfo!))
		}
		self.listenToNotificationName(UIResponder.keyboardWillChangeFrameNotification) { [weak self] in
			guard let `self` = self else { return }
			self.keyboardWillChangeFrame(userInfo: StandardKeyboardNotificationUserInfo(withUserInfoDict: $0.userInfo!))
		}
		self.listenToNotificationName(UIResponder.keyboardDidShowNotification) { [weak self] in
			guard let self = self else { return }
			self.keyboardDidShow(userInfo: StandardKeyboardNotificationUserInfo(withUserInfoDict: $0.userInfo!))
		}
	}
	
	/// override and fills with Target-Actions in.
	open func prepareTargets() {}
	
	open func startLoading() {
		self.setLoadingEnable(true)
	}
	
	open func stopLoading() {
		self.setLoadingEnable(false)
	}
	
	open func setLoadingEnable(_ enable:Bool) {
		self.mainView.isUserInteractionEnabled = !enable
	}
}

// MARK: - Generic Helper
public extension StandardViewController {
	public func dial(number:String) -> Bool {
		let tel = "telprompt://" + number
		guard let url = URL(string: tel) else { return false }
		UIApplication.shared.openURL(url)
		return true
	}
}
