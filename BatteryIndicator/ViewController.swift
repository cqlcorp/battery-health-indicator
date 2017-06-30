//
//  ViewController.swift
//  BatteryIndicator
//
//  Created by Tom Stoepker on 6/30/17.
//  Copyright © 2017 Crush Only. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var batterIndicator: BatteryIndicator!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		batterIndicator.precentCharged = 32
		batterIndicator.animatedReveal = true
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func updateButton(_ sender: Any) {
		batterIndicator.precentCharged = Double(arc4random_uniform(UInt32(100 - 1))) + 1
	}

}

