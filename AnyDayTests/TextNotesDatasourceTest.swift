//
//  e.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 22/02/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import XCTest
import CoreData

@testable import AnyDay
class TextNotesDatasourceTest: XCTestCase {
    
    let tableView = UITableView()
    
    override func setUp() {
        super.setUp()
        
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_NumberOfSections_Equals_One() {
        
        let tableViewDelegate = TextNotesTableDelegate()
        
        tableView.delegate = tableViewDelegate
        
        let numberOfSections = tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 1)
        
    }
    
    func test_NumberOfCells_Equals_TodoNotes() {
        
        let tableViewDelegate = TextNotesTableDelegate()
        let entity = NSEntityDescription.entityForName("Notes", inManagedObjectContext: contextOfOurApp)
        var testArray: [NSManagedObject] = [TextNote(note: "Title", extraNote: "Extra Notes", entity: entity!, insertIntoManagedObjectContext: contextOfOurApp)]
        
        let _ = TextNotesDatasource(items: testArray, tableView: tableView, delegate: tableViewDelegate)
        
        XCTAssertEqual(tableView.numberOfRowsInSection(0), 1)
        
        testArray.append(TextNote(note: "Title_2", extraNote: "Extra Notes_2", entity: entity!, insertIntoManagedObjectContext: contextOfOurApp))
        
        let _ = TextNotesDatasource(items: testArray, tableView: tableView, delegate: tableViewDelegate)
        
        XCTAssertEqual(tableView.numberOfRowsInSection(0), 2)
        
    }
    
    func test_CellForRow_ReturnsTodoCell() {
    
        // given
        let tableViewDelegate = TextNotesTableDelegate()
        let entity = NSEntityDescription.entityForName("Notes", inManagedObjectContext: contextOfOurApp)
        let testArray: [NSManagedObject] = [TextNote(note: "Title", extraNote: "Extra Notes", entity: entity!, insertIntoManagedObjectContext: contextOfOurApp)]
        
        // when
        let _ = TextNotesDatasource(items: testArray, tableView: tableView, delegate: tableViewDelegate)
        let cell = tableView.dequeueReusableCellWithIdentifier("CellTextNote")
        
        // then
        XCTAssertTrue(cell is CellTextNote, "Cell is not CellTextNote type")
    
    }
}

extension TextNotesDatasource {
    
    class MockTableView : UITableView {
        
        var cellGotDequeued = false
        
        override func dequeueReusableCellWithIdentifier(
            identifier: String,
            forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            cellGotDequeued = true
            return super.dequeueReusableCellWithIdentifier(
                identifier,
                forIndexPath: indexPath)
            
        }
    }
}

