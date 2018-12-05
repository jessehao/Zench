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

// MARK: - Copying
public protocol StandardDuplicatable {
    func duplicate() throws -> Self
}

public extension StandardDuplicatable where Self : Codable {
	public func duplicate() throws -> Self { return try JSONDecoder().decode(Self.self, from: try JSONEncoder().encode(self)) }
}
