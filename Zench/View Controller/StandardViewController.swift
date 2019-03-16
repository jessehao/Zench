//
//  StandardViewController.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

class StandardViewController: UIViewController, ViewControllerPatternProtocol {
	open var defaultContentSize:CGSize? { return nil }
	public private(set) var viewDidLoaded:Bool = false
	
	// MARK: - Interface
	open var identifier:String = ""
	
	// MARK: - Lifecycle
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.setup()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	open override func viewWillAppear(_ animated: Bool) {
		self.viewDidLoaded = true
		super.viewWillAppear(animated)
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		self.prepareTargets()
	}
	
	deinit { self.removeFromNotificationCenter() }
	
	// MARK: - Operations
	/// Instead of init functions. revoke this when you want to initialize the controller.
	open func setup() {
		if let size = self.defaultContentSize {
			self.preferredContentSize = size
		}
	}
	
	/// override and fills with Target-Actions in.
	open func prepareTargets() {}
	
	open func endEditing(force:Bool = false) {
		self.view.endEditing(force)
	}
}
