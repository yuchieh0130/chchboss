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
    
    
    @IBOutlet var addTaskButton: UIButton!
    
    @IBOutlet var tableView: UITableView!
    var taskId :Int32?
    var task: TaskModel?
    
    var selectedTask: String = ""
    var showTask: [TaskModel]?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DBManager.getInstance().getTask() != nil{
        showTask = DBManager.getInstance().getTask()
        }else{
        showTask = [TaskModel]()
        }
        print("aaaa")
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
        cell.taskName?.text = showTask![indexPath.row].taskName
        cell.addTaskTime.text = showTask![indexPath.row].addTaskTime
        
        return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        task = showTask![indexPath.row]
        performSegue(withIdentifier: "editTask", sender: nil)
        }
    
    
}
