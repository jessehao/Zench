//
//  GeneralButton.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

class GeneralButton: StandardButton {
	private var backgroundColorDict:[UIControl.State:UIColor] = [:]
	
	// MARK: - Interface
	open var foregroundColor:UIColor? {
		get { return self.titleColor(for: .normal) }
		set { self.setTitleColor(newValue, for: .normal) }
	}
	
	open override var isEnabled: Bool {
		get { return super.isEnabled }
		set {
			super.isEnabled = newValue
			self.redrawBackgroundColor()
		}
	}
	
	open override var isHighlighted: Bool {
		get { return super.isHighlighted }
		set {
			super.isHighlighted = newValue
			self.redrawBackgroundColor()
		}
	}
	
	open override var isSelected: Bool {
		get { return super.isSelected }
		set {
			super.isSelected = newValue
			self.redrawBackgroundColor()
		}
	}
	
	open var isTitleLabelHidden:Bool = false { didSet { self.titleLabel?.layer.opacity = self.isTitleLabelHidden ? 0 : 1 } }
	
	// MARK: - Operations
	open func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
		self.backgroundColorDict[state] = color
		if self.state == state {
			self.redrawBackgroundColor()
		}
	}
	
	open func redrawBackgroundColor() {
		self.backgroundColor = self.backgroundColorDict[self.state] ?? self.backgroundColorDict[.normal]
	}
}

// MARK: - LoadingButton
class LoadingButton : GeneralButton {
	open var isLoading:Bool {
		get { return !self.activityIndicator.isHidden }
		set {
			self.setLoadingEnable(newValue)
		}
	}
	
	public let activityIndicator:UIActivityIndicatorView = {
		let retval = UIActivityIndicatorView()
		retval.stopAnimating()
		retval.hidesWhenStopped = true
		return retval
	}()
	
	open func setLoadingEnable(_ enable:Bool) {
		self.isEnabled = self.isEnabled && !enable
		self.isTitleLabelHidden = enable
		if enable {
			self.activityIndicator.startAnimating()
		} else {
			self.activityIndicator.stopAnimating()
		}
	}
	
	open func startLoading() {
		self.setLoadingEnable(true)
	}
	
	open func stopLoading() {
		self.setLoadingEnable(false)
	}
	
	open override func prepareSubviews() {
		super.prepareSubviews()
		self.addSubview(self.activityIndicator)
	}
	
	open override func makeConstraints() {
		super.makeConstraints()
		if let superview = self.activityIndicator.superview {
			self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
			self.activityIndicator.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
			self.activityIndicator.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
		}
	}
}
