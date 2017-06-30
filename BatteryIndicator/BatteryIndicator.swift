//
//  BatteryIndicator.swift
//  BatteryIndicator
//
//  Created by Tom Stoepker on 6/30/17.
//  Copyright © 2017 Crush Only. All rights reserved.
//

import UIKit

class BatteryIndicator: UIView {
	
	private let lineWidth: CGFloat = 2.0
	private let offset: CGFloat = 10
	private let terminalWidth: CGFloat = 10
	
	private let topLayer = CAShapeLayer()
	private let bottomLayer = CAShapeLayer()
	private let chargeIndicator = CALayer()
	private let indicatorClip = UIView()
	private let batteryTerminal = CALayer()
	
	var healthy = UIColor.green
	var warning = UIColor.yellow
	var low = UIColor.red
	
	var healthyMin: Double = 45
	var warningMin: Double = 15
	
	var precentCharged: Double = 100 {
		willSet {
			if newValue > 100 || newValue < 1 { return }
			let width = (bounds.size.width - terminalWidth)
			let chargedWidth = CGFloat((newValue / 100) * Double(width))
			chargeIndicator.frame = CGRect(x: 0, y: 0, width: chargedWidth, height: bounds.size.height)
			if newValue < healthyMin && newValue >= warningMin {
				chargeIndicator.backgroundColor = warning.cgColor
			} else if newValue < warningMin {
				chargeIndicator.backgroundColor = low.cgColor
			} else {
				chargeIndicator.backgroundColor = healthy.cgColor
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		addLayers()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		drawLayers()
	}
	
	private func addLayers() {
		indicatorClip.clipsToBounds = true
		indicatorClip.layer.cornerRadius = offset
		addSubview(indicatorClip)
		indicatorClip.layer.addSublayer(chargeIndicator)
		layer.addSublayer(topLayer)
		layer.addSublayer(bottomLayer)
		layer.addSublayer(batteryTerminal)
	}
	
	private func drawLayers() {
		let midY = bounds.size.height / 2
		let endX = bounds.size.width - terminalWidth
		
		drawTopLayer(midY: midY, endX: endX)
		topLayer.fillColor = nil
		topLayer.lineWidth = lineWidth
		topLayer.strokeColor = UIColor.black.cgColor
		
		drawBottomLayer(midY: midY, endX: endX)
		bottomLayer.fillColor = nil
		bottomLayer.lineWidth = lineWidth
		bottomLayer.strokeColor = UIColor.black.cgColor
		
		let terminalHeight = bounds.size.height / 3
		batteryTerminal.backgroundColor = UIColor.black.cgColor
		batteryTerminal.frame = CGRect(x: endX, y: (bounds.size.height / 2) - (terminalHeight / 2), width: terminalWidth, height: terminalHeight)
		
		indicatorClip.frame = CGRect(x: 0, y: 0, width: bounds.size.width - terminalWidth, height: bounds.size.height)
		
		chargeIndicator.backgroundColor = healthy.cgColor
		precentCharged = 12
	}
	
	private func drawTopLayer(midY: CGFloat, endX: CGFloat) {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: midY))
		path.addLine(to: CGPoint(x: 0, y: offset))
		path.addQuadCurve(to: CGPoint(x: offset, y: 0), controlPoint: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: endX - offset, y: 0))
		path.addQuadCurve(to: CGPoint(x: endX, y: offset), controlPoint: CGPoint(x: endX, y: 0))
		path.addLine(to: CGPoint(x: endX, y: offset))
		path.addLine(to: CGPoint(x: endX, y: midY))
		topLayer.path = path.cgPath
	}
	
	private func drawBottomLayer(midY: CGFloat, endX: CGFloat) {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: midY))
		path.addLine(to: CGPoint(x: 0, y: bounds.size.height - offset))
		path.addQuadCurve(to: CGPoint(x: offset, y: bounds.size.height), controlPoint: CGPoint(x: 0, y: bounds.size.height))
		path.addLine(to: CGPoint(x: endX - offset, y: bounds.size.height))
		path.addQuadCurve(to: CGPoint(x: endX, y: bounds.size.height - offset), controlPoint: CGPoint(x: endX, y: bounds.size.height))		
		path.addLine(to: CGPoint(x: endX, y: midY))
		bottomLayer.path = path.cgPath
	}
	
	private func drawChargeIndicator(endX: CGFloat) {
		
	}
	
}
