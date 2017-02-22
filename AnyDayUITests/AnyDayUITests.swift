//
//  AnyDayUITests.swift
//  AnyDayUITests
//
//  Created by Grzegorz Kwaśniewski on 28/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import XCTest

class AnyDayUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testChangingBackgroundToGreenColor() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        XCUIDevice.sharedDevice().orientation = .Portrait
        
        let app = XCUIApplication()
        app.buttons["settings"].tap()
        delay(1.0) {
            app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Button).elementBoundByIndex(2).tap()
        }
        
        delay(1.0) {
            app.alerts["Green background"].collectionViews.buttons["Close"].tap()
        }
        
        delay(1.0) {
            XCUIApplication().navigationBars.buttons["< Back"].tap()
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}
