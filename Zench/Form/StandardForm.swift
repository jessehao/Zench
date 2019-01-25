//
//  StandardForm.swift
//  Zench
//
//  Created by Jesse Hao on 2019/1/25.
//  Copyright © 2019 Snoware. All rights reserved.
//

public protocol StandardFormDelegate : class {
	func form(_ form:StandardForm, sectionsAddedAt indexes:IndexSet)
	func form(_ form:StandardForm, sectionsRemovedAt indexes:IndexSet)
	func form(_ form:StandardForm, sectionsUpdatedAt indexes:IndexSet)
	func form(_ form:StandardForm, rowsAddedAt indexPaths:[IndexPath])
	func form(_ form:StandardForm, rowsRemovedAt indexPaths:[IndexPath])
	func form(_ form:StandardForm, rowsUpdatedAt indexPaths:[IndexPath])
}

open class StandardForm : NSObject {
	open weak var delegate:StandardFormDelegate?
	
	private var sections:[Section] = []
	
	// MARK: - Lifecycle
	required override public init() {
		super.init()
		self.setup()
	}
	
	// MARK: - Operations
	open func setup() {
		self.sections = self.initialSections()
		self.prepareTargets()
	}
	
	open func prepareTargets() {}
	
	open func initialSections() -> [Section] {
		var retval:[Section] = []
		if let section = self.defaultSection() {
			retval.append(section)
		}
		return retval
	}
	open func defaultSection() -> Section? { return nil }
}

// MARK: - Helper
public extension StandardForm {
	subscript(indexPath:IndexPath) -> (row:Row, offset:Int) {
		let section = self[indexPath.section]
		let rowIndexWithOffset = section.formRowIndexWithRelativeOffset(forTableViewRowIndex: indexPath.row)
		return (section[rowIndexWithOffset.index], rowIndexWithOffset.offset)
	}
	
	func allDynamicRows() -> [Row] {
		var retval:[Row] = []
		self.forEach { retval.append(contentsOf: $0.allDynamicRows()) }
		return retval
	}
}

// MARK: - All Row Iterator
public extension StandardForm {
	struct AllRowIterator: IteratorProtocol {
		public typealias Element = Row
		public weak var form:StandardForm? {
			didSet {
				self.sectionIterator = self.form?.makeIterator()
			}
		}
		private var currentSection:Int = 0
		private var currentRow:Int = 0
		private var sectionIterator:IndexingIterator<StandardForm>?
		private var rowIterator:IndexingIterator<Section>?
		public mutating func next() -> StandardForm.Row? {
			if let row = self.rowIterator?.next() { return row }
			if let section = self.sectionIterator?.next() {
				self.rowIterator = section.makeIterator()
				return self.next()
			}
			return nil
		}
	}
	
	func makeAllRowIterator() -> AllRowIterator {
		var retval = AllRowIterator()
		retval.form = self
		return retval
	}
}

extension StandardForm : Collection {
	public typealias Element = Section
	public typealias Index = Int
	public var startIndex: Int { return self.sections.startIndex }
	public var endIndex: Int { return self.sections.endIndex }
	public func index(after i: Int) -> Int { return self.sections.index(after: i) }
}

extension StandardForm : MutableCollection {
	public subscript(position: Int) -> StandardForm.Section {
		get { return self.sections[position] }
		set {
			self.sections[position] = newValue
			self.delegate?.form(self, sectionsUpdatedAt: [position])
		}
	}
}

public extension StandardForm {
	var appendingIndex:Int { return self.endIndex - 1 }
	
	func insert(_ newElement: StandardForm.Section, at i: Int) {
		newElement.form = self
		self.sections.insert(newElement, at: i)
		self.delegate?.form(self, sectionsAddedAt: [i])
	}
	
	func insert<C>(contentsOf newElements: C, at i: Int) where C : Collection, StandardForm.Element == C.Element {
		newElements.forEach { $0.form = self }
		self.sections.insert(contentsOf: newElements, at: i)
		self.delegate?.form(self, sectionsAddedAt: self.indexes(ForPosition: i, count: newElements.count))
	}
	
	func append(_ newElement: StandardForm.Section) {
		newElement.form = self
		self.sections.append(newElement)
		self.delegate?.form(self, sectionsAddedAt: [self.appendingIndex])
	}
	
	func append<S>(contentsOf newElements: S) where S : Sequence, StandardForm.Element == S.Element {
		newElements.forEach { $0.form = self }
		self.sections.append(contentsOf: newElements)
		self.delegate?.form(self, sectionsAddedAt: self.indexes(ForPosition: self.appendingIndex, count: newElements.underestimatedCount))
	}
	
	func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, StandardForm.Element == C.Element, StandardForm.Index == R.Bound {
		newElements.forEach { $0.form = self }
		self.sections[subrange].forEach { $0.form = nil }
		self.sections.replaceSubrange(subrange, with: newElements)
		let range = subrange.relative(to: self.sections)
		self.delegate?.form(self, sectionsUpdatedAt: IndexSet(range.lowerBound...range.upperBound))
	}
	
	@discardableResult func remove(at position: Int) -> StandardForm.Section {
		defer { self.delegate?.form(self, sectionsRemovedAt: [position]) }
		let retval = self.sections.remove(at: position)
		retval.form = nil
		return retval
	}
	
	func removeSubrange(_ bounds: Range<Int>) {
		defer { self.delegate?.form(self, sectionsRemovedAt: IndexSet(bounds.lowerBound...bounds.upperBound - 1)) }
		self.sections[bounds].forEach { $0.form = nil }
		self.sections.removeSubrange(bounds)
	}
	
	func removeAll(keepingCapacity keepCapacity: Bool = false) {
		defer { self.delegate?.form(self, sectionsRemovedAt: IndexSet(self.startIndex...self.endIndex)) }
		self.sections.forEach { $0.form = nil }
		self.sections.removeAll()
	}
	
	private func indexes(ForPosition position:Int, count:Int) -> IndexSet {
		let tail = position + count - 1
		return IndexSet(position...tail)
	}
}

// MARK: - Section
extension StandardForm {
	open class Section : NSObject, ExpressibleByArrayLiteral {
		open weak var form:StandardForm?
		open private(set) var rows:[Row] = []
		open var header:String?
		open var footer:String?
		// Expressible By Array Literal
		public typealias ArrayLiteralElement = StandardForm.Row
		public required init(arrayLiteral elements: StandardForm.Row...) {
			self.rows = elements
		}
	}
}

// MARK: - Helper
public extension StandardForm.Section {
	var appendingIndex:Int { return self.endIndex - 1 }
	
	convenience init(forForm form:StandardForm) {
		self.init()
		self.form = form
	}
	
	func allDynamicRows() -> [StandardForm.Row] {
		return self.filter { $0.isDynamic }
	}
	
	func formRowIndexWithRelativeOffset(forTableViewRowIndex index:Int) -> (index:Int, offset:Int) {
		var retval = 0
		var i = 0
		var offset = 0
		while i <= index {
			let row = self[retval]
			i += row.isDynamic ? row.dynamicRowCount : 1
			offset = row.isDynamic ? row.dynamicRowCount - (i - index) : 0
			retval += 1
		}
		return (retval - 1, offset)
	}
	
	func tableViewRowIndex(forFormRowIndex index:Int) -> Int {
		let tableViewIndex = self[self.startIndex..<index].reduce(0) { $0 + ($1.isDynamic ? $1.dynamicRowCount : 1) }
		return tableViewIndex
	}
	
	func insertCell(forDynamicRowIdentifier identifier:String, at index:Int) {
		guard let form = self.form, let sectionIndex = form.index(of: self) else { return }
		guard let formIndex = self.index(where: { $0.reuseIdentifier == identifier }) else { return }
		let rowIndex = self.tableViewRowIndex(forFormRowIndex: formIndex) + index
		form.delegate?.form(form, rowsAddedAt: [[sectionIndex, rowIndex]])
	}
	
	func appendCell(forDynamicRowIdentifier identifier:String) {
		guard let form = self.form, let sectionIndex = form.index(of: self) else { return }
		guard let formIndex = self.index(where: { $0.reuseIdentifier == identifier }) else { return }
		let count = self[formIndex].dynamicRowCount
		let rowIndex = self.tableViewRowIndex(forFormRowIndex: formIndex) + count
		form.delegate?.form(form, rowsAddedAt: [[sectionIndex, rowIndex]])
	}
	
	private func indexPaths(ForSection section:Int, rowPosition:Int, rowCount:Int) -> [IndexPath] {
		let rowTail = rowPosition + rowCount - 1
		return (rowPosition...rowTail).map { IndexPath(row: $0, section: section) }
	}
	
	private func rowForIndexPath(fromPosition position:Int) -> Int {
		return self.rows[self.startIndex...(position - 1)].reduce(0) { $0 + ($1.isDynamic ? $1.dynamicRowCount : 1) }
	}
}

extension StandardForm.Section : Collection {
	public typealias Element = StandardForm.Row
	public typealias Index = Int
	public var startIndex: Int { return self.rows.startIndex }
	public var endIndex: Int { return self.rows.endIndex }
	public func index(after i: Int) -> Int { return self.rows.index(after: i) }
	
}

extension StandardForm.Section : MutableCollection {
	public subscript(position: Int) -> StandardForm.Row {
		get { return self.rows[position] }
		set {
			self.rows[position] = newValue
			guard let form = self.form, let section = form.index(of: self) else { return }
			if self.rows[position].isDynamic || newValue.isDynamic {
				form.delegate?.form(form, sectionsUpdatedAt: [section])
			} else {
				form.delegate?.form(form, rowsUpdatedAt: [[section, position]])
			}
		}
	}
}

public extension StandardForm.Section {
	func insert(_ newElement: StandardForm.Row, at i: Int) {
		self.rows.insert(newElement, at: i)
		guard let form = self.form, let section = form.index(of: self) else { return }
		if newElement.isDynamic {
			form.delegate?.form(form, sectionsUpdatedAt: [section])
		} else {
			let row = self.rowForIndexPath(fromPosition: i)
			form.delegate?.form(form, rowsAddedAt: [[section, row]])
		}
	}
	
	func insert<C>(contentsOf newElements: C, at i: Int) where C : Collection, StandardForm.Section.Element == C.Element {
		self.rows.insert(contentsOf: newElements, at: i)
		guard let form = self.form, let section = form.index(of: self) else { return }
		if newElements.contains(where: { $0.isDynamic }) {
			form.delegate?.form(form, sectionsUpdatedAt: [section])
		} else {
			let row = self.rowForIndexPath(fromPosition: i)
			form.delegate?.form(form, rowsAddedAt: self.indexPaths(ForSection: section, rowPosition: row, rowCount: newElements.count))
		}
	}
	
	func append(_ newElement: StandardForm.Row) {
		self.rows.append(newElement)
		guard let form = self.form, let section = form.index(of: self) else { return }
		if newElement.isDynamic {
			form.delegate?.form(form, sectionsUpdatedAt: [section])
		} else {
			let row = self.rowForIndexPath(fromPosition: self.appendingIndex)
			form.delegate?.form(form, rowsAddedAt: [[section, row]])
		}
	}
	
	func append<S>(contentsOf newElements: S) where S : Sequence, StandardForm.Section.Element == S.Element {
		self.rows.append(contentsOf: newElements)
		guard let form = self.form, let section = form.index(of: self) else { return }
		if newElements.contains(where: { $0.isDynamic }) {
			form.delegate?.form(form, sectionsUpdatedAt: [section])
		} else {
			let row = self.rowForIndexPath(fromPosition: self.appendingIndex)
			form.delegate?.form(form, rowsAddedAt: self.indexPaths(ForSection: section, rowPosition: row, rowCount: newElements.underestimatedCount))
		}
	}
	
	func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, StandardForm.Section.Element == C.Element, StandardForm.Section.Index == R.Bound {
		self.rows.replaceSubrange(subrange, with: newElements)
		guard let form = self.form, let section = form.index(of: self) else { return }
		let range = subrange.relative(to: self.rows)
		if self.rows.contains(where: { $0.isDynamic }) || newElements.contains(where: { $0.isDynamic }) {
			form.delegate?.form(form, sectionsUpdatedAt: [section])
		} else {
			form.delegate?.form(form, rowsUpdatedAt: (range.lowerBound...range.upperBound).map { IndexPath(row: $0, section: section) })
		}
	}
	
	@discardableResult func remove(at position: Int) -> StandardForm.Row {
		let row = self.rows.remove(at: position)
		if let form = self.form, let section = form.index(of: self) {
			if row.isDynamic {
				form.delegate?.form(form, rowsRemovedAt: self.indexPaths(ForSection: section, rowPosition: position, rowCount: row.dynamicRowCount))
			} else {
				form.delegate?.form(form, rowsRemovedAt: [[section, position]])
			}
		}
		return row
	}
	
	func removeSubrange(_ bounds: Range<Int>) {
		self.rows.removeSubrange(bounds)
		guard let form = self.form, let section = form.index(of: self) else { return }
		form.delegate?.form(form, rowsRemovedAt: (bounds.lowerBound..<bounds.upperBound).map { IndexPath(row: $0, section: section) })
	}
	
	func removeAll() {
		self.rows.removeAll()
		guard let form = self.form, let section = form.index(of: self) else { return }
		form.delegate?.form(form, sectionsUpdatedAt: [section])
	}
	
	@discardableResult func removeLast() -> StandardForm.Row {
		return self.remove(at: self.count - 1)
	}
}

// MARK: - Row
extension StandardForm {
	open class Row : NSObject {
		open var isValid:Bool { return self.cell != nil || self.isDynamic }
		open var canSelect:Bool = true { didSet { self.cell?.selectionStyle = self.canSelect ? .default : .none } }
		open var canDelete:Bool = false
		// Static
		open private(set) var cell:UITableViewCell?
		open var didSelectRowEventHandler:(() -> Void)?
		// Dynamic
		/// The type for dynamic cell which inherits from `UITableViewCell`
		open private(set) var cellType:AnyClass?
		/// The reuse identifier for dynamic cell.
		open private(set) var reuseIdentifier:String?
		
		/// count 1 represent the single static cell or there is only one dynamic cell.
		open var dynamicRowCount:Int = 1
	}
}

// MARK: - Static Row
public extension StandardForm.Row {
	convenience init(withCell cell:UITableViewCell) {
		self.init()
		self.cell = cell
	}
	@discardableResult func didSelect(_ handler:@escaping () -> Void) -> StandardForm.Row {
		self.didSelectRowEventHandler = handler
		return self
	}
}

// MARK: - Dynamic Row
public extension StandardForm.Row {
	var isDynamic:Bool { return self.cellType != nil && self.reuseIdentifier != nil }
	convenience init(withCellType type:AnyClass, reuseIdentifier identifier:String) {
		self.init()
		self.cellType = type
		self.reuseIdentifier = identifier
	}
}
