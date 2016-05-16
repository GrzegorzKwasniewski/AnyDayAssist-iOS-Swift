//
//  FirstViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/05/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

var userNotes:[String] = [String]()

class FirstViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return userNotes.count
        
    }
    
    
    
    // sprawdz sobie pozniej do czego to sluzy
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // some code
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

