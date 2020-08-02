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
    
    @IBOutlet var addTaskButton: UIButton!
    //@IBOutlet var editTaskButton: UIButton!
    @IBOutlet var taskDoneBtn: UIButton!
    
    
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
    
    @IBAction func addTask(_ sender: Any) {
        task = nil
        performSegue(withIdentifier: "addTask", sender: sender)
    }
    
    //    @IBAction func edit(_ sender: Any) {
    //        self.tableView.isEditing = !tableView.isEditing
    //        if tableView.isEditing{
    //            editTaskButton.setTitle("Done", for: .normal)
    //        }else{
    //            editTaskButton.setTitle("Edit", for: .normal)
    //        }
    //    }
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLayoutSubviews()
        title = "Task"
        tableView.delegate = self
        tableView.dataSource = self
        
        let floaty = Floaty(frame: CGRect(x: self.view.frame.width - 67, y: self.view.frame.height - 145, width: 45, height: 45))
        floaty.buttonColor = UIColor(red: 247/255, green: 199/255, blue: 88/255, alpha: 1)
        floaty.plusColor = UIColor.white
        floaty.itemButtonColor = UIColor(red: 190/255, green: 155/255, blue: 116/255, alpha: 0.8)
        if #available(iOS 13.0, *) {
            floaty.addItem("Add Task", icon: UIImage(systemName: "doc.text"), handler: {_ in
                self.performSegue(withIdentifier: "addTask", sender: self)
            })
            floaty.addItem("Add Event", icon: UIImage(systemName: "calendar"), handler: {_ in
                self.performSegue(withIdentifier: "taskAddEvent", sender: self)
            })
        } else {
            floaty.addItem("Add Task", icon: UIImage(named: "task"), handler: {_ in
                self.performSegue(withIdentifier: "addTask", sender: self)
            })
            floaty.addItem("Add Event", icon: UIImage(named: "calendar"), handler: {_ in
                self.performSegue(withIdentifier: "taskAddEvent", sender: self)
            })
        }
        floaty.translatesAutoresizingMaskIntoConstraints = false
        floaty.openAnimationType = .slideUp
        floaty.isDraggable = true
        floaty.hasShadow = false
        floaty.autoCloseOnTap = true
        self.view.addSubview(floaty)
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
        let doItNowAction = UIContextualAction(style: .normal, title: "Do It Now") { (action, view, completionHandler) in
            print("Do It Now")
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor.red
        doneAction.backgroundColor = #colorLiteral(red: 0.2979176044, green: 0.6127660275, blue: 0.9929869771, alpha: 1)  //color literal
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, doneAction, doItNowAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DBManager.getInstance().getAllUndoneTask() != nil{
            showTask = DBManager.getInstance().getAllUndoneTask()
        }else{
            showTask = [TaskModel]()
        }
        tableView.reloadData()
    }
    
    @IBAction func doneTask(_ sender: UIButton) {
        if DBManager.getInstance().getAllDoneTask() != nil {
            performSegue(withIdentifier: "doneTask", sender: self)
        }else{
            let controller = UIAlertController(title: "Unavailable", message: "No task marked as DONE", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        }
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
        let task = showTask![indexPath.row]
        cell.taskName?.text = showTask![indexPath.row].taskName
        if task.taskTime != nil{
            let t = formatter1.date(from: showTask![indexPath.row].taskTime!)
            cell.addTaskTime.text = " \(formatter2.string(from: t!)) hr \(formatter3.string(from: t!)) min "
        }else{
            cell.addTaskTime.text = nil
        }
        if task.taskDeadline != nil{
            let d = showDateformatter.date(from: task.taskDeadline!)
            let interval = d!.timeIntervalSinceNow
            let day = Int(interval/86400)
            let hour = Int((Int(interval)-Int(interval/86400)*86400)/3600)
            let min = Int((Int(interval)-Int(interval/86400)*86400-((Int(interval)-Int(interval/86400)*86400)/3600)*3600)/60)
            if interval<0{
                cell.taskDeadline.text = "Over\ndue"
                cell.taskDeadline.textColor = UIColor.red
            }else if interval<3600{
                cell.taskDeadline.text = "\(min) min(s)"
            }else if interval<86400{
                cell.taskDeadline.text = "\(hour) hrs"
            }else if interval>86400 && interval<172800{
                cell.taskDeadline.text = " \(day) day"
            }else if interval>172800{
                cell.taskDeadline.text = "\(day) days"
            }
        }else{
            cell.taskDeadline.text = ""
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        task = showTask![indexPath.row]
        performSegue(withIdentifier: "editTask", sender: nil)
    }
    
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //        return .delete
    //    }
    //
    //    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    
    //    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    //        let tomove = (self.showTask?.remove(at: sourceIndexPath.row))!
    //        showTask?.insert(tomove, at: destinationIndexPath.row)
    //    }
    
}
