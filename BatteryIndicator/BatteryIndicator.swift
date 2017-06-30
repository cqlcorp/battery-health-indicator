//
//  BatteryIndicator.swift
//  BatteryIndicator
//
//  Created by Tom Stoepker on 6/30/17.
//  Copyright © 2017 Crush Only. All rights reserved.
//

import UIKit

class BatteryIndicator: UIView {
	
	private let terminalWidth: CGFloat = 10
	
	private let topLayer = CAShapeLayer()
	private let bottomLayer = CAShapeLayer()
	private let chargeIndicator = CALayer()
	private let indicatorClip = UIView()
	private let batteryTerminal = CALayer()
	
	var batteryColor = UIColor.black
	
	var lineWidth: CGFloat = 2.0 {
		didSet {
			drawLayers()
		}
	}
	
	var cornerRadius: CGFloat = 10 {
		didSet {
			drawLayers()
		}
	}
	
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
		addLayers()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		addLayers()
	}
	
	convenience init() {
		self.init(frame: CGRect())
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		drawLayers()
	}
	
	private func addLayers() {
		indicatorClip.clipsToBounds = true
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
		drawBottomLayer(midY: midY, endX: endX)
		
		let terminalHeight = bounds.size.height / 3
		batteryTerminal.backgroundColor = batteryColor.cgColor
		batteryTerminal.frame = CGRect(x: endX, y: (bounds.size.height / 2) - (terminalHeight / 2), width: terminalWidth, height: terminalHeight)
		
		indicatorClip.layer.cornerRadius = cornerRadius
		indicatorClip.frame = CGRect(x: 0, y: 0, width: bounds.size.width - terminalWidth, height: bounds.size.height)
		
		chargeIndicator.frame = CGRect(x: 0, y: 0, width: 0, height: bounds.size.height)
	}
	
	private func style(layer: CAShapeLayer) {
		layer.fillColor = nil
		layer.lineWidth = lineWidth
		layer.strokeColor = batteryColor.cgColor
	}
	
	private func drawTopLayer(midY: CGFloat, endX: CGFloat) {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: midY))
		path.addLine(to: CGPoint(x: 0, y: cornerRadius))
		path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0), controlPoint: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: endX - cornerRadius, y: 0))
		path.addQuadCurve(to: CGPoint(x: endX, y: cornerRadius), controlPoint: CGPoint(x: endX, y: 0))
		path.addLine(to: CGPoint(x: endX, y: cornerRadius))
		path.addLine(to: CGPoint(x: endX, y: midY))
		topLayer.path = path.cgPath
		style(layer: bottomLayer)
	}
	
	private func drawBottomLayer(midY: CGFloat, endX: CGFloat) {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: midY))
		path.addLine(to: CGPoint(x: 0, y: bounds.size.height - cornerRadius))
		path.addQuadCurve(to: CGPoint(x: cornerRadius, y: bounds.size.height), controlPoint: CGPoint(x: 0, y: bounds.size.height))
		path.addLine(to: CGPoint(x: endX - cornerRadius, y: bounds.size.height))
		path.addQuadCurve(to: CGPoint(x: endX, y: bounds.size.height - cornerRadius), controlPoint: CGPoint(x: endX, y: bounds.size.height))
		path.addLine(to: CGPoint(x: endX, y: midY))
		bottomLayer.path = path.cgPath
		style(layer: topLayer)
	}
}
