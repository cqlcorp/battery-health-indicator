//
//  BatteryIndicator.swift
//  BatteryIndicator
//
//  Created by Tom Stoepker on 6/30/17.
//  Copyright © 2017 Crush Only. All rights reserved.
//

import UIKit

class BatteryIndicator: UIView {
	
	
	//MARK: - width of positive batter terminal (will be sized to 2.5% of bounds.size.width)
	private var terminalWidth: CGFloat = 0.0
	
	//MARK: - top layer is the layer used to draw the top/left outline of the battery icon
	private let topLayer = CAShapeLayer()
	
	//MARK: - bottom layer is the layer used to draw the bottom/right outline of the battery icon
	private let bottomLayer = CAShapeLayer()
	
	//MARK: - charge indicator shows how much battery is left
	private let chargeIndicator = CALayer()
	
	private let indicatorClip = UIView()
	private let batteryTerminal = CALayer()
	
	
	//Set the battery color to update the icon outline and terminal stroke/background color
	var batteryColor = UIColor.black
	
	var animatedReveal = false {
		willSet {
			if newValue {
				batteryTerminal.opacity = 0
				let n = precentCharged
				precentCharged = 0
				topLayer.strokeEnd = 0
				bottomLayer.strokeEnd = 0
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
					self.reveal(layer: self.topLayer)
					self.reveal(layer: self.bottomLayer)
				})
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
					self.precentCharged = n
				})
			}
		}
	}
	
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
	
	var healthyMin: Double = 50
	var warningMin: Double = 10
	
	var precentCharged: Double = 0 {
		willSet {
			if newValue > 100 || newValue < 0 { return }
			let width = (bounds.size.width - terminalWidth)
			let chargedWidth = CGFloat((newValue / 100) * Double(width))
			chargeIndicator.frame = CGRect(x: 0, y: 0, width: chargedWidth, height: bounds.size.height)
			if newValue < healthyMin && newValue >= warningMin {
				chargeIndicator.backgroundColor = warning.cgColor
			} else if newValue < warningMin && newValue > 0 {
				chargeIndicator.backgroundColor = low.cgColor
			} else if newValue == 0 {
				chargeIndicator.backgroundColor = UIColor.clear.cgColor
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
		chargeIndicator.frame = CGRect(x: 0, y: 0, width: 0, height: bounds.size.height)
		layer.addSublayer(topLayer)
		style(layer: topLayer)
		layer.addSublayer(bottomLayer)
		style(layer: bottomLayer)
		layer.addSublayer(batteryTerminal)
	}
	
	private func drawLayers() {
		let midY = bounds.size.height / 2
		terminalWidth = bounds.size.width * 0.025
		let endX = bounds.size.width - terminalWidth
		
		drawTopLayer(midY: midY, endX: endX)
		drawBottomLayer(midY: midY, endX: endX)
		
		let terminalHeight = bounds.size.height / 3
		batteryTerminal.backgroundColor = batteryColor.cgColor
		batteryTerminal.frame = CGRect(x: endX, y: (bounds.size.height / 2) - (terminalHeight / 2), width: terminalWidth, height: terminalHeight)
		
		indicatorClip.layer.cornerRadius = cornerRadius
		indicatorClip.frame = CGRect(x: 0, y: 0, width: bounds.size.width - terminalWidth, height: bounds.size.height)
		
		//Force redraw of indicator
		let n = precentCharged
		precentCharged = n
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
	}
	
	private func reveal(layer: CAShapeLayer) {
		let stroke = CABasicAnimation(keyPath: "strokeEnd")
		stroke.fromValue = 0.0
		stroke.toValue = 1.0
		stroke.duration = 0.4
		stroke.fillMode = kCAFillModeForwards
		stroke.isRemovedOnCompletion = false
		layer.add(stroke, forKey: nil)
		
		let fade = CABasicAnimation(keyPath: "opacity")
		fade.fromValue = 0.0
		fade.toValue = 1.0
		fade.duration = 0.8
		fade.fillMode = kCAFillModeForwards
		fade.isRemovedOnCompletion = false
		batteryTerminal.add(fade, forKey: nil)
	}
	
	
}
