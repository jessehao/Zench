//
//  BaseCollectionViewCell.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UITableViewHeaderFooterView {
	var indexPath:IndexPath?
	
	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
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
		self.prepareTargets()
	}
	
	func prepareSubviews() {}
	func makeConstraints() {}
	func prepareTargets() {}
}
