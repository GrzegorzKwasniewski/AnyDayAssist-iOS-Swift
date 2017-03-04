//
//  AnyDayTests.swift
//  AnyDayTests
//
//  Created by Grzegorz Kwaśniewski on 22/02/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import XCTest
import CoreData

@testable import AnyDay
class TextNotesVCTests: XCTestCase {
    
    var storyboard = UIStoryboard()
    var textNotesVC = TextNotesViewController()
    
    override func setUp() {
        super.setUp()
        
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        textNotesVC = storyboard.instantiateViewControllerWithIdentifier("TextNotesViewController") as! TextNotesViewController
        
        // we need this to access viewDidLoad()
        _ = textNotesVC.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_TableViewIsNotNilInTextNotesViewController() {
        XCTAssertNotNil(textNotesVC.tableView)
    }
    
    func test_TableViewDelegateIsNotNil() {
        XCTAssertNotNil(textNotesVC.tableDelegate)
    }
    
    func test_DeafultCenterIsNotNil() {
        XCTAssertNotNil(textNotesVC.notificationCenter)
    }
    
    func test_MessageLabelDisaplyInfoIfArrayIsEqualZero() {
        
        let testLabel = UILabel(frame: CGRectMake(0 , 0, textNotesVC.view.bounds.size.width, textNotesVC.view.bounds.size.height))
        let testArray: [NSManagedObject] = []
        
        textNotesVC.setMessageLabel(arrayToCount: testArray, messageLabel: testLabel)
        
        XCTAssertEqual(testLabel.text, "There's nothing here...")
    }
    
    func test_MessageLabelDontDisaplyInfoIfArrayIsGreaterThanZero() {
        
        let testLabel = UILabel(frame: CGRectMake(0 , 0, textNotesVC.view.bounds.size.width, textNotesVC.view.bounds.size.height))
        let entity = NSEntityDescription.entityForName("Notes", inManagedObjectContext: contextOfOurApp)
        let testArray: [NSManagedObject] = [TextNote(note: "Title", extraNote: "Extra Notes", entity: entity!, insertIntoManagedObjectContext: contextOfOurApp)]
        
        textNotesVC.setMessageLabel(arrayToCount: testArray, messageLabel: testLabel)
                
        XCTAssertEqual(testLabel.text, "")
    }

}

public class TextNote: NSManagedObject {
    
    @NSManaged var note: String
    @NSManaged var extraNotes: String
    @NSManaged var priority: String
    @NSManaged var dueDate: String
    
    convenience init(note: String, extraNote: String, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.note = note
        self.extraNotes = extraNote
    }
}
