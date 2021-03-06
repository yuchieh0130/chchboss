//
//  taskEditModeViewController.swift
//  test
//
//  Created by 王義甫 on 2020/8/21.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class taskEditModeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var task: TaskModel?
    var showTask: [TaskModel]?
    var isTapped = false
    
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
    
    var selectBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsMultipleSelectionDuringEditing = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        let selectAllBtn = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(btnSelectDidTap))
        navigationItem.rightBarButtonItems = [selectAllBtn]
        navigationItem.leftBarButtonItems = [cancelBtn]
        selectBtn = selectAllBtn
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
        tableView.setEditing(true, animated: true)
        
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.toolbar.barTintColor = UIColor.white
        self.navigationController?.toolbar.barStyle = .blackOpaque
    
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let deleteButton = UIButton.init(type: .system)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.backgroundColor = UIColor.red
        deleteButton.titleLabel?.font = UIFont(name: "System", size: 18)
        deleteButton.layer.cornerRadius = 5
        deleteButton.frame = CGRect(x:0, y:0, width:160, height:32)
        deleteButton.addTarget(self, action: #selector(didPressDelete), for: .touchUpInside)
        let doneButton = UIButton.init(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.backgroundColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
        doneButton.titleLabel?.font = UIFont(name: "System", size: 18)
        doneButton.layer.cornerRadius = 5
        doneButton.frame = CGRect(x:0, y:0, width:160, height:32)
        doneButton.addTarget(self, action: #selector(didPressDone), for: .touchUpInside)

        self.toolbarItems = [flexible, UIBarButtonItem(customView: doneButton), flexible, UIBarButtonItem(customView: deleteButton), flexible]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateBarButton(isTapped : Bool){
        if isTapped {
            selectBtn.title = "Deselect All"
        }else{
            selectBtn.title = "Select All"
        }
        self.navigationItem.rightBarButtonItems = [selectBtn]
    }

    @objc func btnSelectDidTap(){
        self.isTapped = !self.isTapped;
        if self.isTapped {
            self.selectAllRows()
        }else{
            self.deselectAllRows()
        }
        self.updateBarButton(isTapped: self.isTapped)
    }
    
    @objc func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectAllRows(){
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            tableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .none)
        }
    }
    
    func deselectAllRows(){
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: false)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showTask!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: taskEditModeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "taskEditModeTableViewCell", for: indexPath) as! taskEditModeTableViewCell
        let task = showTask![indexPath.row]
        cell.taskEditName?.text = showTask![indexPath.row].taskName
        if task.taskTime != ""{
            let t = formatter1.date(from: showTask![indexPath.row].taskTime)
            cell.addTaskEditTime.text = " \(formatter2.string(from: t!)) hr \(formatter3.string(from: t!)) min "
        }else{
            cell.addTaskEditTime.text = nil
        }
        if task.taskDeadline != ""{
            let d = showDateformatter.date(from: task.taskDeadline)
            let interval = d!.timeIntervalSinceNow
            let day = Int(interval/86400)
            let hour = Int((Int(interval)-Int(interval/86400)*86400)/3600)
            let min = Int((Int(interval)-Int(interval/86400)*86400-((Int(interval)-Int(interval/86400)*86400)/3600)*3600)/60)
            if interval<0{
                cell.taskEditDeadline.text = "Overdue"
                cell.taskEditDeadline.textColor = UIColor.red
            }else if interval<3600{
                cell.taskEditDeadline.text = "\(min) Minute(s) Till Deadline"
                cell.taskEditDeadline.textColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
            }else if interval<86400{
                cell.taskEditDeadline.text = "\(hour) Hour(s) Till Deadline"
                cell.taskEditDeadline.textColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
            }else if interval>86400 && interval<172800{
                cell.taskEditDeadline.text = " \(day) Day Till Deadline"
                cell.taskEditDeadline.textColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
            }else if interval>172800{
                cell.taskEditDeadline.text = "\(day) Days Till Deadline"
                cell.taskEditDeadline.textColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
            }
        }else{
            cell.taskEditDeadline.text = "No Deadline"
            cell.taskEditDeadline.textColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
        }
        if showTask?[indexPath.row].isPinned == false{
            cell.taskEditPin.isHidden = true
        }else{
            cell.taskEditPin.isHidden = false
        }
        
        if showTask?[indexPath.row].addToCal == false{
            cell.taskEditCalendar.isHidden = true
        }else{
            cell.taskEditCalendar.isHidden = false
        }
        cell.tintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    @objc func didPressDelete() {
        let selectedRows = self.tableView.indexPathsForSelectedRows
        let controller = UIAlertController(title: "Delete Tasks?", message: "Tasks will also be deleted from the calendar.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            if selectedRows != nil {
                for selectionIndex in selectedRows!.reversed() {
                    let id =  self.showTask?[selectionIndex.row].taskId
                    self.showTask!.remove(at: selectionIndex.row)
                    self.tableView.deleteRows(at: [selectionIndex], with: .fade)
                    DBManager.getInstance().deleteTask(id: id!)
                    if DBManager.getInstance().getAllUndoneTask() != nil{
                        self.showTask = DBManager.getInstance().getAllUndoneTask()
                    }else{
                        self.showTask = [TaskModel]()
                    }
                    self.tableView.reloadData()
                }
            }
            self.dismiss(animated: true, completion: nil)
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    @objc func didPressDone() {
        let selectedRows = self.tableView.indexPathsForSelectedRows
        let controller = UIAlertController(title: "Tasks Done?", message: "Tasks added to the DONE list could not be revertible.", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            if selectedRows != nil {
                for selectionIndex in selectedRows!.reversed() {
                    let id =  self.showTask?[selectionIndex.row].taskId
                    self.showTask!.remove(at: selectionIndex.row)
                    self.tableView.deleteRows(at: [selectionIndex], with: .fade)
                    DBManager.getInstance().doneTask(id: id!)
                    if DBManager.getInstance().getAllUndoneTask() != nil{
                        self.showTask = DBManager.getInstance().getAllUndoneTask()
                    }else{
                        self.showTask = [TaskModel]()
                    }
                    self.tableView.reloadData()
                }
            }
            self.dismiss(animated: true, completion: nil)
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        doneAction.setValue(UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1), forKey: "titleTextColor")
        controller.addAction(doneAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}
