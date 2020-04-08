//
//  taskViewController.swift
//  test
//
//  Created by 王義甫 on 2020/4/4.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class taskViewController: UIViewController{
    override func viewDidLoad() {
        title = "Task"
        
        //註冊.xib檔
//        self.tableView.register(UINib(nibName: "taskTableViewCell", bundle: nil), forCellReuseIdentifier: "taskTableViewCell")
    }
    
    @IBOutlet var addTaskButton: UIButton!
    
    @IBOutlet var tableView: UITableView!
    var taskId :Int32?
    var task: TaskModel?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? addTaskViewController{
            //editVC.task = task
        }
    }

    @IBAction func addTask(_ sender: Any) {
        task = nil
        performSegue(withIdentifier: "addTask", sender: sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
     }
     
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
     }
    
    var showTask = [TaskModel]()
    
//    extension ViewController: UITableViewDelegate,UITableViewDataSource {
//        //DataSource管理cell數量、section數量、多少列、及顯示內容
//        //Delegate處理TableView的外觀(列高、標題列高、第x列要內縮多少)及一些觸發事件
//
//        //必要、需要幾個cell
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return showTask.count
//        }
//
//        //必要、設定cell的樣式
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell:taskTableViewCell = tableView.dequeueReusableCell(withIdentifier: "taskTableViewCell", for: indexPath) as! taskTableViewCell
//            cell.taskName?.text = showTask[indexPath.row].taskName
//            if showTask[indexPath.row].startTime != nil && showEvent[indexPath.row].endTime != nil{
//                let time = showEvent[indexPath.row].startTime! + "-" + showEvent[indexPath.row].endTime!
//                cell.eventTime?.text = time
//            }else{
//                cell.eventTime?.text = nil
//            }
//            return cell
//        }
//
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            event = showEvent[indexPath.row]
//            performSegue(withIdentifier: "editEvent", sender: nil)
//        }
        
//    }
    
    
}
