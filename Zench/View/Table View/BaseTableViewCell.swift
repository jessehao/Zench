//
//  BaseTableViewCell.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
	var defaultSelectionStyle:UITableViewCell.SelectionStyle { return .default }
	var indexPath:IndexPath?
	var defaultBackgroundColor:UIColor { return .white }
	
	// MARK: - Lifecycle
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
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
		self.prepareForTargets()
		self.backgroundColor = self.defaultBackgroundColor
		self.selectionStyle = self.defaultSelectionStyle
	}
	
	func prepareSubviews() {}
	func makeConstraints() {}
	func prepareForTargets() {}
}
