//
//  File.swift
//  test
//
//  Created by 謝宛軒 on 2020/3/26.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

struct cellConfig{
    var opened = Bool()
    var title = String()
}

struct reminderConfig{
    var rname = String()
    var fireTime = Int()
}

class addViewController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    //tableView Item
    var tableViewData = [cellConfig]()
    var reminderData = [reminderConfig]()
    var reminderData_notallDay = [reminderConfig]()
    var reminderData_allDay = [reminderConfig]()
    let switchallDay = UISwitch()
    let switchauto = UISwitch()
    let switchreminder = UISwitch()
    
    //db variables
    var name = ""
    var startDate = "" //Only Date
    var endDate = ""
    var startTime = "" //Only time
    var endTime = ""
    var allDay: Bool! = false
    var autoRecord: Bool! = false
    var autoCategory: Int32 = 18
    var autoLocation: Int32 = 0
    var reminder =  ""
    var id: Int32 = 0
    
    var event : EventModel?
    var selectedDay: [Date] = []
    var category = CategoryModel(categoryId: 18, categoryName: "Others", categoryColor: "", category_image: "default")
    var savePlace : PlaceModel?
    //var trackModel : TrackModel?
    var oldReminder_index: [String] = [""]
    var reminder_index: [Int] = [0]
    var allDayReminder_index: [Int] = [0]
    
    //variable for handling  DatePopViewController
    var tag: String? //which? (startDate,EndDate,editTask)
    var date = Date() //date from DatePopViewController
//    var showStart: String = "" //format show out on storyboard
//    var showEnd: String = "" //format show out on storyboard
    //用來處理dayconstraint
    var s = Date()
    var e = Date()+3600
    
    let net = NetworkController()
    
    var showDateformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
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
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    var showWeekdayformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d EEE"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let btnAdd = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addEventButton(_:)))
        let btnEdit = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editEventButton(_:)))
        let btnDelete = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteEventButton(_:)))
        let btnCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItems = [btnCancel]

        //查看手機內佇列的notification
//        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
//            for request in requests {
//                print("notifi \(request)")
//            }
//        })
        //查看所有已推送的notification
//         UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: nil)
        
        tableViewData = [cellConfig(opened: false, title: "Name"),
                         cellConfig(opened: false, title: "Start"),
                         cellConfig(opened: false, title: "End"),
                         cellConfig(opened: false, title: "AllDay"),
                         cellConfig(opened: false, title: "AutoRecord"),
                         cellConfig(opened: false, title: "Reminder")]
        
       reminderData_notallDay = [reminderConfig( rname: "none", fireTime: 0),
        reminderConfig( rname: "At time of event", fireTime: 0),
        reminderConfig( rname: "5 minutes before", fireTime: 300),
        reminderConfig( rname: "10 minutes before", fireTime: 600),
        reminderConfig( rname: "30 minutes before", fireTime: 1800),
        reminderConfig( rname: "1 hour before", fireTime: 3600),
        reminderConfig( rname: "1 day before", fireTime: 86400),]
        
        reminderData_allDay = [reminderConfig( rname: "none", fireTime: 0),
        reminderConfig( rname: "on that day (default 07:00)", fireTime: -25200),
        reminderConfig( rname: "one day before (default 21:00)", fireTime: 10800),
        reminderConfig( rname: "two days before (default 21:00)", fireTime: 97200)]
        
        
        //func for accessoryView
        switchallDay.addTarget(self, action: #selector(self.allDayOpen(_ :)), for: .valueChanged)
        switchallDay.onTintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        switchauto.addTarget(self, action: #selector(self.autoOpen(_ :)), for: .valueChanged)
        switchauto.onTintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        //switchreminder.addTarget(self, action: #selector(self.reminderOpen(_ :)), for: .valueChanged)
        
        //檢查是要新增還是編輯event
        if event != nil{
            loadData()
            navigationItem.rightBarButtonItems = [btnEdit, btnDelete]
        }else {
            navigationItem.rightBarButtonItems = [btnAdd]
        }
        if selectedDay.isEmpty == false{
            s = showDateformatter.date(from: "\(showDayformatter.string(from: selectedDay[0])) \(showTimeformatter.string(from: Date()))")!
            e = showDateformatter.date(from: "\(showDayformatter.string(from: selectedDay[selectedDay.count-1])) \(showTimeformatter.string(from: Date()+3600))")!
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.5)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)]
        
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    func loadData(){
        id = event!.eventId
        name = event!.eventName
        startDate = event!.startDate
        endDate = event!.endDate
        if event!.startTime == ""{
            startTime = showTimeformatter.string(from: Date())
            endTime = showTimeformatter.string(from: Date()+3600)
        }else{
            startTime = event!.startTime
            endTime = event!.endTime
        }
        s = showDateformatter.date(from: startDate+" "+startTime)!
        e = showDateformatter.date(from: endDate+" "+endTime)!
        allDay = event!.allDay
        if event!.autoRecord == true{
            autoRecord = true
            category = DBManager.getInstance().getCategory(Int: (event?.autoCategory)!)
            savePlace = DBManager.getInstance().getPlace(Int: event!.autoLocation)
            tableViewData[4].opened = true
        }
        reminder = event!.reminder
        //reminder_index = event?.reminder.components(separatedBy: ",").map{ NSString(string: $0).integerValue } ?? [0]
        oldReminder_index = event!.reminder.components(separatedBy: ",") as [String]
        if allDay{
            allDayReminder_index = event?.reminder.components(separatedBy: ",").map{ NSString(string: $0).integerValue } ?? [0]
            oldReminder_index = oldReminder_index.map{ (index) -> String in
                return "event\(id)_allday_\(index)"
            }
        }else{
            reminder_index = event!.reminder.components(separatedBy: ",").map{ NSString(string: $0).integerValue }
                //?? [0]
            oldReminder_index = oldReminder_index.map{ (index) -> String in
                return "event\(id)_\(index)"
            }
        }
        //oldReminder_index = event?.reminder.components(separatedBy: ",").map{ NSString(string: $0).integerValue } ?? [0]
        //reminder_index = event?.reminder.components(separatedBy: ",").map { Int($0)!} as! [Int]
    }
    
    //判斷觸發哪個segue,把需要的variable傳過去destination Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tag = nil
        switch segue.identifier {
        case "newStartDate":
            if let VC = segue.destination as? DatePopupViewController{
                VC.allDay = allDay
                VC.tag = "startDate"
                VC.showDate = s
            }
        case "newEndDate":
            if let VC = segue.destination as? DatePopupViewController{
                VC.allDay = allDay
                VC.tag = "endDate"
                VC.showDate = e
            }
        case "newAutoStart":
            if let VC = segue.destination as? DatePopupViewController{
                VC.tag = "autoStart"
                VC.showDate = s
            }
        case "newAutoEnd":
            if let VC = segue.destination as? DatePopupViewController{
                VC.tag = "autoEnd"
                VC.showDate = e
            }
        case "Reminder":
            if let VC = segue.destination as? reminderTableViewController{
                VC.allDay = allDay
                if allDay{
                    VC.reminder = allDayReminder_index
                }else{
                    VC.reminder = reminder_index
                }
                print(VC.reminder)
            }
        default:
            print("")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           event = nil
           selectedDay = []
       }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "eventUnwindSegue"{
            if name == "" {
                alertMessage()
                return false
            }
        }
        return true
    }
    
    //DatePopupViewController save回來後執行
    @IBAction func TimeSegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "timeSegueBack"{
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
    }
    
    @IBAction func categorySegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "categorySegueBack"{
            let VC = segue.source as? categoryViewController
            let i = VC?.collectionView.indexPathsForSelectedItems
            category = (VC?.showCategory[i![0].row])!
            tableView.reloadRows(at: [IndexPath.init(row: 3, section: 4)], with: .none)
        }
    }
    
    @IBAction func locationSegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "locationSegueBack"{
            let VC = segue.source as? searchLocationViewController
            savePlace = VC?.savePlaceModel
            tableView.reloadRows(at: [IndexPath.init(row: 4, section: 4)], with: .none)
        }
    }
    
    @IBAction func reminderSegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "reminderSegueBack"{
            let VC = segue.source as? reminderTableViewController
            if allDay{
                allDayReminder_index = (VC?.reminder)!
            }else{
               reminder_index = (VC?.reminder)!
            }
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 5)], with: .none)
        }
    }
    
    
    //handle date object from DatePopupViewController
    func handletime(){
        let interval = e.timeIntervalSince(s)
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
            if dayConstraint(i: "end") == 1 { s = e - interval}
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
            if c1 == .orderedDescending {c = 1}
        case "end":
            if allDay == true && c4 == .orderedSame {c = 2}
            if c2 == .orderedAscending {c = 1}
        default:
            c = 0
        }
        return c
    }
    
    @objc func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addEventButton(_ sender: UIButton){
        self.view.endEditing(true)
        
        startDate = showDayformatter.string(for: s)!
        endDate = showDayformatter.string(for: e)!
        if allDay{
            startTime = ""
            endTime = ""
            reminder = allDayReminder_index.map { String($0) }.joined(separator: ",")
        }else{
            startTime = showTimeformatter.string(for: s)!
            endTime = showTimeformatter.string(for: e)!
            reminder = reminder_index.map { String($0) }.joined(separator: ",")
        }
        //reminder = reminder_index.map { String($0) }.joined(separator: ",")
        // check 若endDateTime不為空值且小於startDateTime，顯示警告訊息
        if name == ""{
            alertMessage()
        } else {
            if autoRecord {
                autoCategory = category.categoryId!
                if savePlace != nil {
                autoLocation = DBManager.getInstance().addPlace(savePlace!)
//                    let data:[String:String] = ["place_id":"0", "place_name":savePlaceModel!.placeName, "place_longitude":String(savePlaceModel!.placeLongitude), "place_latitude":String(savePlaceModel!.placeLatitude)]
//
//                    self.net.postSaveplaceData(data: data){
//                        (status_code) in
//                        if (status_code != nil) {
//                            print(status_code!)
//                        }
//                    }
                }
                //askNotification()
            }
            //insert to database
            let modelInfo = EventModel(eventId: id, eventName: name, startDate: startDate,startTime: startTime, endDate: endDate, endTime: endTime, allDay: allDay, autoRecord: autoRecord, autoCategory: autoCategory, autoLocation: autoLocation, reminder: reminder)
            DBManager.getInstance().addEvent(modelInfo)
            if reminder != "0" { makeNotification(action: "add")}
            self.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "eventUnwindSegue", sender: nil)
        }
    }
    
    @objc func editEventButton(_ sender: UIButton){
        self.view.endEditing(true)
        startDate = showDayformatter.string(for: s)!
        endDate = showDayformatter.string(for: e)!
        if allDay{
            startTime = ""
            endTime = ""
            reminder = allDayReminder_index.map { String($0) }.joined(separator: ",")
        }else{
            startTime = showTimeformatter.string(for: s)!
            endTime = showTimeformatter.string(for: e)!
            reminder = reminder_index.map { String($0) }.joined(separator: ",")
        }
        if name == ""{
            alertMessage()
        }else{
            if autoRecord == true{
                autoCategory = category.categoryId!
                if savePlace != nil{
                    autoLocation = DBManager.getInstance().addPlace(savePlace!)
                    //net
                }
                //編輯當下問是不是在做這件事的通知
            }
            let modelInfo = EventModel(eventId: id, eventName: name, startDate: startDate, startTime: startTime, endDate: endDate, endTime: endTime, allDay: allDay, autoRecord: autoRecord, autoCategory: autoCategory, autoLocation: autoLocation, reminder: reminder)
            DBManager.getInstance().editEvent(modelInfo)
            makeNotification(action: "delete")
            if reminder != "0" {makeNotification(action: "add")}
            self.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "eventUnwindSegue", sender: nil)
        }
    }
    
    @objc func deleteEventButton(_ sender: UIButton){
        let controller = UIAlertController(title: "WARNING", message: "Are you sure to delete the event", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){_ in
            controller.dismiss(animated: true, completion: nil); self.dismiss(animated: true, completion: nil); self.delete()}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){_ in controller.dismiss(animated: true, completion: nil)}
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        self.present(controller, animated: true,completion: .none)
    }
    
    func delete(){
        //reminder = reminder_index.map { String($0) }.joined(separator: ",")
        let modelInfo = EventModel(eventId: id, eventName: name, startDate: startDate, startTime: startTime, endDate: endDate, endTime: endTime, allDay: allDay, autoRecord: autoRecord, autoCategory: autoCategory, autoLocation: autoLocation, reminder: reminder)
        DBManager.getInstance().deleteEvent(id: modelInfo.eventId)
           //刪除當下問是不是在做這件事的通知
        makeNotification(action: "delete")
        performSegue(withIdentifier: "eventUnwindSegue", sender: nil)
       }
       
    //alert message
    func alertMessage(){
            let controller = UIAlertController(title: "Error", message: "Enter a name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default){_ in
                controller.dismiss(animated: true, completion: nil)}
            controller.addAction(okAction)
            self.present(controller, animated: true,completion: .none)
    }
    
    //manage the notification
    func makeNotification(action: String){
        //var notifivationids = [String]()
        var fireDate = s
        var notificationIndex = [0]
        if allDay{
            fireDate = showDateformatter.date(from: "\(showDayformatter.string(from: s)) 0:00")!
            reminderData = reminderData_allDay
            notificationIndex = allDayReminder_index
        }else{
            reminderData = reminderData_notallDay
            notificationIndex = reminder_index
        }
        switch action {
        case "add":
            let no = UNMutableNotificationContent()
                no.title = "Event Notification"
                no.body = "name: " + name + "\ntime: " + startDate + startTime
            for i in 0...notificationIndex.count-1{
                var notificationid = ""
                if event == nil{
                    notificationid = String(DBManager.getInstance().getMaxEvent())
                }else{
                    notificationid = String(event!.eventId)
                }
                //let calendar = Calendar.current
                let components = Calendar.current.dateComponents([ .hour, .minute],from: fireDate-TimeInterval(reminderData[notificationIndex[i]].fireTime))
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                if allDay{
                    notificationid = "event\(notificationid)_allday_\(notificationIndex[i])"
                }else{
                    notificationid = "event\(notificationid)_\(notificationIndex[i])"
                }
                let request = UNNotificationRequest(identifier: notificationid, content: no, trigger: trigger)
                UNUserNotificationCenter.current().add(request,withCompletionHandler: nil)
            }
        case "delete":
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: oldReminder_index)
        default:
            print("")
        }
    }
    
//    func askNotification() {
//        let yes = UNNotificationAction(identifier: "yes", title: "YES", options: [])
//        let no = UNNotificationAction(identifier: "no", title: "NO", options: [])
//        let ctgr = UNNotificationCategory(identifier: "yesOrNo", actions: [yes, no], intentIdentifiers:[] , options: [])
//        UNUserNotificationCenter.current().setNotificationCategories([ctgr])
//
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([ .hour, .minute], from: s)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
//        let content = UNMutableNotificationContent()
//        content.title = "Are you Eating?"
//        content.body = "Having dinner with family in XXX ?"
//        content.sound = UNNotificationSound.default
//        content.categoryIdentifier = "yesOrNo"
//
//        let request = UNNotificationRequest(identifier: "askNotification", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        UNUserNotificationCenter.current().add(request) { (error: Error?) in
//            if let error = error {
//                print("Errorrrrr: \(error.localizedDescription)")
//            }
//        }
//        
//        
//    }
    
    @IBAction func clearLocation(_ sender: UIButton){
        savePlace = nil
        tableView.reloadRows(at: [IndexPath.init(row: 4, section: 4)], with: .none)
    }
    
}


extension addViewController: UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
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
                cell.txtStartDate.text = showWeekdayformatter.string(from: s)
            }else{
                cell.txtStartDate.text = "\(showWeekdayformatter.string(from: s)) \(showTimeformatter.string(from: s))"
            }
            
//            if allDay == true{
//                showStart = showWeekdayformatter.string(from: s)
//            }else{
//                showStart = "\(showWeekdayformatter.string(from: s)) \(showTimeformatter.string(from: s))"
//            }
//            cell.txtStartDate.text = showStart
            return cell
        case [2,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "endCell", for: indexPath) as! endCell
            if allDay == true{
                cell.txtEndDate.text = showWeekdayformatter.string(from: e)
            }else{
                cell.txtEndDate.text = "\(showWeekdayformatter.string(from: e)) \(showTimeformatter.string(from: e))"
            }
//            if allDay == true{
//                showEnd = showWeekdayformatter.string(from: e)
//            }else{
//                showEnd = "\(showWeekdayformatter.string(from: e)) \(showTimeformatter.string(from: e))"
//            }
//            cell.txtEndDate.text = showEnd
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
            cell.txtAutoStart.text = showDateformatter.string(from: s)
            cell.selectionStyle = .none
            return cell
        case [4,2]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "autoEndCell", for: indexPath) as! autoEndCell
            cell.txtAutoEnd.text = showDateformatter.string(from: e)
            cell.selectionStyle = .none
            return cell
        case [4,3]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "autoCategoryCell", for: indexPath) as! autoCategoryCell
            cell.txtAutoCategory.text = category.categoryName
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        case [4,4]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "autoLocationCell", for: indexPath) as! autoLocationCell
            cell.txtLocation.text = savePlace?.placeName
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        case [5,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! reminderCell
            var txtReminder = ""
            if allDay == true{
                reminderData = reminderData_allDay
                for i in 0...allDayReminder_index.count-1{
                    txtReminder += "\(reminderData[allDayReminder_index[i]].rname) , "
                }
            }else{
                reminderData = reminderData_notallDay
                for i in 0...reminder_index.count-1{
                    txtReminder += "\(reminderData[reminder_index[i]].rname) , "
                }
            }
            cell.txtReminder.text = txtReminder
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
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
        tableView.reloadRows(at: [IndexPath.init(row: 0, section: 5)], with: .none)
//        if reminder_index != [0]{
//            reminder_index = [0]
//                   tableView.reloadRows(at: [IndexPath.init(row: 0, section: 5)], with: .none)
//        }
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
//    @objc func reminderOpen(_ sender: UISwitch){
//        if sender.isOn == true{
//            reminder = true
//        }else{
//            reminder = false
//        }
//    }
    
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
            performSegue(withIdentifier: "newStartDate", sender: self)
        case [2,0]:
            performSegue(withIdentifier: "newEndDate", sender: self)
        //        case [3,0]:
        //            <#code#>
        //        case [4,0]:
        //            <#code#>
        case [4,1]:
            performSegue(withIdentifier: "newAutoStart", sender: self)
        case [4,2]:
            performSegue(withIdentifier: "newAutoEnd", sender: self)
        case [4,3]:
            performSegue(withIdentifier: "newAutoCategory", sender: self)
        case [4,4]:
            performSegue(withIdentifier: "searchLocation", sender: self)
        case [5,0]:
            performSegue(withIdentifier: "Reminder", sender: self)
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



