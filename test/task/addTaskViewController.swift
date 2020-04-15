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

    var tableViewData = [cellConfig]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnAddTask: UIButton!
    @IBOutlet var btnEditTask: UIButton!
    @IBOutlet var btnDeleteTask: UIButton!
    
    let switchreminder = UISwitch()
    let switchdeadline = UISwitch()
    
    //db variables
    var taskName: String?
    var deadline: String! = ""
    var addTaskTime: String?
    var reminder: Bool! = false
    var id: Int32 = 0
    
    var task : TaskModel?
    
    var d: Bool = false //check deadline true of false
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
        formatter.dateFormat = "MM-dd EEE"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewData = [cellConfig(opened: false, title: "daealine")]
        switchdeadline.addTarget(self, action: #selector(self.deadlineOpen(_ :)), for: .valueChanged)
        
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
        if deadline != nil{ deadline = task?.taskDeadline }
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
        if d == true{
        deadline = showDateformatter.string(for: e)
        }else{
        deadline = nil
        }
        if taskName == nil || taskName == ""{
            alertMessage()
        }else{
            let modelInfo = TaskModel(taskId: id, taskName: taskName!, addTaskTime: addTaskTime!, taskDeadline: deadline, taskReminder: reminder, taskLocation: "default")
            let isAdded = DBManager.getInstance().addTask(modelInfo)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //還要寫edit 跟delete
    @IBAction func editTaskButton(_ sender: UIButton) {
        self.view.endEditing(true)
        if taskName == nil || taskName == ""{
            alertMessage()
        }else{
            deadline = showDayformatter.string(for: e)
            
            let modelInfo = TaskModel(taskId: id, taskName: taskName!, addTaskTime: addTaskTime!, taskDeadline: deadline, taskReminder: reminder, taskLocation: "default")
            let isEdited = DBManager.getInstance().editTask(modelInfo)
            self.dismiss(animated: true, completion: nil)
        }
            
        }
    
    @IBAction func deleteTaskButton(_ sender: UIButton) {
        let controller = UIAlertController(title: "WARNING", message: "Are you sure to delete the event", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){_ in
            controller.dismiss(animated: true, completion: nil); self.dismiss(animated: true, completion: nil); self.delete()}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){_ in controller.dismiss(animated: true, completion: nil)}
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        
        self.present(controller, animated: true,completion: .none)
        
        
    }
    
    func delete(){
        let modelInfo = TaskModel(taskId: id, taskName: taskName!, addTaskTime: addTaskTime, taskDeadline: deadline, taskReminder: reminder, taskLocation: "default")
        let isDeleted = DBManager.getInstance().deleteTask(id: modelInfo.taskId!)
    }
    
    func alertMessage(){
            if taskName == nil || taskName == ""{
                let controller = UIAlertController(title: "Error", message: "Enter a name", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default){_ in
                    controller.dismiss(animated: true, completion: nil)}
                controller.addAction(okAction)
                self.present(controller, animated: true,completion: .none)
            }
        
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
        if tableViewData[0].opened == true && section == 2{
            return 2
        }else{
            return 1
        }
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
            cell.accessoryView = switchdeadline
            switchdeadline.setOn(d, animated: .init())
            return cell
        case [2,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "deadlineTimeCell", for: indexPath) as! deadlineTimeCell
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
    
    @objc func deadlineOpen(_ sender: UISwitch){
        var indexA = [IndexPath]()
        indexA.append([2,1])
        if sender.isOn == true{
            d = true
            tableViewData[0].opened = true
            tableView.insertRows(at: indexA, with: .fade)
        }else{
            d = false
            tableViewData[0].opened = false
            tableView.deleteRows(at: indexA, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath{
        case[1,0]:
            performSegue(withIdentifier: "addTaskTime", sender: self)
        case[2,1]:
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
