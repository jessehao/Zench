//
//  StandardKeyboardNotificationUserInfo.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

public struct StandardKeyboardNotificationUserInfo {
	public var animationCurve:UIView.AnimationCurve?
	public var animationDuration:Double?
	public var isLocal:Bool?
	public var beginFrame:CGRect?
	public var endFrame:CGRect?
	
	public init() {}
	
	public init(withUserInfoDict userInfo:[AnyHashable : Any]) {
		self.init()
		self.setValues(withUserInfoDict: userInfo)
	}
	
	public mutating func setValues(withUserInfoDict userInfo:[AnyHashable : Any]) {
		self.animationCurve = UIView.AnimationCurve(rawValue: Int(truncating: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber))
		self.animationDuration = Double(truncating: userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber)
		self.isLocal = Bool(truncating: userInfo[UIResponder.keyboardIsLocalUserInfoKey] as! NSNumber)
		self.beginFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		self.endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
	}
}
