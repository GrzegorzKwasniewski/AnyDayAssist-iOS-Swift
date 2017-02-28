//
//  e.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 22/02/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import XCTest

@testable import AnyDay
class TextNotesDatasourceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_NumberOfSectionsIsOne() {
        
        let tableViewDelegate = TextNotesTableDelegate()
        let tableView = UITableView()
        
        tableView.delegate = tableViewDelegate
        
        let numberOfSections = tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 1)
        
    }
}
