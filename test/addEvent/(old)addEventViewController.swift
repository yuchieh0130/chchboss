////
////  addEvent.swift
////  test
////
////  Created by 謝宛軒 on 2020/3/9.
////  Copyright © 2020 AppleInc. All rights reserved.
////
//
//import Foundation
//import UIKit
//import JTAppleCalendar
//
//class addEventViewController : UIViewController, UITextFieldDelegate{
//
//
//    @IBOutlet var txtEventName: UITextField!
//    @IBOutlet var txtStartDate: UITextField!
//    @IBOutlet var txtEndDate: UITextField!
//    @IBOutlet var switchAutoRecord: UISwitch!
//    @IBOutlet var switchTask: UISwitch!
//    @IBOutlet var switchReminder: UISwitch!
//    @IBOutlet var switchAllDay: UISwitch!
//    @IBOutlet var hidetasktime: UIStackView!
//    @IBOutlet var hideautorecord: UIStackView!
//    @IBOutlet var txtAutoStart: UITextField!
//    @IBOutlet var txtAutoEnd: UITextField!
//    @IBOutlet var txtAutoCategory: UITextField!
//    @IBOutlet var txtTaskTime: UITextField!
//    @IBOutlet weak var txtLocation: UITextField!
//
//    let startDatePicker = UIDatePicker()
//    let endDatePicker = UIDatePicker()
//    let timePicker = UIDatePicker()
//    let showstarttimePicker = UIDatePicker()
//    let showendtimePicker = UIDatePicker()
//    let categoryPickerView = UIPickerView()
//
//    //存進database的變數
//    //還缺新增autorecord時需要的變數（ex.category、location）、event color
//    var startDate: String! = ""
//    var endDate: String! = ""
//    var startTime: String?
//    var endTime: String?
//    var allDay: Bool! = false
//    var autoRecord: Bool! = false
//    var task: Bool! = false
//    var taskTime: String?
//    var reminder: Bool! = false
//    var id: Int32 = 0
//
//    var event : EventModel?
//
//    //layout
//    @IBOutlet var reminderspacing: NSLayoutConstraint!
//    @IBOutlet var taskspacing: NSLayoutConstraint!
//    var constraints = [NSLayoutConstraint]()
//
//    //轉換日期格式、Dateformatter
//    var showDateformatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        formatter.timeZone = TimeZone.ReferenceType.system
//        return formatter
//    }
//    var showTimeformatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        formatter.timeZone = TimeZone.ReferenceType.system
//        return formatter
//    }
//    var showDayformatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.timeZone = TimeZone.ReferenceType.system
//        return formatter
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        startDatePicker.locale = Locale(identifier: "zh_TW")
//        startDatePicker.timeZone = TimeZone.ReferenceType.system
//        startDatePicker.addTarget(self, action: #selector(changeStartDate), for: .valueChanged) //改變日期時會執行的方法
//        txtStartDate.inputView = startDatePicker //選取startDate會呼叫startDatePicker
//        changeStartDate() //初始化今天日期
//        endDatePicker.locale = Locale(identifier: "zh_TW")
//        endDatePicker.addTarget(self, action: #selector(changeEndDate), for: .valueChanged)
//        txtEndDate.inputView = endDatePicker
//        changeEndDate()
//
//        //showstarttimePicker.datePickerMode = .dateAndTime
//        showstarttimePicker.locale = Locale(identifier: "zh_TW")
//        showstarttimePicker.addTarget(self, action: #selector(changestartshowtime), for: .valueChanged)
//        showstarttimePicker.datePickerMode = .time
//        txtAutoStart.inputView = showstarttimePicker
//
//        //showendtimePicker.datePickerMode = .dateAndTime
//        showendtimePicker.locale = Locale(identifier: "zh_TW")
//        showendtimePicker.addTarget(self, action: #selector(changeendshowtime), for: .valueChanged)
//        showendtimePicker.datePickerMode = .time
//        txtAutoEnd.inputView = showendtimePicker
//
//
//        timePicker.datePickerMode = .countDownTimer
//        timePicker.locale = Locale(identifier: "zh_TW")
//        timePicker.addTarget(self, action: #selector(changetime), for: .valueChanged)
//        timePicker.minuteInterval = 5
//        timePicker.date = showTimeformatter.date(from: "01:00")!
//        txtTaskTime.inputView = timePicker
//
//
//
//        txtAutoCategory.delegate = self
//        txtLocation.delegate = self
//
//        //txtAutoCategory.inputView = categoryPickerView
//    }
//
//    //返回上一頁時將calendarview reloadData
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if let firstVC = presentingViewController as? ViewController {
//            DispatchQueue.main.async {
//                firstVC.calendarView.reloadData()
//            }
//        }
//    }
//
//    /*startDatePicker*/
//    @objc func changeStartDate(){
//        startDate = showDayformatter.string(from: startDatePicker.date)
//        startTime = showTimeformatter.string(from: startDatePicker.date)
//        txtstartFormat()
//        txtAutoStart.text = startTime!
//        showstarttimePicker.date = startDatePicker.date
//
//        if startDatePicker.date > endDatePicker.date{
//            showendtimePicker.date = showstarttimePicker.date
//            endDatePicker.date = startDatePicker.date
//            endDate = showDayformatter.string(from: endDatePicker.date)
//            endTime = showTimeformatter.string(from: endDatePicker.date)
//            txtendFormat()
//            txtAutoEnd.text = endTime!
//        }
//    }
//
//    /*showstarttimePicker*/
//    @objc func changestartshowtime() {
//        startTime = showTimeformatter.string(from: showstarttimePicker.date)
//        txtstartFormat()
//        txtAutoStart.text = startTime!
//        startDatePicker.date = showstarttimePicker.date
//
//        if startDatePicker.date > endDatePicker.date{
//            endDatePicker.date = startDatePicker.date
//            showendtimePicker.date = showstarttimePicker.date
//            endDate = showDayformatter.string(from: showendtimePicker.date)
//            endTime = showTimeformatter.string(from: showendtimePicker.date)
//            txtendFormat()
//            txtAutoEnd.text = endTime!
//        }
//       }
//
//    /*endDatePicker*/
//    @objc func changeEndDate(){
//        endDate = showDayformatter.string(from: endDatePicker.date)
//        endTime = showTimeformatter.string(from: endDatePicker.date)
//        txtendFormat()
//        txtAutoEnd.text = endTime!
//        showendtimePicker.date = endDatePicker.date
//
//        if endDatePicker.date < startDatePicker.date{
//            startDatePicker.date = endDatePicker.date
//            showstarttimePicker.date = showendtimePicker.date
//            startDate = showDayformatter.string(from: startDatePicker.date)
//            startTime = showTimeformatter.string(from: startDatePicker.date)
//            txtstartFormat()
//            txtAutoStart.text = startTime!
//        }
//    }
//
//
//     /*showendtimePicker*/
//    @objc func changeendshowtime() {
//        endTime = showTimeformatter.string(from: showendtimePicker.date)
//        endDatePicker.date = showendtimePicker.date
//        txtendFormat()
//        txtAutoEnd.text = endTime!
//
//        if showendtimePicker.date < showstarttimePicker.date{
//            showstarttimePicker.date = showendtimePicker.date
//            startDatePicker.date = endDatePicker.date
//            startTime = showTimeformatter.string(from: showstarttimePicker.date)
//            startDate = showDayformatter.string(from: showstarttimePicker.date)
//            txtstartFormat()
//            txtAutoStart.text = startTime!
//        }
//    }
//
//    /*timePicker*/
//    @objc func changetime() {
//        taskTime = showTimeformatter.string(from: timePicker.date)
//        txtTaskTime.text = taskTime!
//    }
//
//    /*startDate txtField格式*/
//    func txtstartFormat(){
//        if allDay == true{
//            txtStartDate.text = startDate
//        }else{
//            txtStartDate.text = startDate+" "+startTime!
//        }
//    }
//
//    /*endDate txtField格式*/
//    func txtendFormat(){
//        if allDay == true{
//            txtEndDate.text = endDate
//        }else{
//            txtEndDate.text = endDate+" "+endTime!
//        }
//    }
//
//
//    /*autoRecord switch*/
//    @IBAction func autoRecord(_ sender: Any){
//        if switchAutoRecord.isOn == true{
//            switchTask.isOn = false
//            autoRecord = true
//            task = false
//            hidetasktime.isHidden = true
//            reminderspacing.constant = 39
//            hideautorecord.isHidden = false
//            taskspacing.constant = 224
//        }else{
//            autoRecord = false
//            hidetasktime.isHidden = true
//            reminderspacing.constant = 39
//            hideautorecord.isHidden = true
//            taskspacing.constant = 39
//
//        }
//    }
//    /*task switch*/
//    @IBAction func task(_ sender: Any){
//        if switchTask.isOn == true{
//            switchAutoRecord.isOn = false
//            task = true
//            autoRecord = false
//            hidetasktime.isHidden = false
//            reminderspacing.constant = 108
//            hideautorecord.isHidden = true
//            taskspacing.constant = 39
//            taskTime = "01:00"
//            txtTaskTime.text = taskTime
//
//        }else{
//            task = false
//            hidetasktime.isHidden = true
//            reminderspacing.constant = 39
//            hideautorecord.isHidden = true
//            taskspacing.constant = 39
//            taskTime = nil
//
//        }
//    }
//
//
//    /*reminder switch*/
//    @IBAction func remindar(_ sender: Any){
//        if switchReminder.isOn == true{
//            reminder = true
//        }else{
//            reminder = false
//        }
//    }
//
//    //檢查是不是allday、改變輸入的日期格式
//    @IBAction func allDay(_ sender: Any){
//        if switchAllDay.isOn == true{
//            allDay = true
//            startDatePicker.datePickerMode = .date
//            endDatePicker.datePickerMode = .date
//            showstarttimePicker.date = showTimeformatter.date(from: "09:00")!
//            startTime = "09:00"
//            txtAutoStart.text = startTime
//            showendtimePicker.date = showTimeformatter.date(from: "17:00")!
//            endTime = "17:00"
//            txtAutoEnd.text = endTime
//            txtstartFormat()
//            txtendFormat()
//        }else{
//            allDay = false
//            startDatePicker.datePickerMode = .dateAndTime
//            endDatePicker.datePickerMode = .dateAndTime
//            txtstartFormat()
//            txtendFormat()
//        }
//    }
//
//    /*add event button: save event*/
//    @IBAction func addEventButton(_ sender: UIButton){
//        // check 若endDateTime不為空值且小於startDateTime，顯示警告訊息
//        if endDate != "" && endDate < startDate {
//            let controller = UIAlertController(title: "wrong", message: "invalid EndTime", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            controller.addAction(okAction)
//            present(controller, animated: true, completion: nil)
//        }else {
//            //若是all day，startTime、endTime儲存為nil
//            if allDay == true{
//                startTime = nil
//                endTime = nil
//            }
//            //insert to database
//            let modelInfo = EventModel(eventId: id, eventName: txtEventName.text!, startDate: startDate,startTime: startTime, endDate: endDate,endTime: endTime, allDay: allDay!, autoRecord: autoRecord!, task: task!, reminder: reminder!, taskId: id)
//            let isAdded = DBManager.getInstance().addEvent(modelInfo)
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//
//    @IBAction func cancel(_ sender: UIButton){
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    //點擊return鍵盤消失
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    //點擊空白處鍵盤消失
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//
//    func textFieldDidBeginEditing( txtAutoCategory :
//        UITextField){
//        performSegue(withIdentifier: "categorySegue", sender: self)
//        txtAutoCategory.resignFirstResponder()
//    }
//
//    func textFieldDidBeginEditing( txtLocation :
//        UITextField){
//        performSegue(withIdentifier: "MapSegue", sender: self)
//        txtLocation.resignFirstResponder()
//    }
//
//
//
////    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
////
////        if segue.identifier == "MapSegue"{
////            if let VC = segue.destination as? MapViewController{
////
////            }
////        }
////
////    }
//
//}
//
