//
//  PickerViewWeek.swift
//  test
//
//  Created by 王義甫 on 2020/7/30.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class PickerViewWeekViewController: UIViewController{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var pickerViewWeek: WeekPickerView!
    
    var tag: String?
    var currentWeek = Calendar.current.component(.weekOfYear, from: Date())
    
    var dateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewWeek.translatesAutoresizingMaskIntoConstraints = false
        
        let start = dateFormat.string(from: pickerViewWeek.startWeek!)
        let end = dateFormat.string(from: pickerViewWeek.endWeek!)
        
        if tag == "analysisWeek"{
            pickerViewWeek.dateWeek = "\(start) ~ \(end)"
        }
        
        pickerViewWeek.selectRow(currentWeek-1, inComponent: 0, animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
