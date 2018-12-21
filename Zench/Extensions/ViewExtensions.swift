//
//  ViewExtensions.swift
//  Zench
//
//  Created by Jesse Hao on 2018/12/5.
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
	
	func addLongPressGesture(target:Any?, action:Selector?) {
		self.addGestureRecognizer(UILongPressGestureRecognizer(target: target, action: action))
	}
	
	func setShadow(withOpacity opacity:Float, offsetX:Double, offsetY:Double, blur:CGFloat, color:UIColor) {
		self.layer.setShadow(withOpacity: opacity, offsetX: offsetX, offsetY: offsetY, blur: blur, color: color.cgColor)
	}
	
	func setBorder(withColor color:UIColor, thickness:CGFloat = 1, cornerRadius:CGFloat = 0) {
		self.layer.setBorder(withColor: color.cgColor, thickness: thickness)
		self.layer.cornerRadius = cornerRadius
	}
	
	var insetForSafeAreaOrZero:UIEdgeInsets {
		if #available(iOS 11.0, *) {
			return self.safeAreaInsets
		}
		return .zero
	}
	
	class func animateOrNot(_ animated:Bool, duration:TimeInterval, closure:@escaping () -> Void, completeHandler:((Bool) -> Void)?) {
		guard animated else {
			closure()
			completeHandler?(true)
			return
		}
		UIView.animate(withDuration: duration, animations: closure, completion: completeHandler)
	}
	
	class func animateOrNot(_ animated:Bool, duration:TimeInterval = 0.3, closure:@escaping () -> Void) {
		self.animateOrNot(animated, duration: duration, closure: closure, completeHandler: nil)
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

public extension UITableView {
	var hasCell:Bool {
		return self.numberOfSections > 0 && self.numberOfRows(inSection: 0) > 0
	}
	
	func registerCells(withDictionary dict:[String:AnyClass]) {
		dict.forEach { self.register($1, forCellReuseIdentifier: $0) }
	}
	
	var lastSection:Int? {
		return self.numberOfSections > 0 ? self.numberOfSections - 1 : nil
	}
	
	func lastRow(inSection section:Int) -> Int? {
		let count = self.numberOfRows(inSection: section)
		return count > 0 ? count - 1 : nil
	}
	
	func indexPathForFirstCell() -> IndexPath? {
		guard let section = (0..<self.numberOfSections).first(where: { self.numberOfRows(inSection: $0) > 0 }) else { return nil }
		return [section, 0]
	}
	
	func indexPathForLastCell() -> IndexPath? {
		var row:Int = -1
		guard let section = (0..<self.numberOfSections).last(where: {
			row = self.numberOfRows(inSection: $0) - 1
			return row >= 0
		}) else { return nil }
		return [section, row]
	}
	
	func scrollToTopRow(animated:Bool = true) {
		guard let indexPath = self.indexPathForFirstCell() else { return }
		self.scrollToRow(at: indexPath, at: .top, animated: animated)
	}
	
	func scrollToBottomRow(animated:Bool = true) {
		guard let indexPath = self.indexPathForLastCell() else { return }
		self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
	}
}

public extension UITextView {
	func selectedIndexRange() -> Range<String.Index> {
		let beginIndex = self.text.index(self.text.startIndex,
										 offsetBy: self.selectedRange.location)
		let endIndex = self.text.index(beginIndex, offsetBy: self.selectedRange.length)
		return (beginIndex..<endIndex)
	}
}

extension UITextView : ZenchNamespaceWrappable {}
public extension ZenchNamespaceWrapper where T : UITextView {
	func shouldTextIncrease(afterChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return (range.location >= self.wrappedValue.text.count && range.length > 0)
			|| (range.location < self.wrappedValue.text.count && range.length < text.count)
	}
	
	func shouldTextDecrease(afterChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return range.location < self.wrappedValue.text.count
			&& range.length > text.count
	}
}

extension UIMenuController : ZenchNamespaceWrappable {}
public extension ZenchNamespaceWrapper where T : UIMenuController {
	static func hideIfVisible(animated:Bool = true) {
		if UIMenuController.shared.isMenuVisible {
			UIMenuController.shared.setMenuVisible(false, animated: true)
		}
	}
}
