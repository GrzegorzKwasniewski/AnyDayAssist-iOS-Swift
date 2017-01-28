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
    
    // MARK: - UI
    
    lazy var priorityPicker = UIPickerView()
    lazy var noteTitle: CustomTextField = CustomTextField(placeholderText: "note title")
    lazy var additionalNotes: CustomTextView = CustomTextView()
    lazy var priorityLabel = CustomLabel(text: "set priority")
    lazy var remainderLabel = CustomLabel(text: "set remainder on")
    lazy var datePicker: CustomDatePicker = CustomDatePicker()
    lazy var addNoteButton = CustomButton(bgColor: UIColor.whiteColor(), forAction: .Save)
    lazy var deleteNoteButton = CustomButton(bgColor: UIColor(red: 241/255, green: 82/255, blue: 78/255, alpha: 1), forAction: .Delete)
    var stackView = CustomStackView()
    
    // MARK: - Properties
    
    var priorityPickerDatasource: PriorityPickerDatasource?
    var singleNote: NSManagedObject?
    var note: String = ""
    var extraNotes: String = ""
    //var priority: String = "heigh"
    var dueDate: String = ""
    var priorities = ["heigh", "medium", "low"]
    var marginForViews: CGFloat = 0
    
    // MARK: - View State
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marginForViews = view.frame.width / 20
        stackView = CustomStackView(addViews: [addNoteButton, deleteNoteButton], withSpacing: 20)
        
        addObserversForChange()
        addSubViews()
        setConstraints()
        setView()
        
        priorityPickerDatasource = PriorityPickerDatasource(priorities: priorities, pickerView: priorityPicker)
                
        deleteNoteButton.userInteractionEnabled = false
        deleteNoteButton.alpha = 0.2
                
        if let singleNote = singleNote {
            setUI(with: singleNote)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(forClassWithName: String(TextNoteDetailViewController.self))
    }
    
    // MARK: - Custom Functions
    
    func addSubViews() {
        view.addSubview(noteTitle)
        view.addSubview(additionalNotes)
        view.addSubview(priorityLabel)
        view.addSubview(priorityPicker)
        view.addSubview(remainderLabel)
        view.addSubview(datePicker)
        view.addSubview(stackView)
    }
    
    func saveNote(notification: NSNotification) {
        
        if let note = noteTitle.text where note == "" {
            showAlert(withTitle: "Note title is empty", withMessage: "You need to specify at least note title")
        } else {
            
            setDate()
            
            if let note = noteTitle.text {
                self.note = note
            }
            
            if let additionalNotes = additionalNotes.text {
                self.extraNotes = additionalNotes
            }
            
            if let singleNote = singleNote {
                singleNote.setValue(note, forKey: "note")
                singleNote.setValue(extraNotes, forKey: "extraNotes")
                singleNote.setValue(PriorityPickerDatasource.priority, forKey: "priority")
                singleNote.setValue(dueDate, forKey: "dueDate")
                
                CoreDataFunctions.sharedInstance.updateTextNote(singleNote)
                LocalNotifications.sharedInstance.setLocalNotification(withDate: datePicker.date, withTitle: note, withBody: extraNotes)
                
                self.dismissViewControllerAnimated(true, completion: nil)


            } else {
                LocalNotifications.sharedInstance.setLocalNotification(withDate: datePicker.date, withTitle: note, withBody: extraNotes)
                CoreDataFunctions.sharedInstance.saveTextNote(note, extraNotes: extraNotes, priority: PriorityPickerDatasource.priority, dueDate: dueDate)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func deleteNote(notification: NSNotification) {
        if let singleNote = singleNote {
            CoreDataFunctions.sharedInstance.deleteObject(singleNote)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func setDate() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        dueDate = dateString
    }
    
    func setUI(with singleNote: NSManagedObject) {
                
        deleteNoteButton.userInteractionEnabled = true
        deleteNoteButton.alpha = 1
        
        noteTitle.text = singleNote.valueForKey("note") as? String
        additionalNotes.text = singleNote.valueForKey("extraNotes") as? String
        
        if let setPriority = singleNote.valueForKey("priority") as? String {
            switch setPriority {
            case "heigh":
                priorityPicker.selectRow(0, inComponent: 0, animated: false)
            case "medium":
                priorityPicker.selectRow(1, inComponent: 0, animated: false)
            case "low":
                priorityPicker.selectRow(2, inComponent: 0, animated: false)
            default:
                priorityPicker.selectRow(0, inComponent: 0, animated: false)
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


extension TextNoteDetailViewController: Notifier {

    func addObserversForChange() {
        
        TextNoteDetailViewController.addObserver(self, selector: .saveNote, notification: .saveNote)
        TextNoteDetailViewController.addObserver(self, selector: .deleteNote, notification: .deleteNote)
        
    }
}

    // MARK: - Constraints For Views

extension TextNoteDetailViewController {
    
    func setConstraints() {
        noteTitle.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 80, leftConstant: marginForViews, bottomConstant: 0, rightConstant: marginForViews, widthConstant: 0, heightConstant: view.frame.height / 20)
    
        additionalNotes.anchor(noteTitle.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: view.frame.height / 40, leftConstant: marginForViews, bottomConstant: 0, rightConstant: marginForViews, widthConstant: 0, heightConstant: view.frame.height / 10)
    
        priorityLabel.anchor(additionalNotes.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: view.frame.height / 20, leftConstant: marginForViews, bottomConstant: 0, rightConstant: marginForViews, widthConstant: 0, heightConstant: view.frame.height / 30)
    
        priorityPicker.anchor(priorityLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: view.frame.height / 20, leftConstant: marginForViews, bottomConstant: 0, rightConstant: marginForViews, widthConstant: 0, heightConstant: view.frame.height / 10)
    
        remainderLabel.anchor(priorityPicker.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: view.frame.height / 20, leftConstant: marginForViews, bottomConstant: 0, rightConstant: marginForViews, widthConstant: 0, heightConstant: view.frame.height / 30)
    
        datePicker.anchor(remainderLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: view.frame.height / 20, leftConstant: marginForViews, bottomConstant: 0, rightConstant: marginForViews, widthConstant: 0, heightConstant: 0)
    
        stackView.anchor(datePicker.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: view.frame.height / 20, leftConstant: marginForViews, bottomConstant: view.frame.height / 20, rightConstant: marginForViews, widthConstant: 0, heightConstant: view.frame.height / 15)
    }
}
            