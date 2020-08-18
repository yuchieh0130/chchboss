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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
//        case "addTask":
//            if let navVC = segue.destination as? UINavigationController, let
//                addVC = navVC.topViewController as? addTaskViewController {
//            }
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
        default:
            print("")
        }
        
    }
    
    @IBAction func taskUnwindSegue(segue: UIStoryboardSegue){
        if segue.identifier == "taskUnwindSegue"{
            if DBManager.getInstance().getAllUndoneTask() == nil{
                self.showTask = [TaskModel]()
            }else{
                self.showTask = DBManager.getInstance().getAllUndoneTask()
            }
            self.tableView.reloadData()
        }
    }
    
    var fab: Floaty!
    var btnAdd: UIBarButtonItem!
    var btnDone: UIBarButtonItem!
    var btnSelect: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task"
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsMultipleSelectionDuringEditing = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let addTaskBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask(_:)))
        editButtonItem.title = "Select"
        let doneTaskBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTask(_:)))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        navigationItem.rightBarButtonItems = [editButtonItem]
        navigationItem.leftBarButtonItems = [addTaskBtn, flexible, doneTaskBtn]
        btnAdd = addTaskBtn
        btnDone = doneTaskBtn
        btnSelect = editButtonItem
        
        let floaty = Floaty(frame: CGRect(x: self.view.frame.width - 67, y: self.view.frame.height - 140, width: 45, height: 45))
        floaty.buttonColor = UIColor(red: 247/255, green: 199/255, blue: 88/255, alpha: 1)
        floaty.plusColor = UIColor.white
        floaty.itemButtonColor = UIColor(red: 67/255, green: 76/255, blue: 123/255, alpha: 1)
        floaty.itemTitleColor =  UIColor(red: 67/255, green: 76/255, blue: 123/255, alpha: 1)
//        UIColor(red: 190/255, green: 155/255, blue: 116/255, alpha: 1)
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
        performSegue(withIdentifier: "addTask", sender: sender)
    }
    
    @objc func doneTask(_ sender: UIButton) {
        if DBManager.getInstance().getAllDoneTask() != nil {
            performSegue(withIdentifier: "doneTask", sender: self)
        }else{
            let controller = UIAlertController(title: "Unavailable", message: "No task marked as DONE", preferredStyle: .alert)
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
        //let task = showTask?[indexPath.row]
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
        doneAction.backgroundColor = UIColor(red: 103/255, green: 112/255, blue: 150/255, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, doneAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
//        self.navigationController?.navigationBar.tintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)]
        
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
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.5)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)]
//    }
    
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
        //        if showTask?[indexPath.row].taskDeadline?.endIndex = {
        //            }
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
        if self.tableView.isEditing == false{
            performSegue(withIdentifier: "editTask", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.toolbar.barTintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let deleteButton: UIBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(didPressDelete))
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didPressDone))
        deleteButton.tintColor = UIColor.red
        doneButton.tintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
        
        if tableView.isEditing == true{
            editButtonItem.title = "Cancel"
            self.toolbarItems = [flexible, doneButton, flexible, deleteButton, flexible]
            fab.isHidden = true
            navigationItem.rightBarButtonItems = [btnSelect]
            navigationItem.leftBarButtonItems = []
        }else if tableView.isEditing == false{
            editButtonItem.title = "Select"
            self.navigationController?.setToolbarHidden(true, animated: true)
            fab.isHidden = false
            navigationItem.rightBarButtonItems = [btnSelect]
            navigationItem.leftBarButtonItems = [btnAdd, btnDone]
        }
    }
    
    @objc func didPressDelete() {
        let selectedRows = self.tableView.indexPathsForSelectedRows
        let controller = UIAlertController(title: "Delete Done Task?", message: "Tasks will also be deleted from the calendar.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            if selectedRows != nil {
                for selectionIndex in selectedRows! {
                    let id =  self.showTask?[selectionIndex.row].taskId
                    //let task = self.showTask?[selectionIndex.row]
                    self.showTask!.remove(at: selectionIndex.row)
                    self.tableView.deleteRows(at: [selectionIndex], with: .fade)
                    DBManager.getInstance().deleteDoneTask(id: id!)
                    self.tableView.reloadData()
                }
            }
            print("OK")
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    @objc func didPressDone() {
        let selectedRows = self.tableView.indexPathsForSelectedRows
        let controller = UIAlertController(title: "Task Done?", message: "Tasks added to the DONE list could not be revertible.", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            if selectedRows != nil {
                for selectionIndex in selectedRows! {
                    let id =  self.showTask?[selectionIndex.row].taskId
                    DBManager.getInstance().doneTask(id: id!)
                    self.showTask!.remove(at: selectionIndex.row)
                    if DBManager.getInstance().getAllUndoneTask() == nil{
                        self.showTask = [TaskModel]()
                    }else{
                        self.showTask = DBManager.getInstance().getAllUndoneTask()
                    }
                    self.tableView.reloadData()
                }
            }
            print("OK")
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        doneAction.setValue(UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1), forKey: "titleTextColor")
        controller.addAction(doneAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
}
