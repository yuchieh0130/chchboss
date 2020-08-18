//
//  TableView Controller.swift
//  test
//
//  Created by 王義甫 on 2020/3/25.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar
import UserNotifications

struct reminderStatus{
    var rname = String()
    var isselected = Bool()
}

class reminderTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var reminder = [Int]()
    var reminderData = [reminderStatus]()
    var allDay = false
    
    //  let datasource = ["none", "At time of event", "5 minutes before", "10 minutes before", "15 minutes before", "30 minutes before", "1 hour before", "2 hours before", "1 day before", "2 days before", "1 week before", "Custom"]
    var reminderData_notallDay = [reminderStatus(rname: "none", isselected: false),
                       reminderStatus(rname: "At time of event", isselected: false),
                       reminderStatus(rname: "5 minutes before", isselected: false),
                       reminderStatus(rname: "10 minutes before", isselected: false),
                       reminderStatus(rname: "30 minutes before", isselected: false),
                       reminderStatus(rname: "1 hour before", isselected: false),
                       reminderStatus(rname: "1 day before", isselected: false),]
    
    var reminderData_allDay = [reminderStatus(rname: "none", isselected: false),
                               reminderStatus(rname: "on that day (default 07:00)", isselected: false),
                               reminderStatus(rname: "one day before (default 21:00)", isselected: false),
                               reminderStatus(rname: "two days before (default 21:00)", isselected: false),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let btnAdd = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(addReminder(_:)))
        navigationItem.rightBarButtonItems = [btnAdd]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if allDay == true{
            reminderData = reminderData_allDay
        }else{
           reminderData = reminderData_notallDay
        }
        for i in 0...reminder.count-1{
            reminderData[reminder[i]].isselected = true
            tableView.selectRow(at: IndexPath(row: reminder[i], section: 0), animated: false, scrollPosition: .none)
        }
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    @objc func addReminder(_ sender: UIButton){
        reminder = []
        for i in 0...reminderData.count-1{
            if reminderData[i].isselected{
                reminder.append(i)
            }
        }
        reminder = reminder.sorted()
        performSegue(withIdentifier: "reminderSegueBack", sender: self)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allDay == true{
             return reminderData_allDay.count
        }else{
             return reminderData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reminderTableViewCell") as! reminderTableViewCell
            reminderTableViewCell.reminderTime.text = reminderData[indexPath.row].rname
            reminderTableViewCell.selectionStyle = .none
            //reminderTableViewCell.imgView.tintColor = UIColor.blue
            if reminderData[indexPath.row].isselected == true{
                reminderTableViewCell.imgView.image = UIImage(named: "reminder_select")
            }else{
                reminderTableViewCell.imgView.image = UIImage(named: "reminder_deselect")
            }
        return reminderTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as! reminderTableViewCell
        reminderData[indexPath.row].isselected = true
        cell.imgView.image = UIImage(named: "reminder_select")
        if indexPath.row == 0 {
            for i in 1...reminderData.count-1{
                if reminderData[indexPath.row].isselected == true{
                    tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: false)
                    reminderData[i].isselected = false
                    let c = tableView.cellForRow(at: IndexPath(row: i, section: 0))  as! reminderTableViewCell
                    c.imgView.image = UIImage(named: "reminder_deselect")
                }
            }
        }else{
            tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: false)
            reminderData[0].isselected = false
            let c = tableView.cellForRow(at: IndexPath(row: 0, section: 0))  as! reminderTableViewCell
            c.imgView.image = UIImage(named: "reminder_deselect")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as! reminderTableViewCell
        cell.imgView.image = UIImage(named: "reminder_deselect")
        reminderData[indexPath.row].isselected = false
        //var ii = 0
        if reminderData.filter({$0.isselected}).count == 0{
            reminderData[0].isselected = true
            let c = tableView.cellForRow(at: IndexPath(row: 0, section: 0))  as! reminderTableViewCell
            c.imgView.image = UIImage(named: "reminder_select")
        }
    }
    
    
    
    
    
    
}

