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
	
	public var canPopFromNavigationController:Bool {
		return self.navigationController != nil && self.navigationController?.rootViewController != self
	}
	
	public func removeFromNotificationCenter() {
		NotificationCenter.default.removeObserver(self)
	}
	
	public func withNavigationController() -> UINavigationController {
		return UINavigationController(rootViewController: self)
	}
	
	func close(completion:(() -> Void)? = nil) {
		self.view.endEditing(true)
		if self.canPopFromNavigationController {
			self.navigationController?.popViewController(animated: true)
			completion?()
		} else {
			self.dismiss(animated: true) {
				completion?()
			}
		}
	}
}

public extension UINavigationController {
	public var rootViewController:UIViewController? { return self.viewControllers.first }
}

extension UIAlertController : ZenchNamespaceWrappable {}
public extension ZenchNamespaceWrapper where T : UIAlertController {
	static func notice(title:String? = nil, message:String?, buttonTitle:String, handler:@escaping (UIAlertAction) -> Void) -> ZenchNamespaceWrapper<T> {
		let retval = T(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: buttonTitle, style: .cancel, handler: handler)
		retval.addAction(action)
		return retval.zench
	}
	
	static func confirmationAlert(title:String? = nil,
								  message:String?,
								  confirmButtonTitle:String,
								  confirmButtonStyle:UIAlertAction.Style = .default,
								  cancelButtonTitle:String,
								  confirmationHandler:@escaping (UIAlertAction) -> Void) -> ZenchNamespaceWrapper<T> {
		let retval = T(title: title, message: message, preferredStyle: .alert)
		let cancel = UIAlertAction(title: cancelButtonTitle, style: .cancel)
		let confirm = UIAlertAction(title: confirmButtonTitle, style: confirmButtonStyle, handler: confirmationHandler)
		retval.addAction(cancel)
		retval.addAction(confirm)
		return retval.zench
	}
}
