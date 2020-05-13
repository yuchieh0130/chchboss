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
    
    
}
