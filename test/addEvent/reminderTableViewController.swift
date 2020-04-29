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
    var reminderName = String()
    var isselected = Bool()
}

class reminderTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    //    let datasource = ["none", "At time of event", "5 minutes before", "10 minutes before", "15 minutes before", "30 minutes before", "1 hour before", "2 hours before", "1 day before", "2 days before", "1 week before", "Custom"]
    var reminderData = [reminderStatus(reminderName: "none", isselected: false),
                       reminderStatus(reminderName: "At time of event", isselected: false),
                       reminderStatus(reminderName: "5 minutes before", isselected: false),
                       reminderStatus(reminderName: "10 minutes before", isselected: false),
                       reminderStatus(reminderName: "30 minutes before", isselected: false),
                       reminderStatus(reminderName: "1 hour before", isselected: false),
                       reminderStatus(reminderName: "1 day before", isselected: false),
                       reminderStatus(reminderName: "At certatian Location", isselected: false),
    ]
    var reminder_index = [Int]()
   // var reminder = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var indexp = [IndexPath]()
        if reminder_index.count == 1 && reminder_index[0] == 0{
            reminderData[0].isselected = true
            indexp.append(IndexPath(row: 0, section: 0))
        }
        if reminder_index.count != 1 || reminder_index[0] != 0{
            for i in 0...reminder_index.count-1{
                reminderData[reminder_index[i]].isselected = true
                indexp.append(IndexPath(row: reminder_index[i], section: 0))
            }
       tableView.reloadRows(at: indexp, with: .none)
        }
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addReminder(_ sender: UIButton){
        reminder_index = []
        for i in 0...reminderData.count-1{
            if reminderData[i].isselected{
                reminder_index.append(i)
            }
        }
        reminder_index = reminder_index.sorted()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reminderTableViewCell") as! reminderTableViewCell
        reminderTableViewCell.reminderTime.text = reminderData[indexPath.row].reminderName
        reminderTableViewCell.selectionStyle = .none
        reminderTableViewCell.imgView.tintColor = UIColor.gray
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
                let d = tableView.cellForRow(at: IndexPath(row: i, section: 0))  as! reminderTableViewCell
                if d.isSelected{
                    tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: false)
                    reminderData[i].isselected = false
                    d.imgView.image = UIImage(named: "reminder_deselect")
                }
            }
        }else{
            tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: false)
            reminderData[0].isselected = false
            let d = tableView.cellForRow(at: IndexPath(row: 0, section: 0))  as! reminderTableViewCell
            d.imgView.image = UIImage(named: "reminder_deselect")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as! reminderTableViewCell
        cell.imgView.image = UIImage(named: "reminder_deselect")
        reminderData[indexPath.row].isselected = false
        var ii = 0
        for i in 0...reminderData.count-1{
            if reminderData[i].isselected == true{ ii = ii+1 }
        }
        if ii == 0 {
           reminderData[0].isselected = true
           let d = tableView.cellForRow(at: IndexPath(row: 0, section: 0))  as! reminderTableViewCell
           d.imgView.image = UIImage(named: "reminder_select")
        }
    }
    
    
    
    
    
    
}

