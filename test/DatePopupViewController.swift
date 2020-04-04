//
//  DatePopupViewController.swift
//  test
//
//  Created by 謝宛軒 on 2020/3/26.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

//DatePicker
class DatePopupViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var btnSave: UIButton!
    
    var allDay: Bool?
    var showDate: String?
    var taskTime: String?
    var tag: String?
    
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
        
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.timeZone = TimeZone.ReferenceType.system
        
        if tag == "taskTime"{
            datePicker.datePickerMode = .countDownTimer
            datePicker.date = showTimeformatter.date(from: taskTime!)!
        }else if tag == "autoStart"{
            datePicker.datePickerMode = .time
            datePicker.date = showTimeformatter.date(from: showDate!)!
        }else if tag == "autoEnd"{
            datePicker.datePickerMode = .time
            datePicker.date = showTimeformatter.date(from: showDate!)!
        }else if allDay == true{
            datePicker.datePickerMode = .date
            datePicker.date = showDayformatter.date(from: showDate!)!
        }else{
            datePicker.datePickerMode = .dateAndTime
            datePicker.date = showDateformatter.date(from: showDate!)!
        }
        
    }
    
    
    @IBAction func btnSave(_ sender: UIButton) {
    }
    
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

