//
//  TextNoteDetailViewController.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 08/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class TextNoteDetailViewController: UIViewController, UIMaker, UIAlertMaker {
    
    @IBOutlet weak var noteTitle: CustomTextField!
    @IBOutlet weak var additionalNotes: CustomTextView!
    @IBOutlet weak var priorityOfTask: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
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

            globalCoreDataFunctions.saveTextNote(note, extraNotes: extraNotes, priority: priority, dueDate: dueDate)
        }
    }
    
    func setDate() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        dueDate = dateString
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
