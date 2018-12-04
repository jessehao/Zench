//
//  BaseCollectionViewCell.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

open class BaseCollectionViewCell: UICollectionViewCell {
	open var indexPath:IndexPath?
	
	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}
	
    required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	// MARK: - Operations
	open func setup() {
		self.prepareSubviews()
		self.makeConstraints()
		self.prepareTargets()
	}
	
	open func prepareSubviews() {}
	open func makeConstraints() {}
	open func prepareTargets() {}
}
