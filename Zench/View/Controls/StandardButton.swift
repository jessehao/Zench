//
//  StandardButton.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

class StandardButton: BaseButton {
	private var backgroundColorDict:[UIControl.State:UIColor] = [:]
	
	// MARK: - Interface
	var foregroundColor:UIColor? {
		get { return self.titleColor(for: .normal) }
		set { self.setTitleColor(newValue, for: .normal) }
	}
	
	var isLoading:Bool = false {
		didSet {
			guard self.isLoading != oldValue else { return }
			self.setLoadingEnable(self.isLoading)
		}
	}
	
	override var isEnabled: Bool {
		get { return super.isEnabled }
		set {
			super.isEnabled = newValue
			self.redrawBackgroundColor()
		}
	}
	
	override var isHighlighted: Bool {
		get { return super.isHighlighted }
		set {
			super.isHighlighted = newValue
			self.redrawBackgroundColor()
		}
	}
	
	override var isSelected: Bool {
		get { return super.isSelected }
		set {
			super.isSelected = newValue
			self.redrawBackgroundColor()
		}
	}
	
	var isTitleLabelHidden:Bool = false { didSet { self.titleLabel?.layer.opacity = self.isTitleLabelHidden ? 0 : 1 } }
	
	// MARK: - Components
	let activityIndicator:UIActivityIndicatorView = {
		let retval = UIActivityIndicatorView()
		retval.stopAnimating()
		retval.hidesWhenStopped = true
		return retval
	}()
	
	// MARK: - Operations
	override func setup() {
		super.setup()
		self.titleLabel?.font = UIFont.pingFangSCFont(ofSize: 15, weight: .medium)
	}
	
	func setLoadingEnable(_ enable:Bool) {
		self.isEnabled = !enable
		self.isTitleLabelHidden = enable
		if enable {
			self.activityIndicator.startAnimating()
		} else {
			self.activityIndicator.stopAnimating()
		}
	}
	
	func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
		self.backgroundColorDict[state] = color
		if self.state == state {
			self.redrawBackgroundColor()
		}
	}
	
	func redrawBackgroundColor() {
		self.backgroundColor = self.backgroundColorDict[self.state] ?? self.backgroundColorDict[.normal]
	}
	
	override func prepareSubviews() {
		super.prepareSubviews()
		self.addSubview(self.activityIndicator)
	}
	
	override func makeConstraints() {
		super.makeConstraints()
		if let superview = self.activityIndicator.superview {
			self.activityIndicator.centerXAnchor.constraint(equalTo: superview.centerXAnchor)
			self.activityIndicator.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
		}
	}
}
