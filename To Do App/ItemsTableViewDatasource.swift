//
//  ItemsTableViewDatasource.swift
//  AnyDay
//
//  Created by Grzegorz Kwaśniewski on 18/01/17.
//  Copyright © 2017 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

protocol ItemsTableViewDatasource: UITableViewDataSource {
    associatedtype T
    var items:[T] {get}
    weak var tableView: UITableView? {get}
    weak var delegate: UITableViewDelegate? {get}
    
    init(items: [T], tableView: UITableView, delegate: UITableViewDelegate)
    
    func setupTableView()
}

extension ItemsTableViewDatasource {
    func setupTableView() {
        self.tableView?.dataSource = self
        self.tableView?.delegate = self.delegate
        self.tableView?.reloadData()
    }
}

