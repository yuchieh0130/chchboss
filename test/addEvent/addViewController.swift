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

class addViewController : UIViewController{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    //tableView Item
    var tableViewData = [cellConfig]()
    let switchallDay = UISwitch()
    let switchauto = UISwitch()
    //let switchtask = UISwitch()
    let switchreminder = UISwitch()
    
    //db variables
    var name: String?
    var startDate: String! = "" //Only Date
    var endDate: String! = ""
    var startTime: String?  //Only time
    var endTime: String?
    var allDay: Bool! = false
    var autoRecord: Bool! = false
    //var task: Bool! = false
    //var taskId: Int32?
    //var taskTime: String?
    var reminder: Bool! = false
    var id: Int32 = 0
    //var deadline: String! = ""
    
    var event : EventModel?
    var selectedDay: [Date] = []
    var category = CategoryModel(categoryId: 9, categoryName: "default", categoryColor: "Grey", category_image: "default")
    
    //variable for handling from DatePopViewController
    var tag: String? //which? (startDate,EndDate,editTask)
    var date = Date() //date from DatePopViewController
    var showStart: String = "" //format show out on storyboard
    var showEnd: String = "" //format show out on storyboard
    var autoLocation: String = ""
    
    //拿來處理dayconstraint
    var s = Date()
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
        
        tableViewData = [cellConfig(opened: false, title: "Name"),
                         cellConfig(opened: false, title: "Start"),
                         cellConfig(opened: false, title: "End"),
                         cellConfig(opened: false, title: "AllDay"),
                         cellConfig(opened: false, title: "AutoRecord"),
                         cellConfig(opened: false, title: "Reminder")]
        
        //func for accessoryView
        switchallDay.addTarget(self, action: #selector(self.allDayOpen(_ :)), for: .valueChanged)
        switchauto.addTarget(self, action: #selector(self.autoOpen(_ :)), for: .valueChanged)
        switchreminder.addTarget(self, action: #selector(self.reminderOpen(_ :)), for: .valueChanged)
        
        //檢查是要新增還是編輯event
        if event != nil{
            loadData()
            btnAdd.isHidden = true
        }else {
            btnEdit.isHidden = true
            btnDelete.isHidden = true
        }
        //print(selectedDay)
        if selectedDay.isEmpty == false{
            //時間？
            let st = showTimeformatter.string(from: Date())
            let et = showTimeformatter.string(from: Date()+3600)
            let sd = showDayformatter.string(from: selectedDay[0])
            let ed = showDayformatter.string(from: selectedDay[selectedDay.count-1])
            s = showDateformatter.date(from: sd+" "+st)!
            e = showDateformatter.date(from: ed+" "+et)!
        }
        
    }
    
    func loadData(){
        id = (event?.eventId)!
        name = event?.eventName
        startDate = event?.startDate
        endDate = event?.endDate
        if event?.startTime == nil{
            startTime = showTimeformatter.string(from: Date())
            endTime = showTimeformatter.string(from: Date()+3600)
        }else{
            startTime = event?.startTime
            endTime = event?.endTime
        }
        s = showDateformatter.date(from: startDate+" "+startTime!)!
        e = showDateformatter.date(from: endDate+" "+endTime!)!
        allDay = event?.allDay
        //編輯事件的autorecord還沒處理好
        //autoRecord = event?.autoRecord
        autoRecord = false
        reminder = event?.reminder
    }
    
    //判斷觸發哪個segue,把需要的variable傳過去destination Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tag = nil
        switch segue.identifier {
        case "editStartDate":
            if let VC = segue.destination as? DatePopupViewController{
                VC.allDay = allDay
                VC.tag = "startDate"
                VC.showDate = s
            }
        case "editEndDate":
            if let VC = segue.destination as? DatePopupViewController{
                VC.allDay = allDay
                VC.tag = "endDate"
                VC.showDate = e
            }
        case "editAutoStart":
            if let VC = segue.destination as? DatePopupViewController{
                VC.tag = "autoStart"
                VC.showDate = s
            }
        case "editAutoEnd":
            if let VC = segue.destination as? DatePopupViewController{
                VC.tag = "autoEnd"
                VC.showDate = e
            }
        default:
            print("")
        }
        
    }
    //DatePopupViewController save回來後執行
    @IBAction func TimeSegueBack(segue: UIStoryboardSegue){
        let VC = segue.source as? DatePopupViewController
        date = VC!.datePicker.date
        tag = VC?.tag
        if tag == "startDate"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: .none)
            if autoRecord{
                tableView.reloadRows(at: [IndexPath.init(row: 1, section: 4)], with: .none)
                tableView.reloadRows(at: [IndexPath.init(row: 2, section: 4)], with: .none)
            }
        }else if tag == "endDate"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: .none)
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
            if autoRecord{
                tableView.reloadRows(at: [IndexPath.init(row: 1, section: 4)], with: .none)
                tableView.reloadRows(at: [IndexPath.init(row: 2, section: 4)], with: .none)
            }
        }else if tag == "autoStart"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: .none)
            tableView.reloadRows(at: [IndexPath.init(row: 1, section: 4)], with: .none)
            tableView.reloadRows(at: [IndexPath.init(row: 2, section: 4)], with: .none)
        }else if tag == "autoEnd"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: .none)
            tableView.reloadRows(at: [IndexPath.init(row: 1, section: 4)], with: .none)
            tableView.reloadRows(at: [IndexPath.init(row: 2, section: 4)], with: .none)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        event = nil
        selectedDay = []
    }
    
    @IBAction func categorySegueBack(segue: UIStoryboardSegue){
        let VC = segue.source as? categoryViewController
        let i = VC?.collectionView.indexPathsForSelectedItems
        category = (VC?.showCategory[i![0].row])!
        tableView.reloadRows(at: [IndexPath.init(row: 3, section: 4)], with: .none)
    }
    
    
    //handle date object from DatePopupViewController
    func handletime(){
        var interval = e.timeIntervalSince(s)
        if tag == "startDate"{
            s = date
            if dayConstraint(i: "start") == 2 { e = s}
            if dayConstraint(i: "start") == 1 { e = s + interval}
            
        }else if tag == "endDate"{
            e = date
            if dayConstraint(i: "end") == 2 { s = e}
            if dayConstraint(i: "end") == 1 { s = e - interval}
        }else if tag == "autoStart"{
            s = date
            if dayConstraint(i: "start") == 1 { e = s + interval}
        }else if tag == "autoEnd"{
            e = date
            if dayConstraint(i: "start") == 1 { s = e - interval}
        }
    }
    
    func dayConstraint(i:String) -> Int{
        let c1 = s.compare(e)
        let c2 = e.compare(s)
        let c3 = showDayformatter.string(from: s).compare(showDayformatter.string(from: e))
        let c4 = showDayformatter.string(from: e).compare(showDayformatter.string(from: s))
        var c = 0
        switch i {
        case "start":
            if allDay == true && c3 == .orderedSame {c = 2}
            else if c1 == .orderedDescending {c = 1}
        case "end":
            if allDay == true && c4 == .orderedSame {c = 2}
            else if c2 == .orderedAscending {c = 1}
        default:
            c = 0
        }
        return c
    }
    
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addEventButton(_ sender: UIButton){
        //save to db
        // check 若endDateTime不為空值且小於startDateTime，顯示警告訊息
        self.view.endEditing(true)
        startDate = showDayformatter.string(for: s)
        startTime = showTimeformatter.string(for: s)!
        endDate = showDayformatter.string(for: e)
        endTime = showTimeformatter.string(for: e)!
        
        if name == nil || name == ""{
            alertMessage()
        }else {
            //若是all day，startTime、endTime儲存為nil
            if allDay == true{
                startTime = nil
                endTime = nil
            }
            //insert to database
            
            let modelInfo = EventModel(eventId: id, eventName: name!, startDate: startDate,startTime: startTime, endDate: endDate,endTime: endTime, allDay: allDay!, autoRecord: autoRecord!, reminder: reminder!)
            let isAdded = DBManager.getInstance().addEvent(modelInfo)
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func editEventButton(_ sender: UIButton){
        self.view.endEditing(true)
        
        if name == nil || name == ""{
            alertMessage()
        }else{
            startDate = showDayformatter.string(for: s)
            startTime = showTimeformatter.string(for: s)!
            endDate = showDayformatter.string(for: e)
            endTime = showTimeformatter.string(for: e)!
            if allDay == true{
                startTime = nil
                endTime = nil
            }
            
            let modelInfo = EventModel(eventId: id, eventName: name!, startDate: startDate,startTime: startTime, endDate: endDate,endTime: endTime, allDay: allDay!, autoRecord: autoRecord!, reminder: reminder!)
            let isEdited = DBManager.getInstance().editEvent(modelInfo)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteEventButton(_ sender: UIButton){
        let controller = UIAlertController(title: "WARNING", message: "Are you sure to delete the event", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){_ in
            controller.dismiss(animated: true, completion: nil); self.dismiss(animated: true, completion: nil); self.delete()}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){_ in controller.dismiss(animated: true, completion: nil)}
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        
        self.present(controller, animated: true,completion: .none)
        
    }
    
    func delete(){
           let modelInfo = EventModel(eventId: id, eventName: name!, startDate: startDate,startTime: startTime, endDate: endDate,endTime: endTime, allDay: allDay!, autoRecord: autoRecord!,reminder: reminder!)
           let isDeleted = DBManager.getInstance().deleteEvent(id: modelInfo.eventId!)
       }
       
    
    //alert message
    func alertMessage(){
        if name == nil || name == ""{
            let controller = UIAlertController(title: "wrong", message: "need to enter a name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default){_ in
                controller.dismiss(animated: true, completion: nil)}
            controller.addAction(okAction)
            self.present(controller, animated: true,completion: .none)
        }
    }
    
}


extension addViewController: UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[4].opened == true && section == 4 {
            return 5
        }else {
            return 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath {
        case [0,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! nameCell
            cell.txtEventName.text = name
            cell.selectionStyle = .none
            return cell
        case [1,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "startCell", for: indexPath) as! startCell
            if allDay == true{
                showStart = showWeekdayformatter.string(from: s)
            }else{
                showStart = "\(showWeekdayformatter.string(from: s)) \(showTimeformatter.string(from: s))"
            }
            cell.txtStartDate.text = showStart
            return cell
        case [2,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "endCell", for: indexPath) as! endCell
            if allDay == true{
                showEnd = showWeekdayformatter.string(from: e)
            }else{
                showEnd = "\(showWeekdayformatter.string(from: e)) \(showTimeformatter.string(from: e))"
            }
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
            cell.accessoryView = switchauto
            switchauto.setOn(autoRecord, animated: .init())
            cell.selectionStyle = .none
            return cell
        case [4,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "autoStartCell", for: indexPath) as! autoStartCell
            //            if allDay{
            //
            //                startTime = "09:00"
            //            }
            cell.txtAutoStart.text = showDateformatter.string(from: s)
            cell.selectionStyle = .none
            return cell
        case [4,2]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "autoEndCell", for: indexPath) as! autoEndCell
            //            if allDay{
            //                endTime = "17:00"
            //            }
            cell.txtAutoEnd.text = showDateformatter.string(from: e)
            cell.selectionStyle = .none
            return cell
        case [4,3]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "autoCategoryCell", for: indexPath) as! autoCategoryCell
            cell.txtAutoCategory.text = category.categoryName
            cell.selectionStyle = .none
            return cell
        case [4,4]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "autoLocationCell", for: indexPath) as! autoLocationCell
            cell.txtLocation.text = autoLocation
            cell.selectionStyle = .none
            return cell
        case [5,0]:
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
        }else{
            allDay = false
        }
        tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
        tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: .none)
    }
    
    //autoRecord Switch
    @objc func autoOpen(_ sender: UISwitch){
        
        if sender.isOn == false{
            tableViewData[4].opened = false
            changeRow(i: "autoRecord", j: "delete")
            autoRecord = false
        }else{
            tableViewData[4].opened = true
            changeRow(i: "autoRecord", j: "insert")
            autoRecord = true
            
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
    
    func changeRow(i:String,j:String){
        
        var indexA = [IndexPath]()
        indexA.append([4,1])
        indexA.append([4,2])
        indexA.append([4,3])
        indexA.append([4,4])
        switch [i,j]{
        case ["autoRecord","insert"]:
            tableView.insertRows(at: indexA, with: .fade)
        case ["autoRecord","delete"]:
            tableView.deleteRows(at: indexA, with: .fade)
        default:
            print("")
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
        case [4,2]:
            performSegue(withIdentifier: "editAutoEnd", sender: self)
        case [4,3]:
            //performSegue(withIdentifier: "Category", sender: self)
            performSegue(withIdentifier: "NewCategory", sender: self)
        case [4,4]:
            performSegue(withIdentifier: "Map", sender: self)
        //case [5,0]: reminder
        default:
            print("")
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        name = textField.text!
    }
    
    
}



