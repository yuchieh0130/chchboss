//
//  PickerViewYearViewController.swift
//  test
//
//  Created by 王義甫 on 2020/7/29.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class PickerViewYearController: UIViewController{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var pickerViewYear: YearPickerView!
    
    var tag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewYear.translatesAutoresizingMaskIntoConstraints = false
        
        if tag == "analysisYear"{
            pickerViewYear.dateYear = "\(pickerViewYear.year)"
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
