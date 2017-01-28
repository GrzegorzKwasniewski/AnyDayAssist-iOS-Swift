//
//  PriorityPickerDatasource.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 28/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

class PriorityPickerDatasource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    static var priority = "heigh"
    
    var priorities = [String]()
    weak var pickerView: UIPickerView?
    
    init(priorities: [String], pickerView: UIPickerView) {
        super.init()
        self.pickerView = pickerView
        self.pickerView?.delegate = self
        self.priorities = priorities
    }

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
        PriorityPickerDatasource.priority = priorities[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = priorities[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }
}