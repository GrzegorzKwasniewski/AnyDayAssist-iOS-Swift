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
    
    var stringValidation: StringValidation = .isEmpty
    let textField = UITextField()
    
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
    
    func test_CityNameIsToLong() {
        
        // max allowed characters are 15
        textField.text = "This text is to long"
        
        stringValidation = StringHelperClass.validateCityNameFromUser(withTextField: textField)
        
        XCTAssertEqual(stringValidation, StringValidation.isToLong)
        
    }
    
    func test_CityNameIsValid() {
        
        // max allowed characters are 15
        textField.text = "Text is ok"
        
        stringValidation = StringHelperClass.validateCityNameFromUser(withTextField: textField)
        
        XCTAssertEqual(stringValidation, StringValidation.isValid)
        
        textField.text = "San Frącisco"
        
        stringValidation = StringHelperClass.validateCityNameFromUser(withTextField: textField)
        
        XCTAssertEqual(stringValidation, StringValidation.isValid)

    }
    
}
