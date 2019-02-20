//
//  StandardFormViewController.swift
//  Zench
//
//  Created by Jesse Hao on 2019/1/25.
//  Copyright © 2019 Snoware. All rights reserved.
//

open class StandardFormController<FormType:StandardForm>: GeneralTableViewController {
	override open var style: UITableView.Style { return .grouped }
	
	public let headerIdentifier = "HeaderIdentifier"
	
	public let form:FormType = FormType()
	
	open var selectedIndexPath:IndexPath?
	open var editingIndexPath:IndexPath?
	
	private var _tempContentInsetsBottomOffset:CGFloat = 0
	private var _tempScrollIndicatorInsetsBottomOffset:CGFloat = 0
	
	// MARK: - Lifecycle
	override open func viewDidLoad() {
		super.viewDidLoad()
		self.configForm(self.form)
		self.registerDynamicRows()
	}
	
	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.clearsSelectionIfNeeded()
	}
	
	// MARK: - Form Events
	open func configForm(_ form:FormType) {
		form.delegate = self
	}
	open func configDynamicCell(_ cell:UITableViewCell, withIdentifier identifier:String, at index:Int) {}
	open func numberOfRows(forDynamicCellReuseIdentifier identifier:String) -> Int { return 0 }
	open func didSelectDynamicRow(forIdentifier identifier:String, at index:Int) {}
	open func willDeleteDynamicCell(forIdentifier identifier:String, at index:Int) {}
	
	// MARK: - UITableView Data Source
	override open func numberOfSections(in tableView: UITableView) -> Int {
		return self.form.count
	}
	
	override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sec = self.form[section]
		let retval = sec.reduce(0) { sum, row in
			row.dynamicRowCount = row.isDynamic ? self.numberOfRows(forDynamicCellReuseIdentifier: row.reuseIdentifier!) : 1
			return sum + row.dynamicRowCount
		}
		return retval
	}
	
	override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let rowWithOffset = self.form[indexPath]
		if rowWithOffset.row.isDynamic, let identifier = rowWithOffset.row.reuseIdentifier {
			let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
			self.configDynamicCell(cell, withIdentifier: identifier, at: rowWithOffset.offset)
			return cell
		}
		return rowWithOffset.row.cell!
	}
	
	// MARK: - UITableView Delegate
	override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.form[indexPath].row.height
	}
	
	override open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.form[indexPath].row.estimatedHeight
	}
	
	override open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return self.form[section].headerView
	}
	
	override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.form[section].header ?? " "
	}
	
	override open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return self.form[section].footerView
	}
	
	override open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		let rowWithOffset = self.form[indexPath]
		if rowWithOffset.row.canSelect {
			return indexPath
		}
		return nil
	}
	
	override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		super.tableView(tableView, didSelectRowAt: indexPath)
		let rowWithOffset = self.form[indexPath]
		if rowWithOffset.row.isDynamic {
			self.didSelectDynamicRow(forIdentifier: rowWithOffset.row.reuseIdentifier!, at: rowWithOffset.offset)
		} else {
			rowWithOffset.row.onSelectRowEventHandler?()
		}
	}
	
	override open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	override open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		return 10
	}
	
	override open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return self.form[section].footer != nil ? UITableView.automaticDimension : CGFloat.leastNormalMagnitude
	}
	
	override open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return self.form[section].footer ?? " "
	}
	
	override open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return self.form[indexPath].row.canDelete
	}
	
	override open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		if self.form[indexPath].row.canDelete { return .delete }
		return .none
	}
	
	override open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		let rowWithOffset = self.form[indexPath]
		if rowWithOffset.row.canDelete {
			if rowWithOffset.row.isDynamic {
				self.willDeleteDynamicCell(forIdentifier: rowWithOffset.row.reuseIdentifier!, at: rowWithOffset.offset)
				tableView.deleteRows(at: [indexPath], with: .top)
			} else {
				let formRowIndex = self.form[indexPath.section].formRowIndexWithRelativeOffset(forTableViewRowIndex: indexPath.row).index
				tableView.deleteRows(at: [[indexPath.section, formRowIndex]], with: .top)
			}
		}
	}
	
	// MARK: - Actions
	override open func keyboardWillShow(userInfo: StandardKeyboardNotificationUserInfo) {
		let keyboardRect = userInfo.beginFrame
		let keyboardSize = keyboardRect?.size ?? .zero
		let offset:CGFloat = 40
		let bottomOffset = (UIApplication.shared.statusBarOrientation.isPortrait ? keyboardSize.height : keyboardSize.width) + offset
		let rate = userInfo.animationDuration ?? 0
		self._tempContentInsetsBottomOffset = self.tableView.contentInset.bottom
		self._tempScrollIndicatorInsetsBottomOffset = self.tableView.scrollIndicatorInsets.bottom
		UIView.animate(withDuration: rate) {
			self.tableView.contentInset.bottom += bottomOffset
			self.tableView.scrollIndicatorInsets.bottom += bottomOffset
		}
		if let indexPath = self.editingIndexPath {
			self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
			self.editingIndexPath = nil
		}
	}
	
	override open func keyboardWillHide(userInfo: StandardKeyboardNotificationUserInfo) {
		let rate = userInfo.animationDuration ?? 0
		UIView.animate(withDuration: rate) {
			self.tableView.contentInset.bottom = self._tempContentInsetsBottomOffset
			self.tableView.scrollIndicatorInsets.bottom = self._tempScrollIndicatorInsetsBottomOffset
		}
	}
	
	// MARK: - Operations
	override open func configTableView(_ tableView: StandardTableView) {
		super.configTableView(tableView)
		tableView.keyboardDismissMode = .onDrag
	}
	
	open func registerDynamicRows() {
		self.form.allDynamicRows().forEach {
			guard let identifier = $0.reuseIdentifier else { return }
			self.tableView.register($0.cellType, forCellReuseIdentifier: identifier)
		}
	}
}

extension StandardFormController : StandardFormDelegate {
	public func form(_ form: StandardForm, sectionsAddedAt indexes: IndexSet) {
		self.tableView.beginUpdates()
		self.tableView.insertSections(indexes, with: .fade)
		self.tableView.endUpdates()
	}
	
	public func form(_ form: StandardForm, sectionsRemovedAt indexes: IndexSet) {
		self.tableView.beginUpdates()
		self.tableView.deleteSections(indexes, with: .fade)
		self.tableView.endUpdates()
	}
	
	public func form(_ form: StandardForm, sectionsUpdatedAt indexes: IndexSet) {
		self.tableView.beginUpdates()
		self.tableView.reloadSections(indexes, with: .automatic)
		self.tableView.endUpdates()
	}
	
	public func form(_ form: StandardForm, rowsAddedAt indexPaths: [IndexPath]) {
		self.tableView.beginUpdates()
		self.tableView.insertRows(at: indexPaths, with: .middle)
		self.tableView.endUpdates()
	}
	
	public func form(_ form: StandardForm, rowsRemovedAt indexPaths: [IndexPath]) {
		self.tableView.beginUpdates()
		self.tableView.deleteRows(at: indexPaths, with: .top)
		self.tableView.endUpdates()
	}
	
	public func form(_ form: StandardForm, rowsUpdatedAt indexPaths: [IndexPath]) {
		self.tableView.beginUpdates()
		self.tableView.reloadRows(at: indexPaths, with: .automatic)
		self.tableView.endUpdates()
	}
	
	public func needsToReloadData(for form: StandardForm) {
		self.tableView.reloadData()
	}
	
	public func form(_ form: StandardForm, dynamicRowsNeedsToRegister: StandardForm.Row) {
		guard let identifier = dynamicRowsNeedsToRegister.reuseIdentifier else { return }
		self.tableView.register(dynamicRowsNeedsToRegister.cellType, forCellReuseIdentifier: identifier)
	}
}
