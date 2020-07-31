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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tag == "analysisWeek"{
            pickerViewWeek.dateWeek = "\(pickerViewWeek.week)"
        }
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat =  "yyyy-MM-dd"
        let start = dateFormat.string(from: pickerViewWeek.startWeek!)
        let end = dateFormat.string(from: pickerViewWeek.endWeek!)
        
        print(pickerViewWeek.week)
        print(start)
        print(end)
        
        pickerViewWeek.selectRow(currentWeek-1, inComponent: 0, animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
