//
//  BaseTableViewCell.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

open class BaseTableViewCell: UITableViewCell, ViewPatternProtocol {
	
	open var defaultSelectionStyle:UITableViewCell.SelectionStyle { return .default }
	open var indexPath:IndexPath?
	open var defaultBackgroundColor:UIColor { return .white }
	
	// MARK: - Lifecycle
	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.setup()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	// MARK: - Operations
	open func setup() {
		self.prepareSubviews()
		self.makeConstraints()
		self.prepareTargets()
		self.backgroundColor = self.defaultBackgroundColor
		self.selectionStyle = self.defaultSelectionStyle
	}
	
	open func prepareSubviews() {}
	open func makeConstraints() {}
	open func prepareTargets() {}
}
