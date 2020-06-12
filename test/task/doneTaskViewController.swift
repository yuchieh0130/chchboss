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
    
    //@IBOutlet var doneReturnBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    //@IBOutlet var deleteAllBtn: UIButton!
    @IBOutlet var navigationBar: UINavigationItem!
    
    var task: TaskModel?
    var selectedTask: String = ""
    var showTask: [TaskModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelectionDuringEditing = true

        let doneBack = UIBarButtonItem(title: "< Return", style: .plain, target: self, action: #selector(doneReturn))
        navigationItem.leftBarButtonItems = [doneBack]
        
        let deleteAll = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteAllAlert))
        navigationItem.rightBarButtonItems = [editButtonItem]
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
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
    
    @objc func deleteAllAlert() {
        let controller = UIAlertController(title: "Sure to delete selected task(s) ?", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            print("OK")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
//    func deleteAllDoneTask() {
//        var indexPath: IndexPath{
//            let id =  self.showTask?[indexPath.row].taskId
//            let task = self.showTask?[indexPath.row]
//            self.showTask!.removeAll()
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
//            let isAllDeleted = DBManager.getInstance().deleteAllDoneTask(id: id!)
//            self.tableView.reloadData()
//            return IndexPath.init()
//        }
//
//    }
    
}
