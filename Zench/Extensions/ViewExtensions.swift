//
//  ViewExtensions.swift
//  Zench
//
//  Created by 郝泽 on 2018/12/5.
//  Copyright © 2018 Snoware. All rights reserved.
//

public extension CALayer {
	func setShadow(withOpacity opacity:Float, offsetX:Double, offsetY:Double, blur:CGFloat, color:CGColor) {
		self.shadowColor = color
		self.shadowOpacity = opacity
		self.shadowOffset = CGSize(width: offsetX, height: offsetY)
		self.shadowRadius = blur
	}
	
	func setBorder(withColor color:CGColor, thickness:CGFloat) {
		self.borderColor = color
		self.borderWidth = thickness
	}
}

public extension UIView {
	func addSubview(_ subviews:UIView...) {
		subviews.forEach { self.addSubview($0) }
	}
	
	func addSubview<S>(_ subviews:S) where S : Sequence, S.Element : UIView {
		subviews.forEach { self.addSubview($0) }
	}
	
	func removeAllSubviews() {
		self.subviews.forEach {
			$0.removeConstraints($0.constraints)
			$0.removeFromSuperview()
		}
	}
	
	func addTapGesture(target:Any?, action:Selector?) {
		self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
	}
	
	func setShadow(withOpacity opacity:Float, offsetX:Double, offsetY:Double, blur:CGFloat, color:UIColor) {
		self.layer.setShadow(withOpacity: opacity, offsetX: offsetX, offsetY: offsetY, blur: blur, color: color.cgColor)
	}
	
	func setBorder(withColor color:UIColor, thickness:CGFloat = 1, cornerRadius:CGFloat = 0) {
		self.layer.setBorder(withColor: color.cgColor, thickness: thickness)
		self.layer.cornerRadius = cornerRadius
	}
}

public extension UILabel {
	convenience init(withFont font:UIFont, color:UIColor, text:@autoclosure () -> String? = nil) {
		self.init()
		self.font = font
		self.textColor = color
		self.text = text()
	}
	
	convenience init(withSystemFontSize size:CGFloat, weight: UIFont.Weight, color:UIColor, text:@autoclosure () -> String? = nil) {
		self.init(withFont: .systemFont(ofSize: size, weight: weight), color: color, text: text)
	}
	
	convenience init(withPingFangSCFontSize size:CGFloat, weight: UIFont.Weight, color:UIColor, text:@autoclosure () -> String? = nil) {
		self.init(withFont: .pingFangSCFont(ofSize: size, weight: weight), color: color, text: text)
	}
}

public extension UIButton {
	convenience init(withImage image:UIImage?) {
		self.init()
		self.setImage(image, for: .normal)
	}
	
	class func textButton(text:String, font:UIFont, color:UIColor) -> UIButton {
		let retval = UIButton()
		retval.titleLabel?.font = font
		retval.setTitleColor(color, for: .normal)
		retval.setTitle(text, for: .normal)
		return retval
	}
}

public extension UISwitch {
	func reverse() {
		self.setOn(!self.isOn, animated: true)
	}
}