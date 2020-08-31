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
   
    var dateFormat = DateFormatter()
    var selectedRow = 0
    var numberOfWeeksInYear: Int {
        let calendar = Calendar(identifier: .gregorian)
        let weekRange = calendar.range(of: .weekOfYear,
                                       in: .yearForWeekOfYear,
                                       for: Date()) // for: customDate)
        return weekRange!.count
    }
    
    var weeksArray: [String] = []
    var weeks: [String]!
    var week = Calendar.current.component(.weekOfYear, from: Date())
    
    let startWeek = Date().startOfWeek
    let endWeek = Date().endOfWeek

    var onDateSelected: ((_ week: Int) -> Void)?
    var dateWeek = ""
    
    var selected: String {
        return UserDefaults.standard.string(forKey: "selected") ?? ""
    }
    
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
        dateFormat.dateFormat =  "yyyy-MM-dd"
//        let week = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.weekOfYear, from: NSDate() as Date)
        for week in 1...numberOfWeeksInYear{
            weeksArray = (1...numberOfWeeksInYear).map { "\($0)" }
            weeks.append("\(dateFormat.string(from: startWeek!.startDateCorrespondingTo(weekNumber: Int("\(week)")!)!)) ~ \(dateFormat.string(from: endWeek!.endDateCorrespondingTo(weekNumber: Int("\(week)")!)!))")
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
        UserDefaults.standard.set(weeks[row], forKey: "selected")
        
        let weekSelected = self.selectedRow(inComponent: 0)
        selectedRow = weekSelected
        print(weekSelected)
        if let block = onDateSelected {
            block(weekSelected)
        }
        
        dateFormat.dateFormat =  "yyyy-MM-dd"
        
        let sunOfWeek = startWeek!.startDateCorrespondingTo(weekNumber: Int(weeksArray[row])!)
        let satOfWeek = endWeek!.endDateCorrespondingTo(weekNumber: Int(weeksArray[row])!)
        let sun = dateFormat.string(from: sunOfWeek!)
        let sat = dateFormat.string(from: satOfWeek!)
        dateWeek = "\(sun) ~ \(sat)"
        
        self.week = weekSelected
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    
}
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)
    }
    
    func startDateCorrespondingTo(weekNumber: Int) -> Date? {
        let thisCalendar = Calendar(identifier: .gregorian)
        let year = thisCalendar.component(.year, from: self)
        let dateComponents = DateComponents(calendar: thisCalendar, timeZone: TimeZone(abbreviation: "UTC"), hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: 1, weekOfYear: weekNumber, yearForWeekOfYear: year)
        return thisCalendar.date(from: dateComponents)
    }
    
    func endDateCorrespondingTo(weekNumber: Int) -> Date? {
        let thisCalendar = Calendar(identifier: .gregorian)
        let year = thisCalendar.component(.year, from: self)
        let dateComponents = DateComponents(calendar: thisCalendar, timeZone: TimeZone(abbreviation: "UTC"), hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: 7, weekOfYear: weekNumber, yearForWeekOfYear: year)
        return thisCalendar.date(from: dateComponents)
    }
}
