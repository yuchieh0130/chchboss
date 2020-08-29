//
//  analysisViewController.swift
//  test
//
//  Created by 王義甫 on 2020/4/28.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import Floaty
import Charts

class analysisViewController: UIViewController, ChartViewDelegate, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var segCon: UISegmentedControl!
    @IBOutlet var pieChart: PieChartView! //pieChartToday
    @IBOutlet var pieChartWeek: PieChartView!
    @IBOutlet var pieChartMonth: PieChartView!
    @IBOutlet var pieChartYear: PieChartView!
    @IBOutlet var noDataLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var showTimeLabel: String = ""
    
    var showCategory = [CategoryModel]()
    var showCategoryStr = [String]()
    var showCategoryColor = [String]()

    var showTrack = [TrackModel]()
    var hours = [String]()
    var track :TrackModel?
    var categoryName = ""
    
    var valuesDay = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var valuesWeek = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var valuesMonth = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var valuesYear = [70.0, 67.0, 89.0, 74.0, 44.0, 12.0, 5.0, 90.0, 0.0, 60.0, 9.0, 0.0, 26.0, 0.0, 95.0, 54.0, 64.0, 87.0]
    //for chart selected view
    var indexDay = 0
    var indexWeek = 0
    var indexMonth = 0
    var indexYear = 0
    var segConIndex = 0
    
    var selectedDay = ""
    var selectedWeek: Int!
    var selectedMonth = ""
    var selectedYear = ""
    
    var currentDate = ""
    var currentWeek = Calendar.current.component(.weekOfYear, from: Date())
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var currentDay = Calendar.current.component(.day, from: Date())
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var startOfWeek = Date().startOfWeek
    var endOfWeek = Date().endOfWeek
    var startWeekDay = ""
    var endWeekDay = ""
    var numberOfWeeksInYear: Int {
        let calendar = Calendar(identifier: .gregorian)
        let weekRange = calendar.range(of: .weekOfYear,
                                       in: .yearForWeekOfYear,
                                       for: Date()) // for: customDate)
        return weekRange!.count
    }
    
    var tag: String?
    var date = Date()+86400
    var showDate: String = ""
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Analysis"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.navigationController?.navigationBar.shadowImage = UIImage()
        segCon.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChartWeek.translatesAutoresizingMaskIntoConstraints = false
        pieChartMonth.translatesAutoresizingMaskIntoConstraints = false
        pieChartYear.translatesAutoresizingMaskIntoConstraints = false
//        let categoryTotal = values0.reduce(0, +)
//        total = categoryTotal
//        let categoryPercentage = values0.map{(round(($0/total)*1000))/10}
//        percentage = categoryPercentage
//
//        會直接取代原本array裡面的value
//        for (index, value) in categoryValues.enumerated(){
//            print("Item \(index + 1): \((round((value/total)*1000))/10)")
//        }
//        categoryPercentage.enumerated().forEach{index, value in
//            categoryPercentage[index] = (round((value/total)*1000))/10
//        }

        showCategory = DBManager.getInstance().getAllCategory()
        for i in 0...showCategory.count-2{
            showCategoryStr.append(showCategory[i].categoryName)
            showCategoryColor.append(showCategory[i].categoryColor)
        }
        currentDate = showDayformatter.string(from: Date())
        showTimeLabel = currentDate
        selectedDay = "\(showTimeLabel)"
        for (index, value) in valuesDay.enumerated(){
            valuesDay[index] = value*0
        }
        if DBManager.getInstance().getDateTracks(String: selectedDay) != nil{
            getTrackTime()
            customizeCategoryChart(dataPoints: showCategoryStr, values: valuesDay)
            pieChart.isHidden = false
            noDataLabel.isHidden = true
        }else{
            showTrack = [TrackModel]()
            customizeCategoryChart(dataPoints: showCategoryStr, values: valuesDay)
            pieChart.isHidden = true
            noDataLabel.isHidden = false
        }
        pieChartWeek.isHidden = true
        pieChartMonth.isHidden = true
        pieChartYear.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool){
        if DBManager.getInstance().getDateTracks(String: selectedDay) != nil{
            showTrack = DBManager.getInstance().getDateTracks(String: selectedDay)
        }else{
            showTrack = [TrackModel]()
        }
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    @IBAction func segConChoose(_ sender: Any) {
        let getIndex = segCon.selectedSegmentIndex
        segConIndex = getIndex
        if getIndex == 0{
            pieChartWeek.isHidden = true
            pieChartMonth.isHidden = true
            pieChartYear.isHidden = true
            currentDate = showDayformatter.string(from: Date())
            showTimeLabel = currentDate
            selectedDay = "\(showTimeLabel)"
            for (index, value) in valuesDay.enumerated(){
                valuesDay[index] = value*0
            }
            showCategoryStr.enumerated().forEach{index, value in
                showCategoryStr = [String]()
            }
            for i in 0...showCategory.count-2{
                showCategoryStr.append(showCategory[i].categoryName)
            }
            if DBManager.getInstance().getDateTracks(String: selectedDay) != nil{
                getTrackTime()
                showCategoryStr.enumerated().forEach{index, value in
                    if valuesDay[index] == 0.0{
                        showCategoryStr[index] = ""
                    }
                }
                customizeCategoryChart(dataPoints: showCategoryStr, values: valuesDay)
                pieChart.isHidden = false
                noDataLabel.isHidden = true
            }else{
                showTrack = [TrackModel]()
                customizeCategoryChart(dataPoints: showCategoryStr, values: valuesDay)
                pieChart.isHidden = true
                noDataLabel.isHidden = false
            }
        }else if getIndex == 1{
            customizeCategoryChartWeek(dataPoints: showCategoryStr, values: valuesWeek)
            pieChart.isHidden = true
            pieChartWeek.isHidden = false
            pieChartMonth.isHidden = true
            pieChartYear.isHidden = true
            noDataLabel.isHidden = true
            startWeekDay = showDayformatter.string(from: startOfWeek!)
            endWeekDay = showDayformatter.string(from: endOfWeek!)
            showTimeLabel = "\(startWeekDay) ~ \(endWeekDay)"
            showCategory = DBManager.getInstance().getAllCategory()
            selectedYear = "\(currentYear)"
            selectedWeek = currentWeek
            for (index, value) in valuesWeek.enumerated(){
                valuesWeek[index] = value*0
            }
            showCategoryStr.enumerated().forEach{index, value in
                showCategoryStr = [String]()
            }
            for i in 0...showCategory.count-2{
                showCategoryStr.append(showCategory[i].categoryName)
            }
            if DBManager.getInstance().getWeekTracks(year: selectedYear, week: selectedWeek) != nil{
                getTrackTimeWeek()
                showCategoryStr.enumerated().forEach{index, value in
                    if valuesWeek[index] == 0.0{
                        showCategoryStr[index] = ""
                    }
                }
                customizeCategoryChartWeek(dataPoints: showCategoryStr, values: valuesWeek)
                pieChartWeek.isHidden = false
                noDataLabel.isHidden = true
            }else{
                showTrack = [TrackModel]()
                customizeCategoryChartWeek(dataPoints: showCategoryStr, values: valuesWeek)
                pieChartWeek.isHidden = true
                noDataLabel.isHidden = false
            }
        }else if getIndex == 2{
            pieChart.isHidden = true
            pieChartWeek.isHidden = true
            pieChartYear.isHidden = true
            showTimeLabel = months[currentMonth - 1] + " \(currentYear)"
            selectedYear = "\(currentYear)"
            if currentMonth < 10{
                selectedMonth = "0\(currentMonth)"
            }else{
                selectedMonth = "\(currentMonth)"
            }
            for (index, value) in valuesMonth.enumerated(){
                valuesMonth[index] = value*0
            }
            showCategoryStr.enumerated().forEach{index, value in
                showCategoryStr = [String]()
            }
            for i in 0...showCategory.count-2{
                showCategoryStr.append(showCategory[i].categoryName)
            }
            if DBManager.getInstance().getMonthTracks(Year: selectedYear, Month: selectedMonth) != nil{
                getTrackTimeMonth()
                showCategoryStr.enumerated().forEach{index, value in
                    if valuesMonth[index] == 0.0{
                        showCategoryStr[index] = ""
                    }
                }
                customizeCategoryChartMonth(dataPoints: showCategoryStr, values: valuesMonth)
                pieChartMonth.isHidden = false
                noDataLabel.isHidden = true
            }else{
                showTrack = [TrackModel]()
                customizeCategoryChartMonth(dataPoints: showCategoryStr, values: valuesMonth)
                pieChartMonth.isHidden = true
                noDataLabel.isHidden = false
            }
        }else if getIndex == 3{
            customizeCategoryChartYear(dataPoints: showCategoryStr, values: valuesYear)
            pieChart.isHidden = true
            pieChartWeek.isHidden = true
            pieChartMonth.isHidden = true
            pieChartYear.isHidden = false
            noDataLabel.isHidden = true
            showTimeLabel = "\(currentYear)"
        }
        self.tableView.reloadData()
    }
    
    func customizeCategoryChart(dataPoints: [String], values: [Double]) {
        pieChart.delegate = self
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCategory(numbersOfColor: dataPoints.count)
        pieChartDataSet.sliceSpace = 5
        pieChartDataSet.xValuePosition = .insideSlice
        pieChartDataSet.selectionShift = 10
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        pieChartData.setValueTextColor(UIColor.black)
        // 4. Assign it to the chart’s data
        pieChart.data = pieChartData
        
        pieChart.rotationAngle = 0
        pieChart.entryLabelColor = UIColor.black
        pieChart.drawEntryLabelsEnabled = true
        pieChart.usePercentValuesEnabled = false
        pieChart.transparentCircleRadiusPercent = 0.0
        pieChart.legend.enabled = false
        pieChart.holeRadiusPercent = 0.35
    }
    
    func customizeCategoryChartWeek(dataPoints: [String], values: [Double]) {
        pieChartWeek.delegate = self
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCategory(numbersOfColor: dataPoints.count)
        pieChartDataSet.sliceSpace = 5
        pieChartDataSet.xValuePosition = .insideSlice
        pieChartDataSet.selectionShift = 10
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        pieChartData.setValueTextColor(UIColor.black)
        // 4. Assign it to the chart’s data
        pieChartWeek.data = pieChartData
        
        pieChartWeek.rotationAngle = 0
        pieChartWeek.entryLabelColor = UIColor.black
        pieChartWeek.drawEntryLabelsEnabled = false
        pieChartWeek.usePercentValuesEnabled = true
        pieChartWeek.transparentCircleRadiusPercent = 0.0
        pieChartWeek.legend.enabled = false
        pieChartWeek.holeRadiusPercent = 0.35
    }
    
    func customizeCategoryChartMonth(dataPoints: [String], values: [Double]) {
        pieChartMonth.delegate = self
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCategory(numbersOfColor: dataPoints.count)
        pieChartDataSet.sliceSpace = 5
        pieChartDataSet.xValuePosition = .insideSlice
        pieChartDataSet.selectionShift = 10
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        pieChartData.setValueTextColor(UIColor.black)
        // 4. Assign it to the chart’s data
        pieChartMonth.data = pieChartData
        
        pieChartMonth.rotationAngle = 0
        pieChartMonth.entryLabelColor = UIColor.black
        pieChartMonth.drawEntryLabelsEnabled = false
        pieChartMonth.usePercentValuesEnabled = true
        pieChartMonth.drawCenterTextEnabled = true
        pieChartMonth.transparentCircleRadiusPercent = 0.0
        pieChartMonth.legend.enabled = false
        pieChartMonth.holeRadiusPercent = 0.7
    }
    
    func customizeCategoryChartYear(dataPoints: [String], values: [Double]) {
        pieChartYear.delegate = self
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCategory(numbersOfColor: dataPoints.count)
        pieChartDataSet.sliceSpace = 5
        pieChartDataSet.xValuePosition = .insideSlice
        pieChartDataSet.selectionShift = 10
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        pieChartData.setValueTextColor(UIColor.black)
        // 4. Assign it to the chart’s data
        pieChartYear.data = pieChartData
        
        pieChartYear.rotationAngle = 0
        pieChartYear.entryLabelColor = UIColor.black
        pieChartYear.drawEntryLabelsEnabled = false
        pieChartYear.usePercentValuesEnabled = true
        pieChartYear.transparentCircleRadiusPercent = 0.0
        pieChartYear.legend.enabled = false
        pieChartYear.holeRadiusPercent = 0.35
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if segConIndex == 0{
            if let dataSet0 = pieChart.data?.dataSets[ highlight.dataSetIndex] {
                let sliceIndex: Int = dataSet0.entryIndex(entry: entry)
                indexDay = sliceIndex
            }
        }else if segConIndex == 1{
            if let dataSet1 = pieChartWeek.data?.dataSets[ highlight.dataSetIndex] {
                 let sliceIndex: Int = dataSet1.entryIndex(entry: entry)
                 indexWeek = sliceIndex
             }
        }else if segConIndex == 2{
            if let dataSet2 = pieChartMonth.data?.dataSets[ highlight.dataSetIndex] {
                 let sliceIndex: Int = dataSet2.entryIndex(entry: entry)
                 indexMonth = sliceIndex
                pieChartMonth.centerText = "\(sliceIndex)"
             }
        }else if segConIndex == 3{
            if let dataSet3 = pieChartYear.data?.dataSets[ highlight.dataSetIndex] {
                 let sliceIndex: Int = dataSet3.entryIndex(entry: entry)
                 indexYear = sliceIndex
             }
        }
        performSegue(withIdentifier: "analysisToCombineChart", sender: self)
    }
    
    private func colorsOfCategory(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for i in 0...numbersOfColor-1{
            let color = hexStringToUIColor (hex: "\(showCategoryColor[i])")
            colors.append(color)
        }
        return colors
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tag = nil
        if (segue.identifier == "analysisToCombineChart"){
            if let vc = segue.destination as? combineChartViewController{
                vc.hidesBottomBarWhenPushed = true
                if segConIndex == 0{
                    vc.name = "\(showCategory[indexDay].categoryName)"
                    vc.color = hexStringToUIColor (hex:"\(showCategory[indexDay].categoryColor)")
                    vc.time = "\(valuesDay[indexDay])"
                }else if segConIndex == 1{
                    vc.name = "\(showCategory[indexWeek].categoryName)"
                    vc.color = hexStringToUIColor (hex:"\(showCategory[indexWeek].categoryColor)")
                    vc.time = "\(valuesWeek[indexWeek])"
                }else if segConIndex == 2{
                    vc.name = "\(showCategory[indexMonth].categoryName)"
                    vc.color = hexStringToUIColor (hex:"\(showCategory[indexMonth].categoryColor)")
                    vc.time = "\(valuesMonth[indexMonth])"
                }else if segConIndex == 3{
                    vc.name = "\(showCategory[indexYear].categoryName)"
                    vc.color = hexStringToUIColor (hex:"\(showCategory[indexYear].categoryColor)")
                    vc.time = "\(valuesYear[indexYear])"
                }
            }
        }
        if (segue.identifier == "analysisDatePopUp"){
            if let vc = segue.destination as? DatePopupViewController{
                vc.tag = "analysis"
                vc.showDate = showDayformatter.date(from: showTimeLabel)!
            }
        }
        if (segue.identifier == "analysisPickerView"){
            if let vc = segue.destination as? PickerViewController{
                vc.tag = "analysisMonthYear"
            }
        }
        if (segue.identifier == "analysisPickerViewYear"){
            if let vc = segue.destination as? PickerViewYearController{
                vc.tag = "analysisYear"
            }
        }
        if (segue.identifier == "analysisPickerViewWeek"){
            if let vc = segue.destination as? PickerViewWeekViewController{
                vc.tag = "analysisWeek"
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "analysisTableViewCell", for: indexPath) as! analysisTableViewCell
        cell.timeLabel.text = showTimeLabel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segConIndex == 0{
            performSegue(withIdentifier: "analysisDatePopUp", sender: self)
        }else if segConIndex == 1{
            performSegue(withIdentifier: "analysisPickerViewWeek", sender: self)
        }else if segConIndex == 2{
            performSegue(withIdentifier: "analysisPickerView", sender: self)
        }else if segConIndex == 3{
            performSegue(withIdentifier: "analysisPickerViewYear", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getTrackTime(){
        showTrack = DBManager.getInstance().getDateTracks(String: selectedDay)
        var startDay = ""
        var endDay = ""
        for i in 0...showTrack.count-1{
            startDay = showTrack[i].startTime
            endDay = showTrack[i].endTime
            if showTrack[i].startDate != selectedDay{
                startDay = "00:00"
            }
            if showTrack[i].endDate != selectedDay{
                endDay = "23:59"
            }
            let trackTimeDay = round(10*(showTimeformatter.date(from: endDay)?.timeIntervalSince(showTimeformatter.date(from: startDay)!))!/3600)/10
            valuesDay.enumerated().forEach{index, value in
                if showTrack[i].categoryId-1 == index{
                    valuesDay[index] = value+trackTimeDay
                }
            }
        }
    }
    
    func getTrackTimeWeek(){
        showTrack = DBManager.getInstance().getWeekTracks(year: selectedYear, week: selectedWeek)
        var startWeek = ""
        var endWeek = ""
        for i in 0...showTrack.count-1{
            startWeek = "\(showTrack[i].startDate) \(showTrack[i].startTime)"
            endWeek = "\(showTrack[i].endDate) \(showTrack[i].endTime)"
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
            print(startWeek)
            print(endWeek)
            let trackTimeWeek = round(10*(showDateformatter.date(from: endWeek)?.timeIntervalSince(showDateformatter.date(from: startWeek)!))!/3600)/10
            valuesWeek.enumerated().forEach{index, value in
                if showTrack[i].categoryId-1 == index{
                    valuesWeek[index] = value+trackTimeWeek
                }
            }
        }
    }
    
    func getTrackTimeMonth(){
        showTrack = DBManager.getInstance().getMonthTracks(Year: selectedYear, Month: selectedMonth)
        var startMonth = ""
        var endMonth = ""
        let monthSelected = selectedYear+"-"+selectedMonth
        for i in 0...showTrack.count-1{
            startMonth = "\(showTrack[i].startDate) \(showTrack[i].startTime)"
            endMonth = "\(showTrack[i].endDate) \(showTrack[i].endTime)"
            if showTrack[i].startDate.contains("-\(selectedMonth)-") == false{
                let components = NSCalendar.current.dateComponents(Set<Calendar.Component>([.year, .month]),from: showMonthformatter.date(from: monthSelected)!)
                let s = NSCalendar.current.date(from: components)!
                startMonth = showDateformatter.string(from: s)
            }
            if showTrack[i].endDate.contains("-\(selectedMonth)-") == false{
//                let components = NSCalendar.current.dateComponents(Set<Calendar.Component>([.year, .month, .day, .hour, .minute]),from: showMonthformatter.date(from: selectedDay)!)
                var com = DateComponents()
                com.month = 1
                com.second = -1
                let e = NSCalendar.current.date(byAdding: com, to: showMonthformatter.date(from: monthSelected)!)!
                endMonth = showDateformatter.string(from: e)
            }
            let trackTimeMonth = round(10*(showDateformatter.date(from: endMonth)?.timeIntervalSince(showDateformatter.date(from: startMonth)!))!/3600)/10
            valuesMonth.enumerated().forEach{index, value in
                if showTrack[i].categoryId-1 == index{
                    valuesMonth[index] = value+trackTimeMonth
                }
            }
        }
    }
    
    @IBAction func TimeSegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "timeSegueBack"{
            if segConIndex == 0{
                let vc = segue.source as? DatePopupViewController
                date = vc!.datePicker.date
                tag = vc?.tag
                if tag == "analysis"{
                    showCategory = DBManager.getInstance().getAllCategory()
                    showTimeLabel = showDayformatter.string(from: date)
                    selectedDay = "\(showTimeLabel)"
                    for (index, value) in valuesDay.enumerated(){
                        valuesDay[index] = value*0
                    }
                    showCategoryStr.enumerated().forEach{index, value in
                        showCategoryStr = [String]()
                    }
                    for i in 0...showCategory.count-2{
                        showCategoryStr.append(showCategory[i].categoryName)
                    }
                    if DBManager.getInstance().getDateTracks(String: selectedDay) != nil{
                        getTrackTime()
                        showCategoryStr.enumerated().forEach{index, value in
                            if valuesDay[index] == 0.0{
                                showCategoryStr[index] = ""
                            }
                        }
                        customizeCategoryChart(dataPoints: showCategoryStr, values: valuesDay)
                        pieChart.isHidden = false
                        noDataLabel.isHidden = true
                    }else{
                        showTrack = [TrackModel]()
                        customizeCategoryChart(dataPoints: showCategoryStr, values: valuesDay)
                        pieChart.isHidden = true
                        noDataLabel.isHidden = false
                    }
                }
            }else if segConIndex == 1{
                let vc = segue.source as? PickerViewWeekViewController
                tag = vc?.tag
                if tag == "analysisWeek"{
                    showCategory = DBManager.getInstance().getAllCategory()
                    showTimeLabel = (vc!.pickerViewWeek.dateWeek)
                    selectedYear = "\(currentYear)"
                    selectedWeek = vc!.pickerViewWeek.week
                    for (index, value) in valuesWeek.enumerated(){
                        valuesWeek[index] = value*0
                    }
                    showCategoryStr.enumerated().forEach{index, value in
                        showCategoryStr = [String]()
                    }
                    for i in 0...showCategory.count-2{
                        showCategoryStr.append(showCategory[i].categoryName)
                    }
                    if DBManager.getInstance().getWeekTracks(year: selectedYear, week: selectedWeek) != nil{
                        getTrackTimeWeek()
                        showCategoryStr.enumerated().forEach{index, value in
                            if valuesWeek[index] == 0.0{
                                showCategoryStr[index] = ""
                            }
                        }
                        customizeCategoryChartWeek(dataPoints: showCategoryStr, values: valuesWeek)
                        pieChartWeek.isHidden = false
                        noDataLabel.isHidden = true
                    }else{
                        showTrack = [TrackModel]()
                        customizeCategoryChartWeek(dataPoints: showCategoryStr, values: valuesWeek)
                        pieChartWeek.isHidden = true
                        noDataLabel.isHidden = false
                    }
                }
            }else if segConIndex == 2{
                let vc = segue.source as? PickerViewController
                tag = vc?.tag
                if tag == "analysisMonthYear"{
                    showCategory = DBManager.getInstance().getAllCategory()
                    showTimeLabel = vc!.pickerViewMonthYear.dateMonthYear
                    selectedYear = "\(vc!.pickerViewMonthYear.year)"
                    if currentMonth < 10{
                        selectedMonth = "0\(vc!.pickerViewMonthYear.month)"
                    }else{
                        selectedMonth = "\(vc!.pickerViewMonthYear.month)"
                    }
                    for (index, value) in valuesMonth.enumerated(){
                        valuesMonth[index] = value*0
                    }
                    showCategoryStr.enumerated().forEach{index, value in
                        showCategoryStr = [String]()
                    }
                    for i in 0...showCategory.count-2{
                        showCategoryStr.append(showCategory[i].categoryName)
                    }
                    if DBManager.getInstance().getMonthTracks(Year: selectedYear, Month: selectedMonth) != nil{
                        getTrackTimeMonth()
                        showCategoryStr.enumerated().forEach{index, value in
                            if valuesMonth[index] == 0.0{
                                showCategoryStr[index] = ""
                            }
                        }
                        customizeCategoryChartMonth(dataPoints: showCategoryStr, values: valuesMonth)
                        pieChartMonth.isHidden = false
                        noDataLabel.isHidden = true
                    }else{
                        showTrack = [TrackModel]()
                        customizeCategoryChartMonth(dataPoints: showCategoryStr, values: valuesMonth)
                        pieChartMonth.isHidden = true
                        noDataLabel.isHidden = false
                    }
                }
            }else if segConIndex == 3{
                let vc = segue.source as? PickerViewYearController
                tag = vc?.tag
                if tag == "analysisYear"{
                    showTimeLabel = vc!.pickerViewYear.dateYear
                }
            }
            self.tableView.reloadData()
        }
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
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
