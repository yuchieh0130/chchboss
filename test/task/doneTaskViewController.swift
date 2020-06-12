//
//  doneTaskViewController.swift
//  test
//
//  Created by 王義甫 on 2020/5/13.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class doneTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationItem!
    
    var task: TaskModel?
    var selectedTask: String = ""
    var showTask: [TaskModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelectionDuringEditing = true

        let doneBack = UIBarButtonItem(title: "< Return", style: .plain, target: self, action: #selector(doneReturn))
        navigationItem.leftBarButtonItems = [doneBack]
        
        editButtonItem.title = "Select"
        navigationItem.rightBarButtonItems = [editButtonItem]
    }
    
    @objc func doneReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DBManager.getInstance().getAllDoneTask() != nil{
            showTask = DBManager.getInstance().getAllDoneTask()
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
        let cell:doneTaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: "doneTaskTableViewCell", for: indexPath) as! doneTaskTableViewCell
        let task = showTask![indexPath.row]
        var taskDeadline = showTask?[indexPath.row].taskDeadline
        cell.doneTaskName?.text = showTask![indexPath.row].taskName
        
        if taskDeadline == nil{
            cell.doneTaskMark.text = "No Deadline"
        }else{
            cell.doneTaskMark.text = showTask![indexPath.row].taskDeadline
        }
        if showTask?[indexPath.row].addToCal == false{
            cell.doneTaskCalendar.isHidden = true
        }else{
            cell.doneTaskCalendar.isHidden = false
        }
        
        return cell
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let id =  showTask?[indexPath.row].taskId
        let task = showTask?[indexPath.row]
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            print("Delete")
            completionHandler(true)
            self.showTask!.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            let isDeleted = DBManager.getInstance().deleteTask(id: id!)
        }
        deleteAction.backgroundColor = UIColor.red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
            
        if tableView.isEditing == true{
            editButtonItem.title = "Delete"
        }else if tableView.isEditing == false{
            editButtonItem.title = "Select"
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let cell:doneTaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: "doneTaskTableViewCell", for: indexPath) as! doneTaskTableViewCell
//        let controller = UIAlertController(title: "Are you sure to delete selected task(s) ?", message: "", preferredStyle: .alert)
//        let id =  showTask?[indexPath.row].taskId
//        let task = showTask?[indexPath.row]
//        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
//            self.showTask!.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .left)
//                let isDeleted = DBManager.getInstance().deleteDoneTask(id: id!)
//            print("OK")
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        controller.addAction(okAction)
//        controller.addAction(cancelAction)
//        present(controller, animated: true, completion: nil)
//    }
    
}
