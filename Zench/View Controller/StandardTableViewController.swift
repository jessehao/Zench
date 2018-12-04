//
//  StandardTableViewController.swift
//  Zench
//
//  Created by Jesse Hao on 2018/11/2.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

open class StandardTableViewController: StandardViewController<BaseView>, StandardTableViewDelegate, StandardTableViewDataSource {
	
	// MARK: - Interface
	open var style:UITableView.Style { return .plain }
	open var baseView:BaseView? { return nil }
	open private(set) lazy var tableView = StandardTableView(frame: .zero, style: self.style)
	open var clearsSelectionOnViewWillAppear: Bool = false
	open var deselectRowAfterSelected:Bool = false
	open private(set) var hasLoadedData:Bool = false
	
	// MARK: - Lifecycle
	open override func loadView() {
		guard let baseView = self.baseView else {
			super.loadView()
			return
		}
		self.view = baseView
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.addSubview(self.tableView)
		self.tableViewDidAdded()
		self.makeConstraintsFor(tableView: self.tableView)
		self.configTableView(self.tableView)
	}
	
	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.clearsSelectionIfNeeded()
	}
	
	// MARK: - StandardTableView Data Source
	open func tableViewWillLoadData() {}
	open func tableViewDidLoadData() {
		self.hasLoadedData = true
	}
	
	// MARK: - UITableView Data Source
	open func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 0 }
	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let fatalRetval:UITableViewCell? = nil
		return fatalRetval!
	}
	
	// MARK: - UITableView Delegate
	open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? { return indexPath }
	
	open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if self.deselectRowAfterSelected {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
	open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}
	
	open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return nil }
	
	open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return nil }
	
	open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	
	open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return nil }
	open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? { return nil }
	
	open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return false }
	open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {}
	open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { return .none }
	open func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? { return LocalizableStrings.delete.rawValue.localizedString }
	
	// MARK: - Actions
	@objc open func refreshHeaderPulled() {}
	@objc open func refreshFooterPulled() {}
	
	// MARK: - Operation
	open func tableViewDidAdded() {}
	
	open func makeConstraintsFor(tableView:UITableView) {
		if let superview = tableView.superview {
			tableView.topAnchor.constraint(equalTo: superview.topAnchor)
			tableView.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
			tableView.leftAnchor.constraint(equalTo: superview.leftAnchor)
			tableView.rightAnchor.constraint(equalTo: superview.rightAnchor)
		}
	}
	
	open func configTableView(_ tableView: StandardTableView) {
		tableView.standardDelegate = self
		tableView.standardDataSource = self
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 48
	}
	
	open func clearsSelectionIfNeeded() {
		if self.clearsSelectionOnViewWillAppear {
			self.tableView.indexPathsForSelectedRows?.forEach {
				self.tableView.deselectRow(at: $0, animated: true)
			}
		}
	}
}
