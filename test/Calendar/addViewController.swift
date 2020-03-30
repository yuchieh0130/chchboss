//
//  File.swift
//  test
//
//  Created by 謝宛軒 on 2020/3/26.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

struct cellConfig{
    var opened = Bool()
    var title = String()
}

class addViewController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnEdit: UIButton!
    
    //tableView Item
    var tableViewData = [cellConfig]()
    let switchallDay = UISwitch()
    let switchAuto = UISwitch()
    let switchtask = UISwitch()
    let switchreminder = UISwitch()
    
    //db variables
    var name: String?
    var startDate: String! = "" //Only Date
    var endDate: String! = ""
    var startTime: String?  //Only time
    var endTime: String?
    var allDay: Bool! = false
    var autoRecord: Bool! = false
    var task: Bool! = false
    var taskTime: String?
    var reminder: Bool! = false
    var id: Int32 = 0
    
    var event : EventModel?
    
    //variable for handling from DatePopViewController
    var tag: String? //which? (startDate,EndDate,editTask)
    var date = Date() //date from DatePopViewController
    var strdate: String? //send current data to DatePopViewController
    var showStart: String = "" //format show out on storyboard
    var showEnd: String = "" //format show out on storyboard
    var showAutoStart: String = ""
    var showAutoEnd: String = ""
    var autoCategory: String = ""
    var autoLocation: String = ""
    
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
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        tableViewData = [cellConfig(opened: false, title: "Name"),
                         cellConfig(opened: false, title: "Start"),
                         cellConfig(opened: false, title: "End"),
                         cellConfig(opened: false, title: "AllDay"),
                         cellConfig(opened: false, title: "AutoRecord"),
                         cellConfig(opened: false, title: "Task"),
                         cellConfig(opened: false, title: "Reminder")]
        
        //func for asseccoryView
         switchallDay.addTarget(self, action: #selector(self.allDayOpen(_ :)), for: .valueChanged)
         switchAuto.addTarget(self, action: #selector(self.autoOpen(_ :)), for: .valueChanged)
         switchtask.addTarget(self, action: #selector(self.taskOpen(_ :)), for: .valueChanged)
         switchreminder.addTarget(self, action: #selector(self.reminderOpen(_ :)), for: .valueChanged)
        
        //檢查是要新增還是編輯event
        if event != nil{
            loadData()
            btnSave.isHidden = true
            btnEdit.isHidden = false
        }else{
            //初始化日期
            startDate = showDayformatter.string(for: Date())!
            startTime = showTimeformatter.string(for: Date())!
            showStart = startDate+" "+startTime!
            showAutoStart = startTime!
            
            endDate = showDayformatter.string(for: Date())!
            endTime = showTimeformatter.string(for: Date())!
            showEnd = endDate+" "+endTime!
            showAutoEnd = endTime!
            
            btnSave.isHidden = false
            btnEdit.isHidden = true
        }
        
        autoCategory = "Tap to Choose"
        autoLocation = "Tap to Choose"
        
    }

    func loadData(){
        id = (event?.eventId)!
        name = event?.eventName
        startDate = event?.startDate
        endDate = event?.endDate
        startTime = event?.startTime
        endTime = event?.endTime
        allDay = event?.allDay
        autoRecord = event?.autoRecord
        task = event?.task
        reminder = event?.reminder
        if allDay{
            showStart = startDate
            showEnd = endDate
        }else{
            showStart = startDate+" "+startTime!
            showEnd = endDate+" "+endTime!
        }
    }
    
    //離開頁面前重新更新第一頁日曆
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let firstVC = presentingViewController as? ViewController {
            DispatchQueue.main.async {
                firstVC.calendarView.reloadData()
            }
        }
    }
    
    //判斷觸發哪個segue,把需要的variable傳過去destination Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tag = nil
        if segue.identifier == "editStartDate" {
            if let VC = segue.destination as? DatePopupViewController{
                VC.allDay = allDay
                VC.tag = "startDate"
                VC.showDate = showStart
            }}else if segue.identifier == "editEndDate" {
                if let VC = segue.destination as? DatePopupViewController{
                    VC.allDay = allDay
                    VC.tag = "endDate"
                    VC.showDate = showEnd
            }}else if segue.identifier == "editAutoStart" {
                if let VC = segue.destination as? DatePopupViewController{
                    VC.tag = "autoStart"
                    VC.showDate = showAutoStart
            }}else if segue.identifier == "editAutoEnd" {
                if let VC = segue.destination as? DatePopupViewController{
                    VC.tag = "autoEnd"
                    VC.showDate = showAutoEnd
            }}else if segue.identifier == "editTaskTime" {
                if let VC = segue.destination as? DatePopupViewController{
                    VC.tag = "taskTime"
                    VC.taskTime = taskTime
            }
    }
    
}
    //DatePopupViewController save回來後執行
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
        let VC = segue.source as? DatePopupViewController
        date = VC!.datePicker.date
        print(date)
        tag = VC?.tag
        if tag == "startDate"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
        }else if tag == "endDate"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: .none)
        }else if tag == "autoStart"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 1, section: 4)], with: .none)
        }else if tag == "autoEnd"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 1, section: 4)], with: .none)
        }else if tag == "taskTime"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 1, section: 5)], with: .none)
        }
      
    }
    
    //handle date object from DatePopupViewController
    func handletime(){
        if tag == "startDate"{
            if allDay == true{
                startDate = showDayformatter.string(from: date)
                showStart = startDate
            }else{
                startDate = showDayformatter.string(for: date)
                startTime = showTimeformatter.string(for: date)!
                showStart = startDate+" "+startTime!
            }
        }else if tag == "endDate"{
            if allDay == true{
                endDate = showDayformatter.string(from: date)
                showEnd = endDate
            }else{
                endDate = showDayformatter.string(for: date)
                endTime = showTimeformatter.string(for: date)!
                showEnd = endDate+" "+endTime!
            }
        }else if tag == "autoStart"{
            startTime = showTimeformatter.string(from: date)
            showAutoStart = startTime!
        }else if tag == "autoEnd"{
            endTime = showTimeformatter.string(from: date)
            showAutoEnd = endTime!
        }else if tag == "taskTime"{
            taskTime = showTimeformatter.string(from: date)
        }
        if showStart > showEnd {
            showEnd = showStart
        }
    }
    

    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addEventButton(_ sender: UIButton){
        //save to db
        // check 若endDateTime不為空值且小於startDateTime，顯示警告訊息
        if endDate != "" && endDate < startDate {
            let controller = UIAlertController(title: "wrong", message: "invalid EndTime", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }else {
            //若是all day，startTime、endTime儲存為nil
            if allDay == true{
                startTime = nil
                endTime = nil
            }
            //insert to database
            let modelInfo = EventModel(eventId: id, eventName: name!, startDate: startDate,startTime: startTime, endDate: endDate,endTime: endTime, allDay: allDay!, autoRecord: autoRecord!, task: task!, reminder: reminder!)
            let isSave = DBManager.getInstance().saveEvent(modelInfo)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func editEventButton(_ sender: UIButton){
        print("edit~~~")
    }
    
    
}


extension addViewController: UITableViewDataSource,UITableViewDelegate , UITextFieldDelegate {
    
   func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
        
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true && section == 4 {
            return 4
        }else if tableViewData[section].opened == true && section == 5 {
            return 2
        }else {
            return 1
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
        switch indexPath {
            case [0,0]:
                let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! nameCell
                cell.selectionStyle = .none
                return cell
            case [1,0]:
                let cell = tableView.dequeueReusableCell(withIdentifier: "startCell", for: indexPath) as! startCell
                    cell.txtStartDate.text = showStart
                return cell
            case [2,0]:
                let cell = tableView.dequeueReusableCell(withIdentifier: "endCell", for: indexPath) as! endCell
                 cell.txtEndDate.text = showEnd
                return cell
            case [3,0]:
                let cell = tableView.dequeueReusableCell(withIdentifier: "allDayCell", for: indexPath)
                cell.accessoryView = switchallDay
                switchallDay.setOn(allDay, animated: .init())
                cell.selectionStyle = .none
                return cell
            case [4,0]:
                let cell = tableView.dequeueReusableCell(withIdentifier: "autoRecordCell", for: indexPath)
                cell.accessoryView = switchAuto
                switchAuto.setOn(autoRecord, animated: .init())
                cell.selectionStyle = .none
                return cell
            case [4,1]:
                let cell = tableView.dequeueReusableCell(withIdentifier: "autoTimeCell", for: indexPath) as! autoTimeCell
                cell.txtAutoStart.text = showAutoStart
                cell.txtAutoEnd.text = showAutoEnd
                cell.selectionStyle = .none
                return cell
            case [4,2]:
                let cell = tableView.dequeueReusableCell(withIdentifier: "autoCategoryCell", for: indexPath) as! autoCategoryCell
                cell.txtAutoCategory.text = autoCategory
                cell.selectionStyle = .none
                return cell
            case [4,3]:
                let cell = tableView.dequeueReusableCell(withIdentifier: "autoLocationCell", for: indexPath) as! autoLocationCell
                cell.txtLocation.text = autoLocation
                cell.selectionStyle = .none
                return cell
            case [5,0]:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
                cell.accessoryView = switchtask
                switchtask.setOn(task, animated: .init())
                cell.selectionStyle = .none
                return cell
            case [5,1]:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskTimeCell", for: indexPath) as! taskTimeCell
                cell.txtTaskTime.text = taskTime
                cell.selectionStyle = .none
                return cell
            case [6,0]:
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
    
    //allDay Switch
    @objc func allDayOpen(_ sender: UISwitch){
        if sender.isOn == true{
            allDay = true
            showStart = startDate
            showEnd = endDate
        }else{
            allDay = false
            showStart = startDate+" "+startTime!
            showEnd = endDate+" "+endTime!
        }
        tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
        tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: .none)
    }
    
    //autoRecord Switch
    @objc func autoOpen(_ sender: UISwitch){
        var indexPaths = [IndexPath]()
        indexPaths.append([4,1])
        indexPaths.append([4,2])
        indexPaths.append([4,3])
        if sender.isOn == false{
            tableViewData[4].opened = false
            tableView.deleteRows(at: indexPaths, with: .fade)
            autoRecord = false
            task = false
        }else{
            tableViewData[4].opened = true
            tableView.insertRows(at: indexPaths, with: .fade)
            autoCategory = "Tap to Choose"
            autoLocation = "Tap to Choose"
            autoRecord = true
            task = false
        }
             }
    
    //task Switch
    @objc func taskOpen(_ sender: UISwitch){
           var indexPaths = [IndexPath]()
           indexPaths.append([5,1])
           if sender.isOn == false{
               task = false
               tableViewData[5].opened = false
               tableView.deleteRows(at: indexPaths, with: .fade)
               taskTime = nil
               autoRecord = false
           }else{
               task = true
               tableViewData[5].opened = true
               tableView.insertRows(at: indexPaths, with: .fade)
               taskTime = "01:00"
               tableView.reloadRows(at: [IndexPath.init(row: 1, section: 5)], with: .none)
               autoRecord = false
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
    
    //打開之後會做什麼事
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
//        case [0,0]:
//            <#code#>
         case [1,0]:
            performSegue(withIdentifier: "editStartDate", sender: self)
         case [2,0]:
            performSegue(withIdentifier: "editEndDate", sender: self)
//        case [3,0]:
//            <#code#>
//        case [4,0]:
//            <#code#>
         case [4,1]:
            performSegue(withIdentifier: "editAutoStart", sender: self)
            performSegue(withIdentifier: "editAutoEnd", sender: self)
         case [4,2]:
             performSegue(withIdentifier: "Category", sender: self)
         case [4,3]:
            performSegue(withIdentifier: "Map", sender: self)
//        case [5,0]:
        case [5,1]:
             performSegue(withIdentifier: "editTaskTime", sender: self)
//       case [6,0]:
//            <#code#>
        default:
            print("default")
        }
    }
    

    
    //點擊空白處鍵盤消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        name = textField.text!
        return true
    }

    }




