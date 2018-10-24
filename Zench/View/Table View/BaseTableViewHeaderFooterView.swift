//
//  BaseTableViewHeaderFooterView.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {
	// MARK: - Lifecycle
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		self.setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	// MARK: - Operations
	func setup() {
		self.prepareSubviews()
		self.makeConstraints()
		self.contentView.backgroundColor = FLLColor.backgroundGray
	}
	
	func prepareSubviews() {}
	func makeConstraints() {}
}
