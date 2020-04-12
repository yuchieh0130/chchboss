//
//  addTaskViewController.swift
//  test
//
//  Created by 王義甫 on 2020/4/8.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit


class addTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnAddTask: UIButton!
    @IBOutlet var btnEditTask: UIButton!
    @IBOutlet var btnDeleteTask: UIButton!
    
    let switchreminder = UISwitch()
    
    //db variables
    var taskName: String?
    var deadline: String! = ""
    var addTaskTime: String?
    var reminder: Bool! = false
    var id: Int32 = 0
    
    var task : TaskModel?
    
    var tag: String?
    var date = Date()
    var showDate: String = ""
    var taskLocation: String = ""
    
    var e = Date()+3600
    
    var showDateformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    var showTimeformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    var showDayformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    var showWeekdayformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd EEE"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTaskTime = "01:00"
        deadline = "\(showWeekdayformatter.string(from: date)) \(showTimeformatter.string(from: date + 3600)) "
        
        switchreminder.addTarget(self, action: #selector(self.reminderOpen(_ :)), for: .valueChanged)
        
        if task != nil{
                   loadData()
                   btnAddTask.isHidden = true
               }else{
                   btnEditTask.isHidden = true
                   btnDeleteTask.isHidden = true
               }
    }
    
    func loadData(){
        id = (task?.taskId)!
        taskName = task?.taskName
        addTaskTime = task?.addTaskTime
        deadline = task?.taskDeadline
        reminder = task?.taskReminder
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tag = nil
        switch segue.identifier{
        case"addTaskTime":
           if let VC = segue.destination as? DatePopupViewController{
            VC.tag = "addTaskTime"
            VC.addTaskTime = addTaskTime
                }
        case"deadline":
            if let VC = segue.destination as? DatePopupViewController{
                VC.tag = "deadline"
                VC.showDate = e
            }
            default:
                print("default")
            }
    }
    
    @IBAction func TimeSegueBack(segue: UIStoryboardSegue){
           let VC = segue.source as? DatePopupViewController
           date = VC!.datePicker.date
           tag = VC?.tag
        if tag == "addTaskTime"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
            }
        if tag == "deadline"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: .none)
        }
            
        }
    
    func handletime(){
        if tag == "addTaskTime"{
            addTaskTime = showTimeformatter.string(from: date)
        }else if tag == "deadline"{
            e = date
            deadline = "\(showWeekdayformatter.string(from: e)) \(showTimeformatter.string(from: e))"
        }
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addTaskButton(_ sender: UIButton) {
        self.view.endEditing(true)
        deadline = showDayformatter.string(for: e)
        if taskName == nil{
            let controller = UIAlertController(title: "Error", message: "Name should not be blank", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default){_ in
                    controller.dismiss(animated: true, completion: nil)}
                controller.addAction(okAction)
                self.present(controller, animated: true,completion: nil)
                print(self)
        }
        
        let modelInfo = TaskModel(taskId: id, taskName: taskName!, addTaskTime: addTaskTime!, taskDeadline: deadline, taskReminder: reminder, taskLocation: "default")
        let isAdded = DBManager.getInstance().addTask(modelInfo)
        self.dismiss(animated: true, completion: nil)
    }
    
    //還要寫edit 跟delete
    @IBAction func editTaskButton(_ sender: UIButton) {
        self.view.endEditing(true)
            deadline = showDayformatter.string(for: e)
            
            let modelInfo = TaskModel(taskId: id, taskName: taskName!, addTaskTime: addTaskTime!, taskDeadline: deadline, taskReminder: reminder, taskLocation: "default")
            let isEdited = DBManager.getInstance().editTask(modelInfo)
            self.dismiss(animated: true, completion: nil)
            
        }
    
    @IBAction func deleteTaskButton(_ sender: UIButton) {
        let modelInfo = TaskModel(taskId: id, taskName: taskName!, addTaskTime: addTaskTime, taskDeadline: deadline, taskReminder: reminder, taskLocation: "default")
        let isDeleted = DBManager.getInstance().deleteTask(id: modelInfo.taskId!)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //reminder Switch
    @objc func reminderOpen(_ sender: UISwitch){
        if sender.isOn == true{
            reminder = true
        }else{
            reminder = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath {
        case [0,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskNameCell", for: indexPath) as! taskNameCell
            cell.txtTaskName.text = taskName
            cell.selectionStyle = .none
            return cell
        case [1,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addTaskTimeCell", for: indexPath) as! addTaskTimeCell
            cell.txtAddTaskTime.text = addTaskTime
            cell.selectionStyle = .none
            return cell
        case [2,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "deadlineCell", for: indexPath) as! deadlineCell
            cell.txtDeadline.text = deadline
            return cell
        case [3,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskLocationCell", for: indexPath) as! taskLocationCell
            cell.txtTaskLocation.text = taskLocation
            cell.selectionStyle = .none
            return cell
        case [4,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)
                cell.accessoryView = switchreminder
                switchreminder.setOn(reminder, animated: .init())
                cell.selectionStyle = .none
                return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath{
        case[1,0]:
            performSegue(withIdentifier: "addTaskTime", sender: self)
        case[2,0]:
            performSegue(withIdentifier: "deadline", sender: self)
        default:
            print("")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        taskName = textField.text!
    }
    
    
}
