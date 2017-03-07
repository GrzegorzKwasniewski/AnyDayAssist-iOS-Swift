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
    var testedLabel = UILabel()
    
    override func setUp() {
        super.setUp()
        
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        textNotesVC = storyboard.instantiateViewControllerWithIdentifier("TextNotesViewController") as! TextNotesViewController
        
        testedLabel = textNotesVC.messageLabel
        
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
    
    func test_ShouldSetTableViewDelegate() {
        textNotesVC.viewWillAppear(true)
        XCTAssertTrue(textNotesVC.tableView.delegate is TextNotesTableDelegate)
    }
    
    func test_DeafultCenterIsNotNil() {
        XCTAssertNotNil(textNotesVC.notificationCenter)
    }
    
    func test_MessageLabelIsNotNil() {
        XCTAssertNotNil(textNotesVC.messageLabel)
    }
    
    func test_MessageLableHasCorrectPositions() {
        
        XCTAssertEqual(testedLabel.bounds.size.width, textNotesVC.view.bounds.width)
        XCTAssertEqual(testedLabel.bounds.size.height, textNotesVC.view.bounds.height)
        
        XCTAssertEqual(testedLabel.bounds.origin.x, 0)
        XCTAssertEqual(testedLabel.bounds.origin.y, 0)
    }
    
    func test_MessageLabelHasCorrectTag() {
        textNotesVC.viewWillAppear(true)
        XCTAssertEqual(testedLabel.tag, 100)
    }
    
    func test_MessageLabelIsSubViewOfViewController() {
        
        textNotesVC.viewWillAppear(true)
        
        let subviews = textNotesVC.view.subviews
        var searchedSubView: UILabel?
        
        for subview in subviews {
            if subview.tag == 100 {
                searchedSubView = subview as? UILabel
            }
        }
        
        XCTAssertNotNil(searchedSubView)
    }
    
    // TODO: Napisz resztę testów dla UILabel
    
    func test_ProperitesOfMessageLabel() {
        
        let testArray = [NSManagedObject]()
        
        textNotesVC.setMessageLabel(arrayToCount: testArray, messageLabel: testedLabel)
        
        XCTAssertEqual(testedLabel.font.familyName, "Helvetica Neue")
        XCTAssertEqual(testedLabel.font.pointSize, 20)
        
        XCTAssertEqual(testedLabel.textColor, UIColor.whiteColor())
        XCTAssertEqual(testedLabel.textAlignment, NSTextAlignment.Center, "Text should be centered")
        
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
