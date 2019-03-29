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

extension UIView : ZenchNamespaceWrappable {}
public extension ZenchNamespaceWrapper where T : UIView {
	func add(to superview:UIView) -> ZenchNamespaceWrapper {
		superview.addSubview(self.unwrapped)
		return self
	}
}

extension Array where Element : UIView {
	func withStackView() -> UIStackView {
		return UIStackView(arrangedSubviews: self)
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

public extension UIScrollView {
	/// Zench: Scroll to bottom of scrollView.
	///
	/// - Parameter animated: set true to animate scroll (default is true).
	func scrollToBottom(animated: Bool = true) {
		let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
		setContentOffset(bottomOffset, animated: animated)
	}
	
	/// Zench: Scroll to top of scrollView.
	///
	/// - Parameter animated: set true to animate scroll (default is true).
	func scrollToTop(animated: Bool = true) {
		setContentOffset(CGPoint.zero, animated: animated)
	}
}

public extension UITableView {
	convenience init(style:Style) {
		self.init(frame: .zero, style: style)
	}
	
	var hasCell:Bool {
		let sectionCount = self.numberOfSections
		guard sectionCount > 0 else { return false }
		return (0..<sectionCount).contains { self.numberOfRows(inSection: $0) > 0 }
	}
	
	/// Zench: Number of all rows in all sections of tableView.
	///
	/// - Returns: The count of all rows in the tableView.
	func numberOfRows() -> Int {
		let sectionCount = self.numberOfSections
		guard sectionCount > 0 else { return 0 }
		return (0..<sectionCount).reduce(0) { $0 + self.numberOfRows(inSection: $1) }
	}
	
	func registerCells(withDictionary dict:[String:AnyClass]) {
		dict.forEach { self.register($1, forCellReuseIdentifier: $0) }
	}
	
	var lastSectionIndex:Int? {
		return self.numberOfSections > 0 ? self.numberOfSections - 1 : nil
	}
	
	func lastRowIndex(inSection section:Int) -> Int? {
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
	
	/// Reload data with a completion handler.
	///
	/// - Parameter completion: completion handler to run after reloadData finishes.
	func reloadData(_ completion: @escaping () -> Void) {
		UIView.animate(withDuration: 0, animations: {
			self.reloadData()
		}, completion: { _ in
			completion()
		})
	}
}

extension UITableView : TableViewUpdateSupport {}

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
		return (range.location >= self.unwrapped.text.count && range.length > 0)
			|| (range.location < self.unwrapped.text.count && range.length < text.count)
	}
	
	func shouldTextDecrease(afterChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return range.location < self.unwrapped.text.count
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

extension UIControl.State : Hashable {
	public var hashValue: Int {
		return self.rawValue.hashValue
	}
}

public extension UIFont {
	class func pingFangSCFont(ofSize size:CGFloat, weight:UIFont.Weight) -> UIFont {
		var fontStr = "PingFangSC-"
		switch weight {
		case Weight.semibold:
			fontStr += "Semibold"
		case Weight.light:
			fontStr += "Light"
		case Weight.medium:
			fontStr += "Medium"
		case Weight.bold:
			fontStr += "Bold"
		case Weight.regular:
			fontStr += "Regular"
		default:
			fontStr += "Regular"
		}
		return UIFont(name: fontStr, size: size)!
	}
}

public extension UICollectionView.ScrollPosition {
	static var none:UICollectionView.ScrollPosition { return UICollectionView.ScrollPosition(rawValue: 0) }
}
