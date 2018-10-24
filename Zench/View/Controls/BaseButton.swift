//
//  BaseButton.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	// MARK: - Operations
	func setup() {
		self.prepareSubviews()
		self.makeConstraints()
	}
	func prepareSubviews() {}
	func makeConstraints() {}
}

class StandardShapeButton: BaseButton {
	override class var layerClass : AnyClass { return CAShapeLayer.self }
	var shapeLayer:CAShapeLayer { return self.layer as! CAShapeLayer }
	
	func setDashedBorder(withThickness thickness:CGFloat,
						 borderColor:UIColor,
						 dotWidth:NSNumber = 2,
						 separatorWidth:NSNumber = 2) {
		self.shapeLayer.fillColor = UIColor.clear.cgColor
		self.shapeLayer.strokeColor = borderColor.cgColor
		self.shapeLayer.lineWidth = thickness
		self.shapeLayer.lineJoin = CAShapeLayerLineJoin.round
		self.shapeLayer.lineDashPhase = 0
		self.shapeLayer.lineDashPattern = [dotWidth, separatorWidth]
	}
}

// TODO: Standard Gradient Button
