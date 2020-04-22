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
    
    let switchtasktime = UISwitch()
    let switchreminder = UISwitch()
    let switchdeadline = UISwitch()
    let switchcalendar = UISwitch()
    
    //db variables
    var taskName: String?
    var deadline: String?
    var taskTime: String?
    var reminder: Bool! = false
    var addToCal : Bool! = false
    var isPinned: Bool! = false
    var id: Int32 = 0
    
    var task : TaskModel?
    var modelInfo : TaskModel?
    
    var d: Bool = false //check deadline is nil or not
    var t: Bool = false //check tasktime is nil or not
    var tag: String?
    var date = Date()+86400
    var showDate: String = ""
    var taskLocation: String = ""
    
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
        formatter.dateFormat = "MM-dd EEE HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewData = [cellConfig(opened: false, title: "taskTime"),
                         cellConfig(opened: false, title: "daealine")]
        switchdeadline.addTarget(self, action: #selector(self.deadlineOpen(_ :)), for: .valueChanged)
        
        switchtasktime.addTarget(self, action: #selector(self.taskTimeOpen(_ :)), for: .valueChanged)
        switchdeadline.addTarget(self, action: #selector(self.deadlineOpen(_ :)), for: .valueChanged)
        switchreminder.addTarget(self, action: #selector(self.reminderOpen(_ :)), for: .valueChanged)
        switchcalendar.addTarget(self, action: #selector(self.calendarOpen(_ :)), for: .valueChanged)
        
        if task != nil{
                   loadData()
                   btnAddTask.isHidden = true
               }else{
                   btnEditTask.isHidden = true
                   btnDeleteTask.isHidden = true
               }
        
        if taskTime == nil{ taskTime = "01:00"}
        if deadline == nil{
            let i = showDayformatter.string(from: Date())
            let i1 = showDateformatter.date(from:"\(i) 23:59")
            deadline = showDateformatter.string(from: i1!)
        }
    }
    
    func loadData(){
        id = (task?.taskId)!
        taskName = task?.taskName
        taskTime = task?.taskTime
        deadline = task?.taskDeadline
        if taskTime != nil{
            t = true
            tableViewData[0].opened = true
        }
        if deadline != nil{
            d = true
            tableViewData[1].opened = true
        }
        addToCal = task?.addToCal
        reminder = task?.reminder
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tag = nil
        switch segue.identifier{
        case"addTaskTime":
           if let VC = segue.destination as? DatePopupViewController{
            VC.tag = "addTaskTime"
            VC.showDate = showTimeformatter.date(from: taskTime!)!
            //VC.addTaskTime = taskTime
                }
        case"deadline":
            if let VC = segue.destination as? DatePopupViewController{
                VC.tag = "deadline"
                VC.showDate = showDateformatter.date(from: deadline!)!
            }
            default:
                print("")
            }
    }
    
    @IBAction func TimeSegueBack(segue: UIStoryboardSegue){
           let VC = segue.source as? DatePopupViewController
           date = VC!.datePicker.date
           tag = VC?.tag
        if tag == "addTaskTime"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 1, section: 1)], with: .none)
            }
        if tag == "deadline"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 1, section: 2)], with: .none)
        }
            
        }
    
    func handletime(){
        if tag == "addTaskTime"{
            taskTime = showTimeformatter.string(from: date)
        }else if tag == "deadline"{
            deadline = showDateformatter.string(from: date)
        }
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addTaskButton(_ sender: UIButton) {
        self.view.endEditing(true)
        if d == false{ deadline = nil }
        if t == false{ taskTime = nil }
        if taskName == nil || taskName == ""{
            alertMessage()
        }else{
            modelInfo = TaskModel(taskId: id, taskName: taskName!, taskTime: taskTime, taskDeadline: deadline, reminder: reminder, taskLocation: "default",addToCal: addToCal,isPinned: isPinned)
            let isAdded = DBManager.getInstance().addTask(modelInfo!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func editTaskButton(_ sender: UIButton) {
        self.view.endEditing(true)
        if d == false{ deadline = nil }
        if t == false{ taskTime = nil }
        if taskName == nil || taskName == ""{
            alertMessage()
        }else{
            modelInfo = TaskModel(taskId: id, taskName: taskName!, taskTime: taskTime, taskDeadline: deadline, reminder: reminder, taskLocation: "default",addToCal: addToCal,isPinned: isPinned)
            let isEdited = DBManager.getInstance().editTask(modelInfo!)
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
        let modelInfo = TaskModel(taskId: id, taskName: taskName!, taskTime: taskTime, taskDeadline: deadline, reminder: reminder, taskLocation: "default",addToCal: addToCal,isPinned: isPinned)
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[0].opened == true && section == 1 || tableViewData[1].opened == true && section == 2{
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskTimeCell", for: indexPath) as! taskTimeCell
            cell.accessoryView = switchtasktime
            switchtasktime.setOn(t, animated: .init())
            cell.selectionStyle = .none
            return cell
        case [1,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addTaskTimeCell", for: indexPath) as! addTaskTimeCell
            cell.txtAddTaskTime.text = taskTime
            cell.selectionStyle = .none
            return cell
        case [2,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "deadlineCell", for: indexPath) as! deadlineCell
            cell.accessoryView = switchdeadline
            switchdeadline.setOn(d, animated: .init())
            return cell
        case [2,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "deadlineTimeCell", for: indexPath) as! deadlineTimeCell
            let i = showDateformatter.date(from: deadline!)
            cell.txtDeadline.text = showWeekdayformatter.string(from: i!)
            return cell
        case [3,0]:
                   let cell = tableView.dequeueReusableCell(withIdentifier: "addToCalendarCell", for: indexPath)
                   cell.accessoryView = switchcalendar
                   switchcalendar.setOn(addToCal, animated: .init())
                   cell.selectionStyle = .none
                   return cell
        case [4,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! reminderCell
            cell.accessoryView = switchreminder
            switchreminder.setOn(reminder, animated: .init())
            cell.selectionStyle = .none
            return cell
        case [5,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskLocationCell", for: indexPath) as! taskLocationCell
            cell.txtTaskLocation.text = taskLocation
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)
                return cell
        }
    }
    
    @objc func taskTimeOpen(_ sender: UISwitch){
        var indexA = [IndexPath]()
        indexA.append([1,1])
        if sender.isOn == true{
            t = true
            tableViewData[0].opened = true
            tableView.insertRows(at: indexA, with: .fade)
        }else{
            t = false
            tableViewData[0].opened = false
            tableView.deleteRows(at: indexA, with: .fade)
        }
    }
    
    @objc func deadlineOpen(_ sender: UISwitch){
        var indexA = [IndexPath]()
        indexA.append([2,1])
        if sender.isOn == true{
            d = true
            tableViewData[1].opened = true
            tableView.insertRows(at: indexA, with: .fade)
        }else{
            d = false
            tableViewData[1].opened = false
            tableView.deleteRows(at: indexA, with: .fade)
            if addToCal == true{
                addToCal = false
                switchcalendar.setOn(addToCal, animated: .init())
            }
            if reminder == true{
                reminder = false
                switchreminder.setOn(reminder, animated: .init())
            }
        }
    }
    
    @objc func calendarOpen(_ sender: UISwitch){
        var indexA = [IndexPath]()
        indexA.append([2,1])
        if sender.isOn == true{
            addToCal = true
            if d == false{
                d = true
                switchdeadline.isOn = true
                tableViewData[1].opened = true
                tableView.insertRows(at: indexA, with: .fade)
            }
        }else{
            addToCal = false
        }
    }
    
    @objc func reminderOpen(_ sender: UISwitch){
        var indexA = [IndexPath]()
        indexA.append([2,1])
          if sender.isOn == true{
              reminder = true
            if d == false{
                d = true
                switchdeadline.isOn = true
                tableViewData[1].opened = true
                tableView.insertRows(at: indexA, with: .fade)
            }
          }else{
              reminder = false
          }
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath{
        case[1,1]:
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
