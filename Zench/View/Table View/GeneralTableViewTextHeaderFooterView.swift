//
//  GeneralTableViewTextHeaderFooterView.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

class GeneralTableViewTextHeaderFooterView: StandardTableViewHeaderFooterView {
	// MARK: - Interface
	open var title:String? {
		get { return self.label.text }
		set { self.label.text = newValue }
	}
	
	// MARK: - Components
	private lazy var label:UILabel = {
		let retval = UILabel()
		retval.font = .pingFangSCFont(ofSize: 16, weight: .light)
		retval.textColor = UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: 1)
		return retval
	}()
	
	// MARK: - Operations
	open override func prepareSubviews() {
		super.prepareSubviews()
		self.contentView.addSubview(self.label)
	}
	
	open override func makeConstraints() {
		super.makeConstraints()
		if let superview = self.label.superview {
			self.label.translatesAutoresizingMaskIntoConstraints = false
			self.label.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: 15).isActive = true
			self.label.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
			self.label.topAnchor.constraint(equalTo: superview.topAnchor, constant: 10).isActive = true
			self.label.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -10).isActive = true
		}
	}
}
