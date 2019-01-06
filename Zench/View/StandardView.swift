//
//  StandardView.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/24.
//  Copyright © 2018 Snoware. All rights reserved.
//

import UIKit

open class StandardView: UIView, ViewPatternProtocol {
	open var defaultBackgroundColor:UIColor { return .white }
	
	// MARK: - Lifecycle
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}
	
    public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	// MARK: - Operations
	open func setup() {
		self.backgroundColor = self.defaultBackgroundColor
		self.prepareSubviews()
		self.makeConstraints()
		self.prepareTargets()
	}
	open func prepareSubviews() {}
	open func makeConstraints() {}
	open func prepareTargets() {}
}


open class GeneralShapeView: StandardView {
    override open class var layerClass : AnyClass { return CAShapeLayer.self }
	open var shapeLayer:CAShapeLayer { return self.layer as! CAShapeLayer }
	
	open func setDashedBorder(withThickness thickness:CGFloat,
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

// TODO: Standard Gradient View
