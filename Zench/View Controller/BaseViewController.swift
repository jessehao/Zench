//
//  BaseViewController.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
	var defaultContentSize:CGSize? { return nil }
	private(set) var viewDidLoaded:Bool = false
	
	// MARK: - Interface
	var identifier:String = ""
	
	// MARK: - Lifecycle
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.viewDidLoaded = true
		super.viewWillAppear(animated)
	}
	
	deinit { self.removeFromNotificationCenter() }
	
	// MARK: - Operations
	/// Instead of init functions. revoke this when you want to initialize the controller.
	func setup() {
		if let size = self.defaultContentSize {
			self.preferredContentSize = size
		}
	}
	
	func endEditing(force:Bool = false) {
		self.view.endEditing(force)
	}
}
