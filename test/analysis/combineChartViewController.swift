//
//  combineChartViewController.swift
//  test
//
//  Created by 王義甫 on 2020/7/8.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import Charts

class combineChartViewController: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var combineChart: CombinedChartView!
    @IBOutlet var segCon: UISegmentedControl!
    @IBOutlet var timeLabel: UILabel!  //顯示時長
    @IBOutlet var tableView: UITableView!
    
    var tag: String?
    var showTimeLabel: String = ""
    var date = Date()+86400
    var showDate: String = ""
    var startOfWeek = Date().startOfWeek
    var endOfWeek = Date().endOfWeek
    
    var showTrack = [TrackModel]()
    var showCategory = [CategoryModel]()
    var showCategoryStr = [String]()
    var showCategoryColor = [String]()
    var name = "Behaviors"
    var color = UIColor()
    var time = "No Analysis Data Available"
    var category: Int32!
    var segConIndex = 0
    var years: [String]!
    var currentWeek = Calendar.current.component(.weekOfYear, from: Date())
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var monthsFullName = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var monthDays: [String] = []
    var weekMonthDays: [String] = []
    var valueForWeek = [7.5, 7.0, 7.2, 5.9, 5.4, 4.5, 4.3]
    var valueForMonth_Line = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    var valueForMonth_Bar = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var valueForYear = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0]
    
    var selectedWeek: Int!
    var selectedMonth = ""
    var selectedYear = ""
    var selectedCategory: Int!
    var selectedMonthString = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    
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
    var showWeekdayformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd EEE HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    var showMonthformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        combineChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.barTintColor = color
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segCon.translatesAutoresizingMaskIntoConstraints = false
        combineChart.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        navigationItem.title = name
        
        let categoryLabel = UIButton.init(type: .custom)
        categoryLabel.setTitle("\(name)", for: .normal)
        categoryLabel.setTitleColor(UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1), for: .normal)
        categoryLabel.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        
        var years: [String] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...12{
                years.append("\(year)")
                year -= 1
            }
        }
        self.years = years

        timeLabel.text = time
        selectedWeek = currentWeek
        selectedYear = "\(currentYear)"
        selectedCategory = Int(category)
        let startWeekDay = showDayformatter.string(from: startOfWeek!)
        let endWeekDay = showDayformatter.string(from: endOfWeek!)
        showTimeLabel = "\(startWeekDay) ~ \(endWeekDay)"
        let data = CombinedChartData()
        if DBManager.getInstance().getWeekTracks_category(Year: selectedYear, Week: selectedWeek, Category: selectedCategory) != nil{
            combineChart.isHidden = false
            timeLabel.isHidden = true
            getTrackTimeWeek()
//            data.lineData = generateLineData(dataPoints: days, values: valueForWeek)
            data.barData = generateBarData(dataPoints: days, values: valueForWeek)
            combineChart.data = data
            //x axis
            combineChart.xAxis.labelPosition = .bothSided
            combineChart.xAxis.drawGridLinesEnabled = true
            combineChart.xAxis.granularityEnabled = true
            combineChart.xAxis.granularity = 1.0  //距離
            combineChart.xAxis.axisMinimum = data.xMin - 0.5
            combineChart.xAxis.axisMaximum = data.xMax + 0.5
            combineChart.xAxis.centerAxisLabelsEnabled = false
            combineChart.xAxis.labelCount = 7
            combineChart.xAxis.valueFormatter = self
        }else{
            combineChart.isHidden = true
            timeLabel.isHidden = false
        }
    
        
        showCategory = DBManager.getInstance().getAllCategory()
        for i in 0...showCategory.count-1{
            showCategoryStr.append(showCategory[i].categoryName)
            showCategoryColor.append(showCategory[i].categoryColor)
        }
    
        combineChart.delegate = self
        
        combineChart.drawGridBackgroundEnabled = false
        combineChart.drawBarShadowEnabled = false
        combineChart.highlightFullBarEnabled = false
        combineChart.doubleTapToZoomEnabled = false
        //left axis right axis
        combineChart.leftAxis.drawGridLinesEnabled = true
        combineChart.rightAxis.drawLabelsEnabled = false
        combineChart.rightAxis.drawGridLinesEnabled = false
        combineChart.leftAxis.axisMinimum = 0.0
        //legend
        combineChart.legend.enabled = false
        //description
        combineChart.chartDescription?.enabled = false
        combineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    @IBAction func segConChoose(_ sender: Any) {
        let getIndex = segCon.selectedSegmentIndex
        segConIndex = getIndex
//        if getIndex == 0{
//            timeLabel.isHidden = false
//            combineChart.isHidden = true
//            showTimeLabel = showDayformatter.string(from: Date())
        if getIndex == 0{
            let data = CombinedChartData()
            let startWeekDay = showDayformatter.string(from: startOfWeek!)
            let endWeekDay = showDayformatter.string(from: endOfWeek!)
            showTimeLabel = "\(startWeekDay) ~ \(endWeekDay)"
            selectedWeek = currentWeek
            selectedYear = "\(currentYear)"
            selectedCategory = Int(category)
            for (index, value) in valueForWeek.enumerated(){
                valueForWeek[index] = value*0
            }
            if DBManager.getInstance().getWeekTracks_category(Year: selectedYear, Week: selectedWeek, Category: selectedCategory) != nil{
                combineChart.isHidden = false
                timeLabel.isHidden = true
                getTrackTimeWeek()
//                data.lineData = generateLineData(dataPoints: days, values: valueForWeek)
                data.barData = generateBarData(dataPoints: days, values: valueForWeek)
                combineChart.data = data
                //x axis
                combineChart.xAxis.labelPosition = .bothSided
                combineChart.xAxis.drawGridLinesEnabled = true
                combineChart.xAxis.granularityEnabled = true
                combineChart.xAxis.granularity = 1.0  //距離
                combineChart.xAxis.axisMinimum = data.xMin - 0.5
                combineChart.xAxis.axisMaximum = data.xMax + 0.5
                combineChart.xAxis.centerAxisLabelsEnabled = false
                combineChart.xAxis.labelCount = 7
                combineChart.xAxis.valueFormatter = self
            }else{
                combineChart.isHidden = true
                timeLabel.isHidden = false
            }
        }else if getIndex == 1{
            showTimeLabel = monthsFullName[currentMonth - 1] + " \(currentYear)"
            selectedMonth = "\(currentMonth)"
            selectedYear = "\(currentYear)"
            selectedCategory = Int(category)
            for (index, value) in valueForMonth_Bar.enumerated(){
                valueForMonth_Bar[index] = value*0
            }
            let data = CombinedChartData()
            let dateComponents = DateComponents(year: currentYear, month: currentMonth)
            let dateMonthYear = Calendar.current.date(from: dateComponents)!
            let range = Calendar.current.range(of: .day, in: .month, for: dateMonthYear)!
            let numDays = range.count
            var dayOfMonth = 1
            for (_, _) in monthDays.enumerated(){
                monthDays = []
            }
            for _ in 1...numDays{
                monthDays.append("\(dayOfMonth)")
                dayOfMonth += 1
            }
            if DBManager.getInstance().getMonthTracks_category(Year: selectedYear, Month: selectedMonth, Category: selectedCategory) != nil{
                timeLabel.isHidden = true
                combineChart.isHidden = false
                getTrackTimeMonth_Bar()
                getTrackTimeMonth_Line()
                data.lineData = generateLineData(dataPoints: monthDays, values: valueForMonth_Line)
//                data.barData = generateBarData(dataPoints: monthDays, values: valueForMonth_Bar)
                combineChart.data = data
                //x axis
                combineChart.xAxis.labelPosition = .bothSided
                combineChart.xAxis.drawGridLinesEnabled = true
                combineChart.xAxis.granularityEnabled = true
                combineChart.xAxis.granularity = 1.0  //距離
                combineChart.xAxis.axisMinimum = data.xMin - 0.5
                combineChart.xAxis.axisMaximum = data.xMax + 0.5
                combineChart.xAxis.centerAxisLabelsEnabled = false
                combineChart.xAxis.labelCount = numDays+1
                combineChart.xAxis.valueFormatter = self
            }else{
                timeLabel.isHidden = false
                combineChart.isHidden = true
            }
        }else if getIndex == 2{
            showTimeLabel = "\(currentYear)"
            let data = CombinedChartData()
            selectedYear = "\(currentYear)"
            selectedCategory = Int(category)
            for (index, value) in valueForYear.enumerated(){
                valueForYear[index] = value*0
            }
            if DBManager.getInstance().getYearTracks_category(Year: selectedYear, Category: selectedCategory) != nil{
                combineChart.isHidden = false
                timeLabel.isHidden = true
//                getTrackTimeYear()
//                data.lineData = generateLineData(dataPoints: months, values: valueForYear)
                data.barData = generateBarData(dataPoints: months, values: valueForYear)
                combineChart.data = data
                //x axis
                combineChart.xAxis.labelPosition = .bothSided
                combineChart.xAxis.drawGridLinesEnabled = true
                combineChart.xAxis.granularityEnabled = true
                combineChart.xAxis.granularity = 1.0  //距離
                combineChart.xAxis.axisMinimum = data.xMin - 0.5
                combineChart.xAxis.axisMaximum = data.xMax + 0.5
                combineChart.xAxis.centerAxisLabelsEnabled = false
                combineChart.xAxis.labelCount = 13
                combineChart.xAxis.valueFormatter = self
            }else{
                combineChart.isHidden = true
                timeLabel.isHidden = false
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "combineChartTableViewCell", for: indexPath) as! combineChartTableViewCell
        cell.dateLabel.text = showTimeLabel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if segConIndex == 0{
//            performSegue(withIdentifier: "combineChartDatePopUp", sender: self)
//        }else
        if segConIndex == 0{
            performSegue(withIdentifier: "combineChartWeek", sender: self)
        }else if segConIndex == 1{
            performSegue(withIdentifier: "combineChartMonthYear", sender: self)
        }else if segConIndex == 2{
            performSegue(withIdentifier: "combineChartYear", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getTrackTimeWeek(){
        showTrack = DBManager.getInstance().getWeekTracks_category(Year: selectedYear, Week: selectedWeek, Category: selectedCategory)
        var startWeek = ""
        var endWeek = ""
        for i in 0...showTrack.count-1{
            startWeek = "\(showTrack[i].startDate) \(showTrack[i].startTime)"
            endWeek = "\(showTrack[i].endDate) \(showTrack[i].endTime)"
            
            let startStringDate = showDayformatter.date(from: showTrack[i].startDate)!
            let endStringDate = showDayformatter.date(from: showTrack[i].endDate)!
            let startWeekday = Calendar.current.component(.weekday, from: startStringDate)
            let endWeekday = Calendar.current.component(.weekday, from: endStringDate)
            
            guard let year = Int(selectedYear), let weekOfYear = selectedWeek else {return}
            let components = DateComponents(weekOfYear: weekOfYear+1, yearForWeekOfYear: year)
            guard let date = Calendar.current.date(from: components) else {return}
            let s = showDayformatter.string(from: date)
            var dateComponent = DateComponents()
            dateComponent.day = 6
            let end = Calendar.current.date(byAdding: dateComponent, to: date)
            let e = showDayformatter.string(from: end!)
            if i == 0{
                if startWeek.contains("\(s)") == false{
                    startWeek = "\(s) 00:00"
                }
            }
            if i == showTrack.count-1{
                if endWeek.contains("\(e)") == false{
                    endWeek = "\(e) 23:59"
                }
            }
            if i != 0 && i != showTrack.count-1{
                if startWeekday != endWeekday{
                    if showTrack[i].endTime != "23:59"{
                        startWeek = "\(showTrack[i].startDate) \(showTrack[i].startTime)"
                        endWeek = "\(showTrack[i].startDate) 23:59"
                    }
                }
            }
            
            let trackTimeWeek = round(10*(showDateformatter.date(from: endWeek)?.timeIntervalSince(showDateformatter.date(from: startWeek)!))!/3600)/10
            valueForWeek.enumerated().forEach{index, value in
                if showTrack[i].weekDay-1 == index{ //把日期轉成weekday
                    if startWeekday != endWeekday{
                        if showTrack[i].startTime != "00:00"{
                            startWeek = "\(showTrack[i].endDate) 00:00"
                            endWeek = "\(showTrack[i].endDate) \(showTrack[i].endTime)"
                        }
                        valueForWeek[Int(showTrack[i].weekDay)] += round(10*(showDateformatter.date(from: endWeek)?.timeIntervalSince(showDateformatter.date(from: startWeek)!))!/3600)/10
                    }
                    valueForWeek[index] += (trackTimeWeek).rounding(toDecimal: 1)
                }
            }
        }
    }
    
    func getTrackTimeMonth_Line(){
        showTrack = DBManager.getInstance().getMonthTracks_category(Year: selectedYear, Month: selectedMonth, Category: selectedCategory)
        var startMonth = ""
        var endMonth = ""
        let monthSelected = selectedYear+"-"+selectedMonth
        for i in 0...showTrack.count-1{
            startMonth = "\(showTrack[i].startDate) \(showTrack[i].startTime)"
            endMonth = "\(showTrack[i].endDate) \(showTrack[i].endTime)"
            
            let startStringDate = showDayformatter.date(from: showTrack[i].startDate)!
            let endStringDate = showDayformatter.date(from: showTrack[i].endDate)!
            let startWeekday = Calendar.current.component(.weekday, from: startStringDate)
            let endWeekday = Calendar.current.component(.weekday, from: endStringDate)
            
            if i == 0{
                if startMonth.contains("\(selectedYear)-\(selectedMonth)") == false{
                    startMonth = "\(showTrack[i].endDate) 00:00"
                }
            }
            if i == showTrack.count-1{
                if endMonth.contains("\(selectedYear)-\(selectedMonth)") == false{
                    endMonth = "\(showTrack[i].startDate) 23:59"
                }
            }
            
            if i != 0 && i != showTrack.count-1{
                if startWeekday != endWeekday{
                    if showTrack[i].endTime != "23:59"{
                        startMonth = "\(showTrack[i].startDate) \(showTrack[i].startTime)"
                        endMonth = "\(showTrack[i].startDate) 23:59"
                    }
                }
            }
            
            if showTrack[i].startDate.contains("-\(selectedMonth)-") == false{
                let components = NSCalendar.current.dateComponents(Set<Calendar.Component>([.year, .month]),from: showMonthformatter.date(from: monthSelected)!)
                let s = NSCalendar.current.date(from: components)!
                startMonth = showDateformatter.string(from: s)
            }
            if showTrack[i].endDate.contains("-\(selectedMonth)-") == false{
                var com = DateComponents()
                com.month = 1
                com.second = -1
                let e = NSCalendar.current.date(byAdding: com, to: showMonthformatter.date(from: monthSelected)!)!
                endMonth = showDateformatter.string(from: e)
            }
            let trackTimeMonth = round(10*(showDateformatter.date(from: endMonth)?.timeIntervalSince(showDateformatter.date(from: startMonth)!))!/3600)/10
            print(trackTimeMonth)
            valueForMonth_Line.enumerated().forEach{index, value in
                if showTrack[i].startDate.contains("\(selectedYear)-\(selectedMonth)-\(index+1)"){
                    if startWeekday != endWeekday{
                        if showTrack[i].startTime != "00:00"{
                            startMonth = "\(showTrack[i].endDate) 00:00"
                            endMonth = "\(showTrack[i].endDate) \(showTrack[i].endTime)"
                        }
                        valueForMonth_Line[Int(showTrack[i].weekDay)] += round(10*(showDateformatter.date(from: endMonth)?.timeIntervalSince(showDateformatter.date(from: startMonth)!))!/3600)/10
                    }
                    valueForMonth_Line[index] += (trackTimeMonth).rounding(toDecimal: 1)
                }
            }
        }
    }
    
    func getTrackTimeMonth_Bar(){
        showTrack = DBManager.getInstance().getWeekTracks_category(Year: selectedYear, Week: selectedWeek, Category: selectedCategory)
        var startWeek = ""
        var endWeek = ""
        for i in 0...showTrack.count-1{
            startWeek = "\(showTrack[i].startDate) \(showTrack[i].startTime)"
            endWeek = "\(showTrack[i].endDate) \(showTrack[i].endTime)"
            
            let startStringDate = showDayformatter.date(from: showTrack[i].startDate)!
            let endStringDate = showDayformatter.date(from: showTrack[i].endDate)!
            let startWeekday = Calendar.current.component(.weekday, from: startStringDate)
            let endWeekday = Calendar.current.component(.weekday, from: endStringDate)
            let week = Calendar.current.component(.weekOfMonth, from: startStringDate)
            print(week)
            
            guard let year = Int(selectedYear), let weekOfYear = selectedWeek else {return}
            let components = DateComponents(weekOfYear: weekOfYear+1, yearForWeekOfYear: year)
            guard let date = Calendar.current.date(from: components) else {return}
            let s = showDayformatter.string(from: date)
            var dateComponent = DateComponents()
            dateComponent.day = 6
            let end = Calendar.current.date(byAdding: dateComponent, to: date)
            let e = showDayformatter.string(from: end!)
            if i == 0{
                if startWeek.contains("\(s)") == false{
                    startWeek = "\(s) 00:00"
                }
            }
            if i == showTrack.count-1{
                if endWeek.contains("\(e)") == false{
                    endWeek = "\(e) 23:59"
                }
            }
            if i != 0 && i != showTrack.count-1{
                if startWeekday != endWeekday{
                    if showTrack[i].endTime != "23:59"{
                        startWeek = "\(showTrack[i].startDate) \(showTrack[i].startTime)"
                        endWeek = "\(showTrack[i].startDate) 23:59"
                    }
                }
            }
            
            let trackTimeWeek = round(10*(showDateformatter.date(from: endWeek)?.timeIntervalSince(showDateformatter.date(from: startWeek)!))!/3600)/10
            valueForMonth_Bar.enumerated().forEach{index, value in
                if showTrack[i].weekDay-1 == index{ //把日期轉成weekday
                    if startWeekday != endWeekday{
                        if showTrack[i].startTime != "00:00"{
                            startWeek = "\(showTrack[i].endDate) 00:00"
                            endWeek = "\(showTrack[i].endDate) \(showTrack[i].endTime)"
                        }
                        valueForMonth_Bar[Int(showTrack[i].weekDay)] += round(10*(showDateformatter.date(from: endWeek)?.timeIntervalSince(showDateformatter.date(from: startWeek)!))!/3600)/10
                    }
                    valueForMonth_Bar[index] += (trackTimeWeek).rounding(toDecimal: 1)
                }
            }
        }
    }
    
    func getTrackTimeYear(){
        showTrack = DBManager.getInstance().getMonthTracks_category(Year: selectedYear, Month: selectedMonth, Category: selectedCategory)
        var startYear = ""
        var endYear = ""
        let monthSelect = selectedYear+"-"+selectedMonth
        for i in 0...showTrack.count-1{
            startYear = "\(showTrack[i].startDate) \(showTrack[i].startTime)"
            endYear = "\(showTrack[i].endDate) \(showTrack[i].endTime)"
            
            let startStringDate = showDayformatter.date(from: showTrack[i].startDate)!
            let endStringDate = showDayformatter.date(from: showTrack[i].endDate)!
            let startWeekday = Calendar.current.component(.weekday, from: startStringDate)
            let endWeekday = Calendar.current.component(.weekday, from: endStringDate)
            
            if i == 0{
                if startYear.contains("\(selectedYear)-\(selectedMonth)") == false{
                    startYear = "\(showTrack[i].endDate) 00:00"
                }
            }
            if i == showTrack.count-1{
                if endYear.contains("\(selectedYear)-\(selectedMonth)") == false{
                    endYear = "\(showTrack[i].startDate) 23:59"
                }
            }
            
            if i != 0 && i != showTrack.count-1{
                if startWeekday != endWeekday{
                    if showTrack[i].endTime != "23:59"{
                        startYear = "\(showTrack[i].startDate) \(showTrack[i].startTime)"
                        endYear = "\(showTrack[i].startDate) 23:59"
                    }
                }
            }
            
            if showTrack[i].startDate.contains("-\(selectedMonth)-") == false{
                let components = NSCalendar.current.dateComponents(Set<Calendar.Component>([.year, .month]),from: showMonthformatter.date(from: monthSelect)!)
                let s = NSCalendar.current.date(from: components)!
                startYear = showDateformatter.string(from: s)
            }
            if showTrack[i].endDate.contains("-\(selectedMonth)-") == false{
                var com = DateComponents()
                com.month = 1
                com.second = -1
                let e = NSCalendar.current.date(byAdding: com, to: showMonthformatter.date(from: monthSelect)!)!
                endYear = showDateformatter.string(from: e)
            }
            let trackTimeMonth = round(10*(showDateformatter.date(from: endYear)?.timeIntervalSince(showDateformatter.date(from: startYear)!))!/3600)/10
            print(trackTimeMonth)
            valueForYear.enumerated().forEach{index, value in
                if showTrack[i].startDate.contains("\(selectedYear)-\(selectedMonth)"){
                    if startWeekday != endWeekday{
                        if showTrack[i].startTime != "00:00"{
                            startYear = "\(showTrack[i].endDate) 00:00"
                            endYear = "\(showTrack[i].endDate) \(showTrack[i].endTime)"
                        }
                        valueForYear[Int(showTrack[i].weekDay)] += round(10*(showDateformatter.date(from: endYear)?.timeIntervalSince(showDateformatter.date(from: startYear)!))!/3600)/10
                    }
                    valueForYear[index] = (value+trackTimeMonth).rounding(toDecimal: 1)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tag = nil
        if (segue.identifier == "combineChartDatePopUp"){
            if let vc = segue.destination as? DatePopupViewController{
                vc.tag = "combineChart"
                vc.showDate = showDayformatter.date(from: showTimeLabel)!
            }
        }
        if (segue.identifier == "combineChartMonthYear"){
            if let vc = segue.destination as? PickerViewController{
                vc.tag = "combineChartMonthYear"
            }
        }
        if (segue.identifier == "combineChartYear"){
            if let vc = segue.destination as? PickerViewYearController{
                vc.tag = "combineChartYear"
            }
        }
        if (segue.identifier == "combineChartWeek"){
            if let vc = segue.destination as? PickerViewWeekViewController{
                vc.tag = "combineChartWeek"
            }
        }
    }
    
    @IBAction func TimeSegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "timeSegueBack"{
//            if segConIndex == 0{
//                let vc = segue.source as? DatePopupViewController
//                date = vc!.datePicker.date
//                tag = vc?.tag
//                if tag == "combineChart"{
//                    showCategory = DBManager.getInstance().getAllCategory()
//                    showTimeLabel = showDayformatter.string(from: date)
//                }
//            }else
            if segConIndex == 0{
                let vc = segue.source as? PickerViewWeekViewController
                tag = vc?.tag
                if tag == "combineChartWeek"{
                    let data = CombinedChartData()
                    showCategory = DBManager.getInstance().getAllCategory()
                    showTimeLabel = (vc!.pickerViewWeek.dateWeek)
                    selectedYear = "\(currentYear)"
                    selectedWeek = vc!.pickerViewWeek.week
                    selectedCategory = Int(category)
                    for (index, value) in valueForWeek.enumerated(){
                        valueForWeek[index] = value*0
                    }
                    if DBManager.getInstance().getWeekTracks_category(Year: selectedYear, Week: selectedWeek, Category: selectedCategory) != nil{
                        combineChart.isHidden = false
                        timeLabel.isHidden = true
                        getTrackTimeWeek()
                        
//                        data.lineData = generateLineData(dataPoints: days, values: valueForWeek)
                        data.barData = generateBarData(dataPoints: days, values: valueForWeek)
                        
                        combineChart.data = data
                        //x axis
                        combineChart.xAxis.labelPosition = .bothSided
                        combineChart.xAxis.drawGridLinesEnabled = true
                        combineChart.xAxis.granularityEnabled = true
                        combineChart.xAxis.granularity = 1.0  //距離
                        combineChart.xAxis.axisMinimum = data.xMin - 0.5
                        combineChart.xAxis.axisMaximum = data.xMax + 0.5
                        combineChart.xAxis.centerAxisLabelsEnabled = false
                        combineChart.xAxis.labelCount = 7
                        combineChart.xAxis.valueFormatter = self
                    }else{
                        combineChart.isHidden = true
                        timeLabel.isHidden = false
                    }
                }
            }else if segConIndex == 1{
                let vc = segue.source as? PickerViewController
                tag = vc?.tag
                if tag == "combineChartMonthYear"{
                    showTimeLabel = vc!.pickerViewMonthYear.dateMonthYear
                    if (vc?.pickerViewMonthYear.month)! < 10{
                        selectedMonth = "0\(vc!.pickerViewMonthYear.month)"
                    }else{
                        selectedMonth = "\(vc!.pickerViewMonthYear.month)"
                    }
                    selectedYear = "\(vc!.pickerViewMonthYear.year)"
                    selectedCategory = Int(category)
                    for (index, value) in valueForMonth_Bar.enumerated(){
                        valueForMonth_Bar[index] = value*0
                    }
                    let data = CombinedChartData()
                    let dateComponents = DateComponents(year: vc?.pickerViewMonthYear.year, month: vc?.pickerViewMonthYear.month)
                    let dateMonthYear = Calendar.current.date(from: dateComponents)!
                    let range = Calendar.current.range(of: .day, in: .month, for: dateMonthYear)!
                    let numDays = range.count
                    var dayOfMonth = 1
                    for (_, _) in monthDays.enumerated(){
                        monthDays = []
                    }
                    for _ in 1...numDays{
                        monthDays.append("\(dayOfMonth)")
                        dayOfMonth += 1
                    }
                    selectedWeek = 32
                    let weekRange = Calendar.current.range(of: .weekOfMonth, in: .month, for: dateMonthYear)!
                    let weekNumDays = weekRange.count
                    var weekOfMonth = 1
                    for (_, _) in weekMonthDays.enumerated(){
                        weekMonthDays = []
                    }
                    for _ in 1...weekNumDays{
                        weekMonthDays.append("\(weekOfMonth)")
                        weekOfMonth += 1
                    }
                    if DBManager.getInstance().getMonthTracks_category(Year: selectedYear, Month: selectedMonth, Category: selectedCategory) != nil{
                        timeLabel.isHidden = true
                        combineChart.isHidden = false
                        getTrackTimeMonth_Bar()
                        getTrackTimeMonth_Line()
                        data.lineData = generateLineData(dataPoints: monthDays, values: valueForMonth_Line)
//                        data.barData = generateBarData(dataPoints: weekMonthDays, values: valueForMonth_Bar)
                        combineChart.data = data
                        //x axis
                        combineChart.xAxis.labelPosition = .bothSided
                        combineChart.xAxis.drawGridLinesEnabled = true
                        combineChart.xAxis.granularityEnabled = true
                        combineChart.xAxis.granularity = 1.0  //距離
                        combineChart.xAxis.axisMinimum = data.xMin - 0.5
                        combineChart.xAxis.axisMaximum = data.xMax + 0.5
                        combineChart.xAxis.centerAxisLabelsEnabled = false
                        combineChart.xAxis.labelCount = numDays+1
                        combineChart.xAxis.valueFormatter = self
                    }else{
                        timeLabel.isHidden = false
                        combineChart.isHidden = true
                    }
                }
            }else if segConIndex == 2{
                let vc = segue.source as? PickerViewYearController
                tag = vc?.tag
                if tag == "combineChartYear"{
                    showTimeLabel = vc!.pickerViewYear.dateYear
                    let data = CombinedChartData()
                    selectedYear = "\(vc!.pickerViewYear.dateYear)"
                    selectedCategory = Int(category)
                    selectedMonth = "01"
                    for (index, value) in valueForYear.enumerated(){
                        valueForYear[index] = value*0
                    }
                    for i in selectedMonthString{
                        selectedMonth = i
                        if DBManager.getInstance().getYearTracks_category(Year: selectedYear, Category: selectedCategory) != nil{
                            combineChart.isHidden = false
                            timeLabel.isHidden = true
                            getTrackTimeYear()
    //                        data.lineData = generateLineData(dataPoints: months, values: valueForYear)
                            data.barData = generateBarData(dataPoints: months, values: valueForYear)
                            combineChart.data = data
                            //x axis
                            combineChart.xAxis.labelPosition = .bothSided
                            combineChart.xAxis.drawGridLinesEnabled = true
                            combineChart.xAxis.granularityEnabled = true
                            combineChart.xAxis.granularity = 1.0  //距離
                            combineChart.xAxis.axisMinimum = data.xMin - 0.5
                            combineChart.xAxis.axisMaximum = data.xMax + 0.5
                            combineChart.xAxis.centerAxisLabelsEnabled = false
                            combineChart.xAxis.labelCount = 13
                            combineChart.xAxis.valueFormatter = self
                        }else{
                            combineChart.isHidden = true
                            timeLabel.isHidden = false
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func generateLineData(dataPoints: [String], values: [Double]) -> LineChartData{
        var dataEntries = [ChartDataEntry]()
        for i in 0..<dataPoints.count{
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Line Chart")
        lineChartDataSet.colors = [UIColor.gray]
        lineChartDataSet.circleColors = colorsOfCategory(numbersOfColor: dataPoints.count)
        lineChartDataSet.axisDependency = .left
        
        let data = LineChartData()
        data.addDataSet(lineChartDataSet)
        return data
    }
    
    func generateBarData(dataPoints: [String], values: [Double]) -> BarChartData{
        var dataEntries = [BarChartDataEntry]()
        for i in 0..<dataPoints.count{
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "Bar Chart")
        barChartDataSet.colors = colorsOfCategory(numbersOfColor: dataPoints.count)
        barChartDataSet.valueTextColor = UIColor.black
        barChartDataSet.valueFont = NSUIFont.systemFont(ofSize: CGFloat(18.0))
        barChartDataSet.axisDependency = .left
        
        let barWidth = 0.5
        let data = BarChartData()
        data.barWidth = barWidth
        data.addDataSet(barChartDataSet)
        return data
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected : x = \(highlight.x)")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("chartValueNothingSelected")
    }
    
    private func colorsOfCategory(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0...numbersOfColor-1{
//            let color = hexStringToUIColor (hex: "\(showCategoryColor[i])")
            colors.append(color)
        }
        return colors
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(0.7)
        )
    }

}
extension combineChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if segConIndex == 0{
            let moduDay = Double(value).truncatingRemainder(dividingBy: Double(days.count))
            return days[Int(moduDay)]
        }else if segConIndex == 1{
            let moduMonth =  Double(value).truncatingRemainder(dividingBy: Double(monthDays.count))
            return monthDays[Int(moduMonth)]
        }else if segConIndex == 2{
            let moduYear =
                Double(value).truncatingRemainder(dividingBy: Double(months.count))
            return months[Int(moduYear)]
        }
        let moduMonth =  Double(value).truncatingRemainder(dividingBy: Double(years.count))
        return years[Int(moduMonth)]
        }
}
