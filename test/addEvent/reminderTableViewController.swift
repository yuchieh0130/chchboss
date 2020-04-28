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

class reminderTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    var reminder_str = [Int]()
    
//    let datasource = ["none", "At time of event", "5 minutes before", "10 minutes before", "15 minutes before", "30 minutes before", "1 hour before", "2 hours before", "1 day before", "2 days before", "1 week before", "Custom"]
    let datasource = ["none", "At time of event", "5 minutes before", "10 minutes before", "30 minutes before", "1 hour before", "1 day before", "At certatian Location"]
    var reminder = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        
        //應該要預設選none!!!
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addReminder(_ sender: UIButton){
        for i in 0...tableView.indexPathsForSelectedRows!.count-1{
            let r = tableView.indexPathsForSelectedRows![i].row
            reminder_str.append(r)
        }
        reminder_str.sort(by: >)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reminderTableViewCell") as! reminderTableViewCell
        reminderTableViewCell.reminderTime.text = datasource[indexPath.row]
        reminderTableViewCell.selectionStyle = .none
        reminderTableViewCell.imgView.tintColor = UIColor.gray
//讀db看點開時哪些要選
//        if  reminderTableViewCell.isSelected{
//            reminderTableViewCell.imgView.image = UIImage(named: "reminder_select")
//        }else{
//            reminderTableViewCell.imgView.image = UIImage(named: "reminder_deselect")
//        }
        return reminderTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as! reminderTableViewCell
        cell.imgView.image = UIImage(named: "reminder_select")
        if indexPath.row == 0 {
            for i in 1...11{
                tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: false)
                let d = tableView.cellForRow(at: IndexPath(row: i, section: 0))  as! reminderTableViewCell
                d.imgView.image = UIImage(named: "reminder_deselect")
            }
        }else{
            tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: false)
            let d = tableView.cellForRow(at: IndexPath(row: 0, section: 0))  as! reminderTableViewCell
            d.imgView.image = UIImage(named: "reminder_deselect")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as! reminderTableViewCell
        cell.imgView.image = UIImage(named: "reminder_deselect")
    }
    
    
    
    
    
    
}

