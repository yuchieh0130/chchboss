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
    @IBOutlet var pickerViewMonthYear: MonthYearPickerView!
    
    var tag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewMonthYear.translatesAutoresizingMaskIntoConstraints = false
        
        if tag == "analysisMonthYear"{
            pickerViewMonthYear.dateMonthYear = "\(pickerViewMonthYear.month) \(pickerViewMonthYear.year)"
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
