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
    var taskName: String?
    var taskDeadline: String! = ""
    var taskTime: String?
    var reminder: Bool! = false
    var id: Int32 = 0
    
    @IBOutlet var addTaskButton: UIButton!
    
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
    
//    @IBAction func EventSegueBack(segue: UIStoryboardSegue){
//        tableView.reloadData()
//    }

    @IBAction func addTask(_ sender: Any) {
        task = nil
        performSegue(withIdentifier: "addTask", sender: sender)
    }
    
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
        let doItNowAction = UIContextualAction(style: .normal, title: "Do It Now") { (action, view, completionHandler) in
        print("Do It Now")
        completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [doItNowAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    //往左滑
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let id =  showTask?[indexPath.row].taskId
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
        deleteAction.backgroundColor = UIColor.red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, doneAction])
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
        }
        if task.taskDeadline != nil{
            let d = showDateformatter.date(from: task.taskDeadline!)
            let interval = d!.timeIntervalSinceNow
            let day = Int(interval/86400)
            let hour = Int((Int(interval)-Int(interval/86400)*86400)/3600)
            cell.taskDeadline.text = " \(day) day \n\(hour) hr"
        }
        return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        task = showTask![indexPath.row]
        performSegue(withIdentifier: "editTask", sender: nil)
        }
    
    
    
    
}
