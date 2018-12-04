//
//  StandardSize.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

import Foundation

public enum StandardSize {
    case fullscreen
	case halfscreen
	case custom(value: CGFloat)
}

public extension StandardSize {
	public static let screenSize = UIScreen.main.bounds.size
	public static let screenHeight = screenSize.height
	public static let screenWidth = screenSize.width
}

public extension StandardSize {
	public var valueForHeight:CGFloat {
		switch self {
		case .fullscreen: return StandardSize.screenHeight
		case .halfscreen: return StandardSize.screenHeight / 2
		case .custom(let value): return value
		}
	}
	
	public var valueForWidth:CGFloat {
		switch self {
		case .fullscreen: return StandardSize.screenWidth
		case .halfscreen: return StandardSize.screenWidth / 2
		case .custom(let value): return value
		}
	}
	
	public static func cgSize(withWidth width:StandardSize, height:StandardSize) -> CGSize {
		return CGSize(width: width.valueForWidth, height: height.valueForHeight)
	}
}
