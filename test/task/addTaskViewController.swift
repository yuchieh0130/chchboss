//
//  addTaskViewController.swift
//  test
//
//  Created by 王義甫 on 2020/4/8.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit


class addTaskViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnAddTask: UIButton!
    
    //db
    var taskName: String?
    var addTaskTime: String?
    
    var task : TaskModel?
    
    var showTimeFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
}
