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
    
    let switchtasktime = UISwitch()
    //let switchreminder = UISwitch()
    let switchdeadline = UISwitch()
    let switchcalendar = UISwitch()
    
    var reminderData = [reminderConfig]()
    var oldReminder_index: [String] = [""]
    var reminder_index: [Int] = [0]
    
    //db variables
    var taskName: String = ""
    var deadline: String = ""
    var taskTime: String = ""
    var reminder =  ""
    var addToCal : Bool! = false
    var isPinned: Bool! = false
    var isDone: Bool! = false
    var id: Int32 = 0
    var taskLocation: Int32 = 0
    
    var task: TaskModel?
    //var modelInfo : TaskModel?
    var savePlace: PlaceModel?
    
    var d: Bool = false //check deadline is nil or not
    var t: Bool = false //check tasktime is nil or not
//    var p: Bool = false
    var tag: String?
    var date = Date()+86400
    var showDate: String = ""
    //var taskLocation: String = ""
    
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
        reminderData = [reminderConfig( rname: "none", fireTime: 0),
        reminderConfig( rname: "At time of event", fireTime: 0),
        reminderConfig( rname: "5 minutes before", fireTime: 300),
        reminderConfig( rname: "10 minutes before", fireTime: 600),
        reminderConfig( rname: "30 minutes before", fireTime: 1800),
        reminderConfig( rname: "1 hour before", fireTime: 3600),
        reminderConfig( rname: "1 day before", fireTime: 86400),]
        
//        switchdeadline.addTarget(self, action: #selector(self.deadlineOpen(_ :)), for: .valueChanged)
        switchtasktime.addTarget(self, action: #selector(self.taskTimeOpen(_ :)), for: .valueChanged)
        switchtasktime.onTintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        switchdeadline.addTarget(self, action: #selector(self.deadlineOpen(_ :)), for: .valueChanged)
        switchdeadline.onTintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
//        switchreminder.addTarget(self, action: #selector(self.reminderOpen(_ :)), for: .valueChanged)
        switchcalendar.addTarget(self, action: #selector(self.calendarOpen(_ :)), for: .valueChanged)
        switchcalendar.onTintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        
        let btnAddTask = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addTaskButton(_:)))
        let btnEditTask = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(editTaskButton(_:)))
        let btnDeleteTask = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteTaskButton(_:)))
        let btnCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItems = [btnCancel]
        
        if task != nil{
            loadData()
            navigationItem.rightBarButtonItems = [btnEditTask, btnDeleteTask]
        }else{
            navigationItem.rightBarButtonItems = [btnAddTask]
        }
//        if taskTime == nil{ taskTime = "01:00"}
//        if deadline == nil{
//            let i = showDayformatter.string(from: Date())
//            let i1 = showDateformatter.date(from:"\(i) 23:59")
//            deadline = showDateformatter.string(from: i1!)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.5)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)]
        
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
//        self.navigationController?.navigationBar.tintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)]
//    }
    
    func loadData(){
        id = task!.taskId
        taskName = task!.taskName
        taskTime = task!.taskTime
        deadline = task!.taskDeadline
        isPinned = task?.isPinned
        if taskTime != ""{
            t = true
            tableViewData[0].opened = true
        }
        if deadline != ""{
            d = true
            tableViewData[1].opened = true
        }
//        if isPinned != nil{
//            //p = true
//        }
        addToCal = task!.addToCal
        reminder = task!.reminder
        reminder_index = task!.reminder.components(separatedBy: ",").map{ NSString(string: $0).integerValue }
        oldReminder_index = task!.reminder.components(separatedBy: ",") as [String]
        oldReminder_index = oldReminder_index.map{ (index) -> String in
            return "task\(id)_\(index)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tag = nil
        switch segue.identifier{
        case"addTaskTime":
            if let VC = segue.destination as? DatePopupViewController{
            VC.tag = "addTaskTime"
            VC.showDate = showTimeformatter.date(from: taskTime)!
            //VC.addTaskTime = taskTime
                }
        case"deadline":
            if let VC = segue.destination as? DatePopupViewController{
                VC.tag = "deadline"
                VC.showDate = showDateformatter.date(from: deadline)!
            }
        case"taskReminder":
            if let VC = segue.destination as? reminderTableViewController{
                VC.reminder = reminder_index
        }
            default:
                print("")
            }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "taskUnwindSegue"{
            if taskName == "" {
                alertMessage()
                return false
            }
        }
        return true
    }
    
    @IBAction func TimeSegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "timeSegueBack"{
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
    }
    
    @IBAction func reminderSegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "reminderSegueBack"{
            let VC = segue.source as! reminderTableViewController
               reminder_index = VC.reminder
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 4)], with: .none)
        }
    }
    
    func handletime(){
        if tag == "addTaskTime"{
            taskTime = showTimeformatter.string(from: date)
        }else if tag == "deadline"{
            deadline = showDateformatter.string(from: date)
        }
    }
    
    @IBAction func clearLocation(_ sender: UIButton){
        //savePlaceModel = nil
        //tableView.reloadRows(at: [IndexPath.init(row: 4, section: 0)], with: .none)
    }
    
    @objc func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func addTaskButton(_ sender: UIButton) {
        self.view.endEditing(true)
        if d == false{ deadline = "" }
        if t == false{ taskTime = "" }
        if taskName == ""{
            alertMessage()
        }else{
            reminder = reminder_index.map { String($0) }.joined(separator: ",")
            let modelInfo = TaskModel(taskId: id, taskName: taskName, taskTime: taskTime, taskDeadline: deadline, taskLocation: taskLocation, reminder: reminder, addToCal: addToCal, isPinned: isPinned, isDone: isDone)
            DBManager.getInstance().addTask(modelInfo)
            if reminder != "0" && deadline != "" {makeNotification(action: "add")}
            self.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "taskUnwindSegue", sender: self)
        }
    }
    
    @objc func editTaskButton(_ sender: UIButton) {
        self.view.endEditing(true)
        if d == false{ deadline = "" }
        if t == false{ taskTime = "" }
//        if d == false{ deadline = nil }
//        if t == false{ taskTime = nil }
//        if p == false{ isPinned = nil }
        if taskName == ""{
            alertMessage()
        }else{
            reminder = reminder_index.map { String($0) }.joined(separator: ",")
            let modelInfo = TaskModel(taskId: id, taskName: taskName, taskTime: taskTime, taskDeadline: deadline, taskLocation: taskLocation, reminder: reminder, addToCal: addToCal, isPinned: isPinned, isDone: isDone)
            DBManager.getInstance().editTask(modelInfo)
            makeNotification(action: "delete")
            if reminder != "0" && deadline != "" {
                makeNotification(action: "add")
                
            }
            self.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "taskUnwindSegue", sender: self)
        }
        }
    
    @objc func deleteTaskButton(_ sender: UIButton) {
        let controller = UIAlertController(title: "WARNING", message: "Are you sure to delete the task", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){_ in
            controller.dismiss(animated: true, completion: nil); self.dismiss(animated: true, completion: nil); self.delete()}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){_ in controller.dismiss(animated: true, completion: nil)}
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        self.present(controller, animated: true,completion: .none)
    }
    
    func delete(){
        let modelInfo = TaskModel(taskId: id, taskName: taskName, taskTime: taskTime, taskDeadline: deadline, taskLocation: taskLocation, reminder: reminder, addToCal: addToCal, isPinned: isPinned, isDone: isDone)
        DBManager.getInstance().deleteTask(id: modelInfo.taskId)
        performSegue(withIdentifier: "taskUnwindSegue", sender: self)
    }
    
    func makeNotification(action: String){
        //var notifivationids = [String]()
        //var notificationIndex = [0]
        let notificationIndex = reminder_index
        switch action {
        case "add":
            let fireDate = showDateformatter.date(from: deadline)!
            let no = UNMutableNotificationContent()
                no.title = "Task Notification"
            no.body = "name: " + taskName + "\ntime: " + deadline
            for i in 0...notificationIndex.count-1{
                var notificationid = ""
                if task == nil{
                    notificationid = String(DBManager.getInstance().getMaxTask())
                }else{
                    notificationid = String(task!.taskId)
                }
                //let calendar = Calendar.current
                let components = Calendar.current.dateComponents([ .hour, .minute],from: fireDate-TimeInterval(reminderData[notificationIndex[i]].fireTime))
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                    notificationid = "task\(notificationid)_\(notificationIndex[i])"
                let request = UNNotificationRequest(identifier: notificationid, content: no, trigger: trigger)
                UNUserNotificationCenter.current().add(request,withCompletionHandler: nil)
            }
        case "delete":
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: oldReminder_index)
        default:
            print("")
        }
    }
    
    func alertMessage(){
            if taskName == ""{
                let controller = UIAlertController(title: "Error", message: "Enter a name", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default){_ in
                    controller.dismiss(animated: true, completion: nil)}
                controller.addAction(okAction)
                self.present(controller, animated: true,completion: .none)
            }
    }
    
    func alertMessage1(){
               if deadline == "" {
                   let controller = UIAlertController(title: "Error", message: "Enter a deadline", preferredStyle: .alert)
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
            print("?????\(taskTime)")
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
            if deadline == ""{
                cell.txtDeadline.text = ""
            }else{
                cell.txtDeadline.text = showWeekdayformatter.string(from: showDateformatter.date(from: deadline)!)
            }
//            let i = showDateformatter.date(from: deadline)
//            cell.txtDeadline.text = showWeekdayformatter.string(from: i)
            return cell
        case [3,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addToCalendarCell", for: indexPath)
            cell.accessoryView = switchcalendar
            switchcalendar.setOn(addToCal, animated: .init())
            cell.selectionStyle = .none
            return cell
        case [4,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! reminderCell
            var txtReminder = ""
            for i in 0...reminder_index.count-1{
                txtReminder += "\(reminderData[reminder_index[i]].rname) , "
            }
            cell.txtReminder.text = txtReminder
            //switchreminder.setOn(reminder, animated: .init())
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        case [5,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskLocationCell", for: indexPath) as! taskLocationCell
            cell.txtTaskLocation.text = savePlace?.placeName
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
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
            if taskTime == ""{ taskTime = "01:00"}
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
            if deadline == ""{ deadline = showDateformatter.string(from: Date()+86400)}
            tableViewData[1].opened = true
            tableView.insertRows(at: indexA, with: .fade)
        }else{
            d = false
            deadline = ""
            tableViewData[1].opened = false
            tableView.deleteRows(at: indexA, with: .fade)
            if addToCal == true{
                addToCal = false
                switchcalendar.setOn(addToCal, animated: .init())
            }
            if reminder != "0" {
                reminder_index = [0]
                reminder = "0"
            }
//            if reminder == true{
//                reminder = false
//                switchreminder.setOn(reminder, animated: .init())
//            }
        }
    }
    
    @objc func calendarOpen(_ sender: UISwitch){
        var indexA = [IndexPath]()
        indexA.append([2,1])
        if sender.isOn == true{
            if deadline == ""{
                alertMessage1()
                switchcalendar.isOn = false
                addToCal = false
            }else{
                addToCal = true
                switchdeadline.isOn = true
                d = true
                //tableViewData[1].opened = true
                //tableView.insertRows(at: indexA, with: .fade)
            }
        }else{
            addToCal = false
        }
    }
    
//    @objc func reminderOpen(_ sender: UISwitch){
//        var indexA = [IndexPath]()
//        indexA.append([2,1])
//          if sender.isOn == true{
//              reminder = true
//            if d == false{
//                d = true
//                switchdeadline.isOn = true
//                tableViewData[1].opened = true
//                tableView.insertRows(at: indexA, with: .fade)
//            }
//          }else{
//              reminder = false
//          }
//      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath{
        case[1,1]:
            performSegue(withIdentifier: "addTaskTime", sender: self)
        case[2,1]:
            performSegue(withIdentifier: "deadline", sender: self)
        case[4,0]:
            if deadline == ""{
                alertMessage1()
            }else{
                performSegue(withIdentifier: "taskReminder", sender: self)
            }
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
