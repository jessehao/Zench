//
//  Protocols.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

protocol StandardLeisurelyInitializer {
	init()
}

// MARK: - Copying
protocol StandardDuplicatable {
	func duplicate() throws -> Self
}

extension StandardDuplicatable where Self : Codable {
	func duplicate() throws -> Self { return try JSONDecoder().decode(Self.self, from: try JSONEncoder().encode(self)) }
}
