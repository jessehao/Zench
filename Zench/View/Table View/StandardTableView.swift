//
//  StandardTableView.swift
//  Zench
//
//  Created by Jesse Hao on 2018/11/2.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

public protocol StandardTableViewDataSource: UITableViewDataSource {
	func tableViewWillLoadData()
	func tableViewDidLoadData()
}

public extension StandardTableViewDataSource {
	func tableViewWillLoadData() {}
	func tableViewDidLoadData() {}
}

public protocol StandardTableViewDelegate: UITableViewDelegate {}

open class StandardTableView: UITableView {
	open weak var standardDataSource:StandardTableViewDataSource? { didSet { self.dataSource = self.standardDataSource } }
	open weak var standardDelegate:StandardTableViewDelegate? { didSet { self.delegate = self.standardDelegate } }
	
    open override func reloadData() {
		self.standardDataSource?.tableViewWillLoadData()
		super.reloadData()
		DispatchQueue.main.async { [weak self] in
			self?.standardDataSource?.tableViewDidLoadData()
		}
	}
}
