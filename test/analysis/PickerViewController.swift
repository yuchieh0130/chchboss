//
//  PickerViewController.swift
//  test
//
//  Created by 王義甫 on 2020/7/24.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class PickerViewController: UIViewController{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var pickerView: MonthYearPickerView!
    
    var showDate = Date()
    var tag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tag == "analysis"{
            pickerView.onDateSelected = { (month: Int, year: Int) in
                let string = String(format: "%02d/%d", month, year)
                NSLog(string)
            }
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
