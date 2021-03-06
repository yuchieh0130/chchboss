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
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationItem!
    
    var task: TaskModel?
    var selectedTask: String = ""
    var showTask: [TaskModel]?
    var btnSelect: UIBarButtonItem!
    var btnSelectAll: UIBarButtonItem!
    var isTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectAllBtn = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(btnSelectDidTap))
        self.tableView.allowsMultipleSelectionDuringEditing = true
        navigationItem.rightBarButtonItems = [editButtonItem]
        btnSelect = editButtonItem
        btnSelectAll = selectAllBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DBManager.getInstance().getAllDoneTask() != nil{
            showTask = DBManager.getInstance().getAllDoneTask()
        }else{
            showTask = [TaskModel]()
        }
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
        tableView.reloadData()
    }
    
    func updateBarButton(isTapped : Bool){
        if isTapped {
            btnSelectAll.title = "Deselect All"
        }else{
            btnSelectAll.title = "Select All"
        }
        self.navigationItem.rightBarButtonItems = [btnSelectAll]
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
        //let task = showTask![indexPath.row]
        if let taskDeadline = showTask?[indexPath.row].taskDeadline{
            if taskDeadline == ""{
                cell.doneTaskMark.text = "No Deadline"
            }else{
                cell.doneTaskMark.text = showTask![indexPath.row].taskDeadline
            }
        }
        cell.doneTaskName?.text = showTask![indexPath.row].taskName
        
        if showTask?[indexPath.row].addToCal == false{
            cell.doneTaskCalendar.isHidden = true
        }else{
            cell.doneTaskCalendar.isHidden = false
        }
        cell.tintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        
        return cell
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let id =  showTask?[indexPath.row].taskId
        //let task = showTask?[indexPath.row]
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            print("Delete")
            completionHandler(true)
            let controller = UIAlertController(title: "Delete this Done task?", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Delete", style: .default) { (_) in
                self.showTask!.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                DBManager.getInstance().deleteDoneTask(id: id!)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            action.setValue(UIColor.red, forKey: "titleTextColor")
            controller.addAction(action)
            controller.addAction(cancel)
            self.present(controller, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = UIColor.red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
        
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
        deleteButton.frame = CGRect(x:0, y:0, width:200, height:32)
        deleteButton.addTarget(self, action: #selector(didPressDelete), for: .touchUpInside)
        
        if tableView.isEditing == true{
            editButtonItem.title = "Cancel"
            self.toolbarItems = [flexible, UIBarButtonItem(customView: deleteButton), flexible]
            navigationItem.hidesBackButton = true
            navigationItem.rightBarButtonItems = [btnSelectAll]
            navigationItem.leftBarButtonItems = [editButtonItem]
        }else if tableView.isEditing == false{
            editButtonItem.title = "Edit"
            self.navigationController?.setToolbarHidden(true, animated: true)
            navigationItem.hidesBackButton = false
            navigationItem.leftBarButtonItems = []
            navigationItem.rightBarButtonItems = [editButtonItem]
        }
    }
    
    @objc func didPressDelete() {
        let selectedRows = self.tableView.indexPathsForSelectedRows
        let controller = UIAlertController(title: "Delete Done Task?", message: "Tasks will also be deleted from the calendar.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            if selectedRows != nil {
                for selectionIndex in selectedRows!.reversed() {
                    let id =  self.showTask?[selectionIndex.row].taskId
                    self.showTask!.remove(at: selectionIndex.row)
                    self.tableView.deleteRows(at: [selectionIndex], with: .fade)
                    DBManager.getInstance().deleteDoneTask(id: id!)
                    if DBManager.getInstance().getAllDoneTask() != nil{
                        self.showTask = DBManager.getInstance().getAllDoneTask()
                    }else{
                        self.showTask = [TaskModel]()
                    }
                    self.tableView.reloadData()
                }
            }
            self.tableView.setEditing(false, animated: true)
            self.editButtonItem.title = "Edit"
            self.navigationController?.setToolbarHidden(true, animated: true)
            self.navigationItem.hidesBackButton = false
            self.navigationItem.leftBarButtonItems = []
            self.navigationItem.rightBarButtonItems = [self.editButtonItem]
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}
