//
//  AnyDayTests.swift
//  AnyDayTests
//
//  Created by Grzegorz Kwaśniewski on 22/02/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import XCTest


@testable import AnyDay
class AnyDayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_TableViewIsNotNilInTextNotesViewController() {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let textNotesVC = storyboard.instantiateViewControllerWithIdentifier("TextNotesViewController") as! TextNotesViewController
        
        // we need this to access viewDidLoad()
        _ = textNotesVC.view
        
        XCTAssertNotNil(textNotesVC.tableView)
        
    }
}
