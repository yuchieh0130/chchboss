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
    
    @IBOutlet var doneReturnBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var deleteAllBtn: UIButton!
    
    var task: TaskModel?
    var selectedTask: String = ""
    var showTask: [TaskModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneReturn(_ sender: UIButton){
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
        cell.doneTaskName?.text = showTask![indexPath.row].taskName
        cell.doneTaskMark.text = "DONE"
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
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            let isDeleted = DBManager.getInstance().deleteTask(id: id!)
        }
        deleteAction.backgroundColor = UIColor.red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    @IBAction func startEditing(_ sender: Any) {
    }
    @IBAction func deleteRows(_ sender: Any) {
    }
    @IBAction func deleteAllRows(_ sender: Any) {
    }
}
