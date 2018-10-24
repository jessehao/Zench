//
//  StandardTableViewTextHeaderFooterView.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

class StandardTableViewTextHeaderFooterView: BaseTableViewHeaderFooterView {
	// MARK: - Interface
	var title:String? {
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
	override func prepareSubviews() {
		super.prepareSubviews()
		self.contentView.addSubview(self.label)
	}
	
	override func makeConstraints() {
		super.makeConstraints()
		if let superview = self.label.superview {
			self.label.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: 15)
			self.label.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
			self.label.topAnchor.constraint(equalTo: superview.topAnchor, constant: 10)
			self.label.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -10)
		}
	}
}