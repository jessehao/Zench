//
//  StandardTableViewController.swift
//  Zench
//
//  Created by Jesse Hao on 2018/11/2.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

class StandardTableViewController: StandardViewController<BaseView>, StandardTableViewDelegate, StandardTableViewDataSource {
	
	// MARK: - Interface
	var style:UITableView.Style { return .plain }
	var baseView:BaseView? { return nil }
	private(set) lazy var tableView = StandardTableView(frame: .zero, style: self.style)
	var clearsSelectionOnViewWillAppear: Bool = false
	var deselectRowAfterSelected:Bool = false
	private(set) var hasLoadedData:Bool = false
	
	// MARK: - Lifecycle
	override func loadView() {
		guard let baseView = self.baseView else {
			super.loadView()
			return
		}
		self.view = baseView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.addSubview(self.tableView)
		self.tableViewDidAdded()
		self.makeConstraintsFor(tableView: self.tableView)
		self.configTableView(self.tableView)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.clearsSelectionIfNeeded()
	}
	
	// MARK: - StandardTableView Data Source
	func tableViewWillLoadData() {}
	func tableViewDidLoadData() {
		self.hasLoadedData = true
	}
	
	// MARK: - UITableView Data Source
	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 0 }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let fatalRetval:UITableViewCell? = nil
		return fatalRetval!
	}
	
	// MARK: - UITableView Delegate
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? { return indexPath }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if self.deselectRowAfterSelected {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return nil }
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return nil }
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return nil }
	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? { return nil }
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return false }
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {}
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { return .none }
	func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? { return LocalizableStrings.delete.rawValue.localizedString }
	
	// MARK: - Actions
	@objc func refreshHeaderPulled() {}
	@objc func refreshFooterPulled() {}
	
	// MARK: - Operation
	func tableViewDidAdded() {}
	
	func makeConstraintsFor(tableView:UITableView) {
		if let superview = tableView.superview {
			tableView.topAnchor.constraint(equalTo: superview.topAnchor)
			tableView.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
			tableView.leftAnchor.constraint(equalTo: superview.leftAnchor)
			tableView.rightAnchor.constraint(equalTo: superview.rightAnchor)
		}
	}
	
	func configTableView(_ tableView: StandardTableView) {
		tableView.standardDelegate = self
		tableView.standardDataSource = self
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 48
	}
	
	func clearsSelectionIfNeeded() {
		if self.clearsSelectionOnViewWillAppear {
			self.tableView.indexPathsForSelectedRows?.forEach {
				self.tableView.deselectRow(at: $0, animated: true)
			}
		}
	}
}
