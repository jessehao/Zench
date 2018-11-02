//
//  StandardTableView.swift
//  Zench
//
//  Created by Jesse Hao on 2018/11/2.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

protocol StandardTableViewDataSource: UITableViewDataSource {
	func tableViewWillLoadData()
	func tableViewDidLoadData()
}

extension StandardTableViewDataSource {
	func tableViewWillLoadData() {}
	func tableViewDidLoadData() {}
}

protocol StandardTableViewDelegate: UITableViewDelegate {}

class StandardTableView: UITableView {
	weak var standardDataSource:StandardTableViewDataSource? { didSet { self.dataSource = self.standardDataSource } }
	weak var standardDelegate:StandardTableViewDelegate? { didSet { self.delegate = self.standardDelegate } }
	
	override func reloadData() {
		self.standardDataSource?.tableViewWillLoadData()
		super.reloadData()
		DispatchQueue.main.async { [weak self] in
			self?.standardDataSource?.tableViewDidLoadData()
		}
	}
}
