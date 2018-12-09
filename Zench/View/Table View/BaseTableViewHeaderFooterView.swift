//
//  BaseTableViewHeaderFooterView.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

open class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView, ViewPatternProtocol {
	
	// MARK: - Lifecycle
	public override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
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
		self.contentView.backgroundColor = .clear
	}
	
	open func prepareSubviews() {}
	open func makeConstraints() {}
	open func prepareTargets() {}
}
