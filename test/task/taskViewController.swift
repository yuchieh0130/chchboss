//
//  taskViewController.swift
//  test
//
//  Created by 王義甫 on 2020/4/4.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import Floaty

@available(iOS 13.0, *)
class taskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, UITabBarDelegate{
    
    //db variables
    //    var taskName: String?
    //    var taskDeadline: String! = ""
    //    var taskTime: String?
    //    var reminder: Bool! = false
    //    var id: Int32 = 0
    
    @IBOutlet var tableView: UITableView!
    //var taskId :Int32?
    var task: TaskModel?
    
    var selectedTask: String = ""
    var showTask: [TaskModel]?
    
    var showDateformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    var formatter1: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    var formatter2: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    var formatter3: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    var fab: Floaty!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController?.toolbar.isHidden = true
        self.navigationController?.navigationBar.shadowImage = UIImage()

        let addTaskBtn = UIButton.init(type: .system)
        addTaskBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        addTaskBtn.layer.borderWidth = 1.25
        addTaskBtn.layer.cornerRadius = 5
        addTaskBtn.layer.borderColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.8).cgColor
        addTaskBtn.frame = CGRect(x:0, y:0, width:48, height:34)
        addTaskBtn.addTarget(self, action: #selector(addTask(_:)), for: .touchUpInside)
        let editTaskBtn = UIButton.init(type: .system)
        editTaskBtn.setTitle("Edit", for: .normal)
        editTaskBtn.layer.borderWidth = 1.25
        editTaskBtn.layer.cornerRadius = 5
        editTaskBtn.layer.borderColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.8).cgColor
        editTaskBtn.frame = CGRect(x:0, y:0, width:48, height:34)
        editTaskBtn.addTarget(self, action: #selector(editTask(_:)), for: .touchUpInside)
        let doneTaskBtn = UIButton.init(type: .system)
        doneTaskBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
        doneTaskBtn.layer.borderWidth = 1.25
        doneTaskBtn.layer.cornerRadius = 5
        doneTaskBtn.layer.borderColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.8).cgColor
        doneTaskBtn.frame = CGRect(x:0, y:0, width:48, height:34)
        doneTaskBtn.addTarget(self, action: #selector(doneTask(_:)), for: .touchUpInside)
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: addTaskBtn), flexible, flexible, UIBarButtonItem(customView: doneTaskBtn)]
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: editTaskBtn)]
        
        let floaty = Floaty(frame: CGRect(x: self.view.frame.width - 67, y: self.view.frame.height - 140, width: 45, height: 45))
        floaty.buttonColor = UIColor(red: 247/255, green: 199/255, blue: 88/255, alpha: 1)
        floaty.plusColor = UIColor.white
        floaty.itemButtonColor = UIColor(red: 67/255, green: 76/255, blue: 123/255, alpha: 1)
        floaty.itemTitleColor =  UIColor(red: 67/255, green: 76/255, blue: 123/255, alpha: 1)
        floaty.overlayColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        floaty.itemShadowColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        floaty.addItem("Add Task", icon: UIImage(systemName: "doc.text"), handler: {_ in
            self.performSegue(withIdentifier: "addTask", sender: self)
        })
        floaty.addItem("Add Event", icon: UIImage(systemName: "calendar"), handler: {_ in
            self.performSegue(withIdentifier: "taskAddEvent", sender: self)
        })
        floaty.translatesAutoresizingMaskIntoConstraints = false
        floaty.openAnimationType = .slideUp
        floaty.isDraggable = true
        floaty.hasShadow = false
        floaty.autoCloseOnTap = true
        self.view.addSubview(floaty)
        fab = floaty
        floatyConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DBManager.getInstance().getAllUndoneTask() != nil{
            showTask = DBManager.getInstance().getAllUndoneTask()
        }else{
            showTask = [TaskModel]()
        }
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
        tableView.reloadData()
    }
    
    func floatyConstraints(){
        fab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.view.frame.height-140)
            make.leading.equalToSuperview().offset(self.view.frame.width-67)
            make.height.equalTo(45)
            make.width.equalTo(45)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func addTask(_ sender: Any) {
        task = nil
        performSegue(withIdentifier: "addTask", sender: self)
    }
    @objc func editTask(_ sender: Any){
        if DBManager.getInstance().getAllUndoneTask() != nil{
            performSegue(withIdentifier: "taskToEditMode", sender: self)
        }else{
            let controller = UIAlertController(title: "No Tasks Available", message: "Add task to let BunnyTrack 🥕 \n make better plans for you", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        }
        
    }
    
    @objc func doneTask(_ sender: UIButton) {
        if DBManager.getInstance().getAllDoneTask() != nil {
            performSegue(withIdentifier: "doneTask", sender: self)
        }else{
            let controller = UIAlertController(title: "No Done Tasks Available", message: "No task marked as DONE", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        }
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showTask?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //往右滑
    @available(iOS 13.0, *)
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let id = showTask?[indexPath.row].taskId
        let pinAction = UIContextualAction(style: .normal, title: "Pin") { (action, view, completionHandler) in
            print("Pin")
            completionHandler(true)
            self.tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            DBManager.getInstance().pinTask(id: id!)
            self.showTask = DBManager.getInstance().getAllUndoneTask()
            self.tableView.reloadData()
        }
        let unPinAction = UIContextualAction(style: .normal, title: "Unpin") { (action, view, completionHandler) in
            print("Unpin")
            completionHandler(true)
            DBManager.getInstance().unPinTask(id: id!)
            self.showTask = DBManager.getInstance().getAllUndoneTask()
            self.tableView.reloadData()
        }
        if showTask?[indexPath.row].isPinned == false{
            let configuration = UISwipeActionsConfiguration(actions: [pinAction])
            pinAction.backgroundColor = UIColor(red: 218/255, green: 64/255, blue: 122/255, alpha: 1)
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        }else{
            let configuration = UISwipeActionsConfiguration(actions: [unPinAction])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        }
    }
    
    //往左滑
    @available(iOS 13.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let id =  showTask?[indexPath.row].taskId
        //let task = showTask?[indexPath.row]
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            print("Delete")
            completionHandler(true)
            let controller = UIAlertController(title: "Delete this task?", message: nil, preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "Delete", style: .default) { (_) in
                    self.showTask!.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    DBManager.getInstance().deleteTask(id: id!)
                    self.dismiss(animated: true, completion: nil)
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                action.setValue(UIColor.red, forKey: "titleTextColor")
                controller.addAction(action)
                controller.addAction(cancel)
                self.present(controller, animated: true, completion: nil)
        }
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (action, view, completionHandler) in
            print("Done")
            completionHandler(true)
            DBManager.getInstance().doneTask(id: id!)
            self.showTask!.remove(at: indexPath.row)
            if DBManager.getInstance().getAllUndoneTask() == nil{
                self.showTask = [TaskModel]()
            }else{
                self.showTask = DBManager.getInstance().getAllUndoneTask()
            }
            self.tableView.reloadData()
        }
//        let doItNowAction = UIContextualAction(style: .normal, title: "Do It Now") { (action, view, completionHandler) in
//            print("Do It Now")
//            completionHandler(true)
//        }
        deleteAction.backgroundColor = UIColor.red
        doneAction.backgroundColor = UIColor(red: 107/255, green: 123/255, blue: 228/255, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, doneAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "editTask":
            if let navVC = segue.destination as? UINavigationController, let
                editVC = navVC.topViewController as? addTaskViewController{
                editVC.task = task
            }
        case "taskAddEvent":
            if let navVC = segue.destination as? UINavigationController, let
                addVC = navVC.topViewController as? addViewController{
                let VC = segue.source as? ViewController
                if VC?.calendarView.selectedDates.isEmpty == false{
                    addVC.selectedDay = VC!.calendarView.selectedDates
                }
            }
        case "doneTask":
            if let doneVC = segue.destination as? doneTaskViewController{
                doneVC.hidesBottomBarWhenPushed = true
            }
        default:
            print("")
        }
        
    }
    
    @IBAction func taskUnwindSegue(segue: UIStoryboardSegue){
        if segue.identifier == "taskUnwindSegue"{
            if DBManager.getInstance().getAllUndoneTask() != nil{
                showTask = DBManager.getInstance().getAllUndoneTask()
            }else{
                showTask = [TaskModel]()
            }
            tableView.reloadData()
        }
        if segue.identifier == "taskEditUnwindSegue"{
            if DBManager.getInstance().getAllUndoneTask() != nil{
                showTask = DBManager.getInstance().getAllUndoneTask()
            }else{
                showTask = [TaskModel]()
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:taskTableViewCell = tableView.dequeueReusableCell(withIdentifier: "taskTableViewCell", for: indexPath) as! taskTableViewCell
        let task = showTask![indexPath.row]
        if DBManager.getInstance().getAllUndoneTask() == nil{
            cell.taskName?.text = "No Task Available"
            cell.taskDeadline.text = "Add Tasks!"
        }else{
            cell.taskName?.text = showTask![indexPath.row].taskName
        }
        if task.taskTime != ""{
            let t = formatter1.date(from: showTask![indexPath.row].taskTime)
            cell.addTaskTime.text = " \(formatter2.string(from: t!)) hr \(formatter3.string(from: t!)) min "
        }else{
            cell.addTaskTime.text = nil
        }
        if task.taskDeadline != ""{
            let d = showDateformatter.date(from: task.taskDeadline)
            let interval = d!.timeIntervalSinceNow
            let day = Int(interval/86400)
            let hour = Int((Int(interval)-Int(interval/86400)*86400)/3600)
            let min = Int((Int(interval)-Int(interval/86400)*86400-((Int(interval)-Int(interval/86400)*86400)/3600)*3600)/60)
            if interval<0{
                cell.taskDeadline.text = "Overdue"
                cell.taskDeadline.textColor = UIColor.red
            }else if interval<3600{
                cell.taskDeadline.text = "\(min) Minute(s) Till Deadline"
                cell.taskDeadline.textColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
            }else if interval<86400{
                cell.taskDeadline.text = "\(hour) Hour(s) Till Deadline"
                cell.taskDeadline.textColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
            }else if interval>86400 && interval<172800{
                cell.taskDeadline.text = " \(day) Day Till Deadline"
                cell.taskDeadline.textColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
            }else if interval>172800{
                cell.taskDeadline.text = "\(day) Days Till Deadline"
                cell.taskDeadline.textColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
            }
        }else{
            cell.taskDeadline.text = "No Deadline"
            cell.taskDeadline.textColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
        }
       
        if showTask?[indexPath.row].isPinned == false{
            cell.taskPin.isHidden = true
        }else{
            cell.taskPin.isHidden = false
        }
        
        if showTask?[indexPath.row].addToCal == false{
            cell.taskCalendar.isHidden = true
        }else{
            cell.taskCalendar.isHidden = false
        }
        cell.tintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        task = showTask![indexPath.row]
        performSegue(withIdentifier: "editTask", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
