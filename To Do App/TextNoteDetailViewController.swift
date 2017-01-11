//
//  TextNoteDetailViewController.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 08/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import CoreData

class TextNoteDetailViewController: UIViewController, UIMaker, UIAlertMaker {
    
    @IBOutlet weak var noteTitle: CustomTextField!
    @IBOutlet weak var additionalNotes: CustomTextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var priorityOfTask: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var singleNote: NSManagedObject?
    var note: String = ""
    var extraNotes: String = ""
    var priority: String = ""
    var dueDate: String = ""
    
    var priorities = ["heigh", "medium", "low"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        
        priorityOfTask.delegate = self
        priorityOfTask.dataSource = self
        
        // TODO: Move to custom class
        deleteButton.userInteractionEnabled = false
        deleteButton.alpha = 0.2
        
        priorityOfTask.selectRow(0, inComponent: 0, animated: false)
        
        if let singleNote = singleNote {
            setUI(with: singleNote)
        }
    }
    
    @IBAction func saveNote(sender: AnyObject) {
        
        if let note = noteTitle.text where note == "" {
            showAlert(withTitle: "Note title is empty", withMessage: "You need to specify at least note title")
        } else {
            
            setDate()
            
            if let note = noteTitle.text {
                self.note = note
            }
            
            if let extraNotes = additionalNotes.text {
                self.extraNotes = extraNotes
            }
            
            if let singleNote = singleNote {
                singleNote.setValue(note, forKey: "note")
                singleNote.setValue(extraNotes, forKey: "extraNotes")
                singleNote.setValue(priority, forKey: "priority")
                singleNote.setValue(dueDate, forKey: "dueDate")
                
                globalCoreDataFunctions.updateTextNote(singleNote)
                
                let localNotification = UILocalNotification()
                localNotification.fireDate = datePicker.date
                localNotification.applicationIconBadgeNumber = 0
                localNotification.soundName = UILocalNotificationDefaultSoundName
                
//                localNotification.userInfo = [
//                    "message": "Heloo",
//                ]
                
                localNotification.alertTitle = self.note
                localNotification.alertBody = "Body"
                
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)


            } else {
                globalCoreDataFunctions.saveTextNote(note, extraNotes: extraNotes, priority: priority, dueDate: dueDate)
            }
        }
    }
    
    @IBAction func deleteNote(sender: AnyObject) {
        if let singleNote = singleNote {
            globalCoreDataFunctions.deleteObject(singleNote)
        }
    }
    
    @IBAction func backButtonForTest(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setDate() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        dueDate = dateString
    }
    
    func setUI(with singleNote: NSManagedObject) {
        
        deleteButton.userInteractionEnabled = true
        deleteButton.alpha = 1
        
        noteTitle.text = singleNote.valueForKey("note") as? String
        additionalNotes.text = singleNote.valueForKey("extraNotes") as? String
        
        if let setPriority = singleNote.valueForKey("priority") as? String {
            switch setPriority {
            case "heigh":
                priorityOfTask.selectRow(0, inComponent: 0, animated: false)
            case "medium":
                priorityOfTask.selectRow(1, inComponent: 0, animated: false)
            case "low":
                priorityOfTask.selectRow(2, inComponent: 0, animated: false)
            default:
                priorityOfTask.selectRow(0, inComponent: 0, animated: false)
            }
        }
        
        if let dueDate = singleNote.valueForKey("dueDate") as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .ShortStyle
            if let dateFromString = dateFormatter.dateFromString(dueDate) {
                datePicker.setDate(dateFromString, animated: true)
            }
        }
    }
}

extension TextNoteDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let priority = priorities[row]
        return priority
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorities.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priority = priorities[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = priorities[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }
    
}
