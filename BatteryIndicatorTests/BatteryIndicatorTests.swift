//
//  BatteryIndicatorTests.swift
//  BatteryIndicatorTests
//
//  Created by Tyler Luce on 7/7/17.
//  Copyright © 2017 Crush Only. All rights reserved.
//

import XCTest

@testable import BatteryIndicator

class BatteryIndicatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPrecentCharged_Initialize() {
        let indicator = BatteryIndicator();
        XCTAssert(indicator.precentCharged == 0)
        
    }
    
    func testPrecentCharged_LowBound() {
        let indicator = BatteryIndicator();
        let oldChargeIndicator = indicator.chargeIndicator
        indicator.precentCharged = -1
        XCTAssert(indicator.precentCharged == -1)
        XCTAssert(indicator.chargeIndicator.isEqual(oldChargeIndicator))
        
    }
    
    func testPrecentCharged_HighBound() {
        let indicator = BatteryIndicator();
        let oldChargeIndicator = indicator.chargeIndicator
        indicator.precentCharged = 101
        XCTAssert(indicator.precentCharged == 101)
        XCTAssert(indicator.chargeIndicator.isEqual(oldChargeIndicator))
        
    }
    
    func testPrecentCharged_Healthy() {
        let indicator = BatteryIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        indicator.precentCharged = 100
        
        XCTAssert(indicator.precentCharged == 100)
        XCTAssert(indicator.chargeIndicator.frame.minX == 0)
        XCTAssert(indicator.chargeIndicator.frame.minY == 0)
        XCTAssert(indicator.chargeIndicator.frame.width == 100 * 1)
        XCTAssert(indicator.chargeIndicator.frame.height == 30)
        XCTAssert(indicator.chargeIndicator.backgroundColor == indicator.healthy.cgColor)
    }
    
    func testPrecentCharged_AtHealthy() {
        let indicator = BatteryIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        indicator.precentCharged = 50
        
        XCTAssert(indicator.precentCharged == 50)
        XCTAssert(indicator.chargeIndicator.frame.minX == 0)
        XCTAssert(indicator.chargeIndicator.frame.minY == 0)
        XCTAssert(indicator.chargeIndicator.frame.width == 100 * 0.5)
        XCTAssert(indicator.chargeIndicator.frame.height == 30)
        XCTAssert(indicator.chargeIndicator.backgroundColor == indicator.healthy.cgColor)
    }
    
    func testPrecentCharged_Warning() {
        let indicator = BatteryIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        indicator.precentCharged = 49
        
        XCTAssert(indicator.precentCharged == 49)
        XCTAssert(indicator.chargeIndicator.frame.minX == 0)
        XCTAssert(indicator.chargeIndicator.frame.minY == 0)
        XCTAssert(indicator.chargeIndicator.frame.width == 100 * 0.49)
        XCTAssert(indicator.chargeIndicator.frame.height == 30)
        XCTAssert(indicator.chargeIndicator.backgroundColor == indicator.warning.cgColor)
    }
    
    func testPrecentCharged_AtWarning() {
        let indicator = BatteryIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        indicator.precentCharged = 10
        
        XCTAssert(indicator.precentCharged == 10)
        XCTAssert(indicator.chargeIndicator.frame.minX == 0)
        XCTAssert(indicator.chargeIndicator.frame.minY == 0)
        XCTAssert(indicator.chargeIndicator.frame.width == 100 * 0.10)
        XCTAssert(indicator.chargeIndicator.frame.height == 30)
        XCTAssert(indicator.chargeIndicator.backgroundColor == indicator.warning.cgColor)
    }
    
    func testPrecentCharged_Low() {
        let indicator = BatteryIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        indicator.precentCharged = 5
        
        XCTAssert(indicator.precentCharged == 5)
        XCTAssert(indicator.chargeIndicator.frame.minX == 0)
        XCTAssert(indicator.chargeIndicator.frame.minY == 0)
        XCTAssert(indicator.chargeIndicator.frame.width == 100 * 0.05)
        XCTAssert(indicator.chargeIndicator.frame.height == 30)
        XCTAssert(indicator.chargeIndicator.backgroundColor == indicator.low.cgColor)
    }
    
    func testPrecentCharged_Empty() {
        let indicator = BatteryIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        indicator.precentCharged = 0
        
        XCTAssert(indicator.precentCharged == 0)
        XCTAssert(indicator.chargeIndicator.frame.minX == 0)
        XCTAssert(indicator.chargeIndicator.frame.minY == 0)
        XCTAssert(indicator.chargeIndicator.frame.width == 0)
        XCTAssert(indicator.chargeIndicator.frame.height == 30)
        XCTAssert(indicator.chargeIndicator.backgroundColor == UIColor.clear.cgColor)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
