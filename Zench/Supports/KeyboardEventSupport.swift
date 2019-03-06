//
//  KeyboardEventSupport.swift
//  Zench
//
//  Created by Jesse Hao on 2019/3/6.
//  Copyright © 2019 Snoware. All rights reserved.
//

import Foundation

public protocol KeyboardEventSupport : class {
	/// Called immediately prior to the display of the keyboard. **configured in `GeneralViewController.addToNotificationCenter`**
	///
	/// - Parameter userInfo: The userInfo contains information about the keyboard.
	func keyboardWillShow(userInfo:StandardKeyboardNotificationUserInfo)
	
	/// Called immediately prior to the dismissal of the keyboard.  **configured in `GeneralViewController.addToNotificationCenter`**
	///
	/// - Parameter userInfo: The userInfo contains information about the keyboard.
	func keyboardWillHide(userInfo:StandardKeyboardNotificationUserInfo)
	
	/// Called immediately prior to a change in the keyboard’s frame.  **configured in `GeneralViewController.addToNotificationCenter`**
	///
	/// - Parameter userInfo: The userInfo contains information about the keyboard.
	func keyboardWillChangeFrame(userInfo:StandardKeyboardNotificationUserInfo)
	
	func keyboardDidShow(userInfo:StandardKeyboardNotificationUserInfo)
	
	func keyboardDidHide(userInfo:StandardKeyboardNotificationUserInfo)
	
	func keyboardDidChangeFrame(userInfo:StandardKeyboardNotificationUserInfo)
}

public extension KeyboardEventSupport {
	func registerKeyboardEvent() -> NotificationTokenManager {
		let retval = NotificationTokenManager()
		let notificationCenter = NotificationCenter.default
		retval.notificationCenter = notificationCenter
		retval.addNotificationName(UIResponder.keyboardWillShowNotification) { [weak self] in
			self?.keyboardWillShow(userInfo: StandardKeyboardNotificationUserInfo(withUserInfoDict: $0.userInfo!))
		}
		retval.addNotificationName(UIResponder.keyboardWillHideNotification) { [weak self] in
			self?.keyboardWillHide(userInfo: StandardKeyboardNotificationUserInfo(withUserInfoDict: $0.userInfo!))
		}
		retval.addNotificationName(UIResponder.keyboardWillChangeFrameNotification) { [weak self] in
			self?.keyboardWillChangeFrame(userInfo: StandardKeyboardNotificationUserInfo(withUserInfoDict: $0.userInfo!))
		}
		retval.addNotificationName(UIResponder.keyboardDidShowNotification) { [weak self] in
			self?.keyboardDidShow(userInfo: StandardKeyboardNotificationUserInfo(withUserInfoDict: $0.userInfo!))
		}
		retval.addNotificationName(UIResponder.keyboardDidHideNotification) { [weak self] in
			self?.keyboardDidHide(userInfo: StandardKeyboardNotificationUserInfo(withUserInfoDict: $0.userInfo!))
		}
		retval.addNotificationName(UIResponder.keyboardDidChangeFrameNotification) { [weak self] in
			self?.keyboardDidChangeFrame(userInfo: StandardKeyboardNotificationUserInfo(withUserInfoDict: $0.userInfo!))
		}
		return retval
	}
	func keyboardWillShow(userInfo:StandardKeyboardNotificationUserInfo) {}
	func keyboardWillHide(userInfo:StandardKeyboardNotificationUserInfo) {}
	func keyboardWillChangeFrame(userInfo:StandardKeyboardNotificationUserInfo) {}
	func keyboardDidShow(userInfo:StandardKeyboardNotificationUserInfo) {}
	func keyboardDidHide(userInfo:StandardKeyboardNotificationUserInfo) {}
	func keyboardDidChangeFrame(userInfo:StandardKeyboardNotificationUserInfo) {}
}

public final class NotificationTokenManager {
	var tokens:[NSObjectProtocol] = []
	weak var notificationCenter:NotificationCenter?
	
	deinit {
		self.removeAllTokens()
	}
}

public extension NotificationTokenManager {
	@discardableResult
	func addNotificationName(_ name:Notification.Name, object:Any? = nil, queue:OperationQueue? = nil, using:@escaping (Notification) -> Void) -> Bool {
		guard let center = self.notificationCenter else { return false }
		self.tokens += center.addObserver(forName: name, object: object, queue: queue, using: using)
		return true
	}
	
	func removeAllTokens() {
		while let token = self.tokens.popLast() {
			self.notificationCenter?.removeObserver(token)
		}
	}
}
