//
//  WeekPickerView.swift
//  test
//
//  Created by 王義甫 on 2020/7/30.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class WeekPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var weeks: [String]!
    var week = Calendar.current.component(.weekOfYear, from: Date()){
        didSet{
            selectRow(week, inComponent: 0, animated: false)
        }
        
    }
    let startWeek = Date().startOfWeek
    let endWeek = Date().endOfWeek

    var onDateSelected: ((_ week: Int) -> Void)?
    var dateWeek = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        var weeks: [String] = []
        if weeks.count == 0 {
            var week = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.weekOfYear, from: NSDate() as Date)
            for _ in 1...31{
                week -= 1
            }
        }
        self.weeks = weeks
        self.delegate = self
        self.dataSource = self
        
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return weeks[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return weeks.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let week = self.selectedRow(inComponent: 0)
        if let block = onDateSelected {
            block(week)
        }
        dateWeek = "\(week)"
        
        self.week = week
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    
}
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}
