//
//  Namespace.swift
//  Zench
//
//  Created by 郝泽 on 2018/12/5.
//  Copyright © 2018 Snoware. All rights reserved.
//

public protocol ZenchNamespaceWrappable {
	associatedtype ZenchWrapperType:ZenchTypeWrapperProtocol
	var zench:ZenchWrapperType { get }
	static var zench:ZenchWrapperType.Type { get }
}

public extension ZenchNamespaceWrappable {
	public var zench:ZenchNamespaceWrapper<Self> {
		return ZenchNamespaceWrapper(value: self)
	}
	public static var zench:ZenchNamespaceWrapper<Self>.Type {
		return ZenchNamespaceWrapper.self
	}
}

public protocol ZenchTypeWrapperProtocol {
	associatedtype WrappedType
	var wrappedValue: WrappedType { get }
	init(value: WrappedType)
}

public struct ZenchNamespaceWrapper<T> : ZenchTypeWrapperProtocol {
	public var wrappedValue: T
	public init(value: WrappedType) {
		self.wrappedValue = value
	}
}
