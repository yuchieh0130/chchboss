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
    
    var numberOfWeeksInYear: Int {
        let calendar = Calendar(identifier: .gregorian)
        let weekRange = calendar.range(of: .weekOfYear,
                                       in: .yearForWeekOfYear,
                                       for: Date()) // for: customDate)
        return weekRange!.count
    }
    
    var weeksArray: [String] = []
    var weeks: [String]!
    var week = Calendar.current.component(.weekOfYear, from: Date()){
        didSet{
            selectRow(week, inComponent: 0, animated: true)
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
        var dateFormat = DateFormatter()
        dateFormat.dateFormat =  "yyyy-MM-dd"
        if weeks.count == 0 {
            var week = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.weekOfYear, from: NSDate() as Date)
            for _ in 1...numberOfWeeksInYear{
                weeksArray = (1...numberOfWeeksInYear).map { "\($0)" }
                weeks = [dateFormat.string(from: Date().dateCorrespondingTo(weekNumber: Int(weeksArray[selectedRow(inComponent: 0)]) ?? 0)!-1)]
//                weeksArray.append("\(dateFormat.string(from: startWeek!-1))")
            }
        }
        self.weeks = weeks
        self.delegate = self
        self.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return weeksArray[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return weeksArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let week = self.selectedRow(inComponent: 0)
        if let block = onDateSelected {
            block(week)
        }
        
        var dateFormat = DateFormatter()
        dateFormat.dateFormat =  "yyyy-MM-dd"
        
        let sunOfWeek = Date().dateCorrespondingTo(weekNumber: Int(weeksArray[row]) ?? 0)
        let sun = dateFormat.string(from: sunOfWeek!-1)
        dateWeek = "\(sun)"
        
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
    
    func dateCorrespondingTo(weekNumber: Int) -> Date? {
        let thisCalendar = Calendar(identifier: .iso8601)
        let year = thisCalendar.component(.year, from: self)
        let dateComponents = DateComponents(calendar: thisCalendar, timeZone: TimeZone(abbreviation: "UTC"), hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: 2, weekOfYear: weekNumber, yearForWeekOfYear: year) // change the year with 2022 to test a different date
        return thisCalendar.date(from: dateComponents)
    }
}
