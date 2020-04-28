//
//  taskViewController.swift
//  test
//
//  Created by 王義甫 on 2020/4/4.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class taskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //db variables
//    var taskName: String?
//    var taskDeadline: String! = ""
//    var taskTime: String?
//    var reminder: Bool! = false
//    var id: Int32 = 0
    
    @IBOutlet var addTaskButton: UIButton!
    //@IBOutlet var editTaskButton: UIButton!

    
    @IBOutlet var tableView: UITableView!
    //var taskId :Int32?
    var task: TaskModel?
    
    var selectedTask: String = ""
    var showTask: [TaskModel]?
    
    var showDateformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    var formatter1: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    var formatter2: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    var formatter3: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addTask":
            if let addVC = segue.destination as? addTaskViewController {
                addVC.task = task
            }
        case "editTask":
            if let editVC = segue.destination as? addTaskViewController{
                editVC.task = task
            }
        default:
            print("")
        }
        
    }
    
    @IBAction func addTask(_ sender: Any) {
        task = nil
        performSegue(withIdentifier: "addTask", sender: sender)
    }
    
//    @IBAction func edit(_ sender: Any) {
//        self.tableView.isEditing = !tableView.isEditing
//        if tableView.isEditing{
//            editTaskButton.setTitle("Done", for: .normal)
//        }else{
//            editTaskButton.setTitle("Edit", for: .normal)
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showTask?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //往右滑
     @available(iOS 11.0, *)
        public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let id = showTask?[indexPath.row].taskId
        let task = showTask?[indexPath.row]
        let pinAction = UIContextualAction(style: .normal, title: "Pin") { (action, view, completionHandler) in
            print("Pin")
            completionHandler(true)
            self.tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            let isPinned = DBManager.getInstance().pinTask(id: id!)
            self.showTask = DBManager.getInstance().getAllTask()
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
            }
        let unPinAction = UIContextualAction(style: .normal, title: "Unpin") { (action, view, completionHandler) in
            print("Unpin")
            completionHandler(true)
            let unPinned = DBManager.getInstance().unPinTask(id: id!)
            self.showTask = DBManager.getInstance().getAllTask()
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        if showTask?[indexPath.row].isPinned == false{
            let configuration = UISwipeActionsConfiguration(actions: [pinAction])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        }else{
            let configuration = UISwipeActionsConfiguration(actions: [unPinAction])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        }
        }

        //往左滑
        @available(iOS 11.0, *)
        public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let id =  showTask?[indexPath.row].taskId
            let task = showTask?[indexPath.row]
            let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
                print("Delete")
                completionHandler(true)
                self.showTask!.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                let isDeleted = DBManager.getInstance().deleteTask(id: id!)
                self.dismiss(animated: true, completion: nil)
            }
            let doneAction = UIContextualAction(style: .normal, title: "Done") { (action, view, completionHandler) in
            print("Done")
            completionHandler(true)
            }
            let doItNowAction = UIContextualAction(style: .normal, title: "Do It Now") { (action, view, completionHandler) in
            print("Do It Now")
            completionHandler(true)
            }
            deleteAction.backgroundColor = UIColor.red
            doneAction.backgroundColor = #colorLiteral(red: 0.2979176044, green: 0.6127660275, blue: 0.9929869771, alpha: 1)  //color literal
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, doneAction, doItNowAction])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DBManager.getInstance().getAllTask() != nil{
            showTask = DBManager.getInstance().getAllTask()
        }else{
            showTask = [TaskModel]()
        }
        tableView.reloadData()
     }
     
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
     }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showTask!.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:taskTableViewCell = tableView.dequeueReusableCell(withIdentifier: "taskTableViewCell", for: indexPath) as! taskTableViewCell
        let task = showTask![indexPath.row]
        cell.taskName?.text = showTask![indexPath.row].taskName
        if task.taskTime != nil{
        let t = formatter1.date(from: showTask![indexPath.row].taskTime!)
        cell.addTaskTime.text = " \(formatter2.string(from: t!)) hr \(formatter3.string(from: t!)) min "
        }else{
            cell.addTaskTime.text = nil
        }
        if task.taskDeadline != nil{
            let d = showDateformatter.date(from: task.taskDeadline!)
            let interval = d!.timeIntervalSinceNow
            let day = Int(interval/86400)
            let hour = Int((Int(interval)-Int(interval/86400)*86400)/3600)
            let min = Int((Int(interval)-Int(interval/86400)*86400-((Int(interval)-Int(interval/86400)*86400)/3600)*3600)/60)
            if interval<0{
                cell.taskDeadline.text = "over\ndue"
                cell.taskDeadline.textColor = UIColor.red
            }else if interval<3600{
                cell.taskDeadline.text = "\(min) mins"
            }else if interval<86400{
                cell.taskDeadline.text = "\(hour) hrs \n\(min) mins"
            }else if interval>86400{
                cell.taskDeadline.text = " \(day) days \n\(hour) hrs"
            }else{
                cell.taskDeadline.text = ""
            }
        }
        if showTask?[indexPath.row].isPinned == false{
            cell.taskPin.isHidden = true
        }else{
            cell.taskPin.isHidden = false
        }
        
        if showTask?[indexPath.row].addToCal == false{
            cell.taskCalendar.isHidden = true
        }else{
            cell.taskCalendar.isHidden = false
        }
        
        return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        task = showTask![indexPath.row]
        performSegue(withIdentifier: "editTask", sender: nil)
        }
    
    //
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let tomove = (self.showTask?.remove(at: sourceIndexPath.row))!
//        showTask?.insert(tomove, at: destinationIndexPath.row)
//    }
    
}
