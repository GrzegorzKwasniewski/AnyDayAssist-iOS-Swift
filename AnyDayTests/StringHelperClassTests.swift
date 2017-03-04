//
//  StringHelperClassTests.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 04/03/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import XCTest

@testable import AnyDay
class StringHelperClassTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_LanguageSpecificSignsAreRemoved() {
        
        let polishText = "Bącki"
        let portugueseText = "Macarrão"
        
        let formatedPolishText = StringHelperClass.removeSpecialCharsFromString(polishText)
        let formatedPortugueseText = StringHelperClass.removeSpecialCharsFromString(portugueseText)
        
        XCTAssertEqual(formatedPolishText, "Backi")
        XCTAssertEqual(formatedPortugueseText, "Macarrao")
    }
    
}
