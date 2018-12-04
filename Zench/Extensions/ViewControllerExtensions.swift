//
//  ViewControllerExtensions.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

import Foundation

public extension UIViewController {
    public static func currentViewController() -> UIViewController? {
		var controller = UIApplication.shared.keyWindow?.rootViewController
		while true {
			if controller is UITabBarController {
				let tabController = controller as! UITabBarController
				controller = tabController.selectedViewController
				continue
			} else if controller is UINavigationController {
				let navController = controller as! UINavigationController
				controller = navController.visibleViewController
				continue
			} else if controller?.presentedViewController != nil{
				controller = controller?.presentedViewController
				continue
			} else {
				break
			}
		}
		return controller
	}
	
	public var keyWindow:UIWindow? { return UIApplication.shared.keyWindow }
	
	public var canPopSelfFromNavigationController:Bool {
		return self.navigationController != nil && self.navigationController?.rootViewController != self
	}
	
	public func removeFromNotificationCenter() {
		NotificationCenter.default.removeObserver(self)
	}
	
	public func withNavigationController() -> UINavigationController {
		return UINavigationController(rootViewController: self)
	}
}

public extension UINavigationController {
	public var rootViewController:UIViewController? { return self.viewControllers.first }
}
