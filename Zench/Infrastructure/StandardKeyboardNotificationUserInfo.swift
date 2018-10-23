//
//  StandardKeyboardNotificationUserInfo.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

struct StandardKeyboardNotificationUserInfo {
	var animationCurve:UIView.AnimationCurve?
	var animationDuration:Double?
	var isLocal:Bool?
	var beginFrame:CGRect?
	var endFrame:CGRect?
	
	init() {}
	
	init(withUserInfoDict userInfo:[AnyHashable : Any]) {
		self.init()
		self.setValues(withUserInfoDict: userInfo)
	}
	
	mutating func setValues(withUserInfoDict userInfo:[AnyHashable : Any]) {
		self.animationCurve = UIView.AnimationCurve(rawValue: Int(truncating: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber))
		self.animationDuration = Double(truncating: userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber)
		self.isLocal = Bool(truncating: userInfo[UIResponder.keyboardIsLocalUserInfoKey] as! NSNumber)
		self.beginFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		self.endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
	}
}
