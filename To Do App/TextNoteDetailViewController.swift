//
//  TextNoteDetailViewController.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 08/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class TextNoteDetailViewController: UIViewController, UIMaker {
    
    @IBOutlet weak var priorityOfTask: UIPickerView!
    
    var priorities = ["heigh", "medium", "low"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
        priorityOfTask.delegate = self
        priorityOfTask.dataSource = self
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
        //
    }
    
}
