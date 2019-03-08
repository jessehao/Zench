//
//  Protocols.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

public protocol StandardNoParameterInitializable {
    init()
}

// MARK: - Standard Nullable
public protocol StandardNullable : NullableSupport {
	var orNil:Self? { get }
}

// MARK: - Copying
public protocol StandardDuplicatable {
    func duplicate() throws -> Self
}

public extension StandardDuplicatable where Self : Codable {
	public func duplicate() throws -> Self { return try JSONDecoder().decode(Self.self, from: try JSONEncoder().encode(self)) }
}

// MARK: - Localizable
public protocol StandardLocalizable {
	var localized: String { get }
}

public extension StandardLocalizable {
	static func combinedLocalizedDescription(for localizables:StandardLocalizable...) -> String {
		return localizables.reduce("") { $0 + $1.localized }
	}
}

public extension StandardLocalizable where Self : RawRepresentable, Self.RawValue == String {
	var localized: String {
		return NSLocalizedString(self.rawValue, comment: "")
	}
}

// MARK: - ObjC Runtime
public protocol StandardDynamicObjectAssociatable {
	func setAssociatedObject(_ object:Any?, forKey key:UnsafeRawPointer, withPolicy policy:objc_AssociationPolicy)
	func associatedObject(forKey key:UnsafeRawPointer) -> Any?
}

public extension StandardDynamicObjectAssociatable {
	func setAssociatedObject(_ object:Any?, forKey key:UnsafeRawPointer, withPolicy policy:objc_AssociationPolicy) {
		objc_setAssociatedObject(self, key, object, policy)
	}
	
	func associatedObject(forKey key:UnsafeRawPointer) -> Any? {
		return objc_getAssociatedObject(self, key)
	}
}

public protocol StandardDynamicInspectable : AnyObject, StandardDynamicObjectAssociatable {
	func `class`() -> Self.Type?
}

public extension StandardDynamicInspectable {
	func `class`() -> Self.Type? {
		return object_getClass(self) as? Self.Type
	}
}
