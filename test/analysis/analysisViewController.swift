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

class analysisViewController: UIViewController, ChartViewDelegate{
    
    @IBOutlet var segCon: UISegmentedControl!
    @IBOutlet var pieChart: PieChartView! //pieChartToday
    @IBOutlet var pieChartWeek: PieChartView!
    @IBOutlet var pieChartMonth: PieChartView!
    @IBOutlet var pieChartYear: PieChartView!
    @IBOutlet var timeView: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var leftBtn: UIButton!
    @IBOutlet var rightBtn: UIButton!
    @IBOutlet var timeLabelBtn: UIButton!
    
    var showCategory = [CategoryModel]()
    var showCategoryStr = [String]()
    var showCategoryColor = [String]()

    var showTrack = [TrackModel]()
    var trackDate = ""
    var hours = [String]()
    var track :TrackModel?
    var categoryName = ""
    
    var valuesDay = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var valuesWeek = [34.0, 67.0, 89.0, 45.0, 44.0, 12.0, 28.0, 90.0, 23.0, 60.0, 57.0, 17.0, 26.0, 37.0, 95.0, 54.0, 64.0, 87.0]
    var valuesMonth = [54.0, 67.0, 89.0, 0.0, 44.0, 12.0, 28.0, 90.0, 23.0, 60.0, 57.0, 17.0, 0.0, 37.0, 0.0, 0.0,0.0, 0.0]
    var valuesYear = [70.0, 67.0, 89.0, 74.0, 44.0, 12.0, 5.0, 90.0, 0.0, 60.0, 9.0, 0.0, 26.0, 0.0, 95.0, 54.0, 64.0, 87.0]
    //for chart selected view
    var indexDay = 0
    var indexWeek = 0
    var indexMonth = 0
    var indexYear = 0
    var segConIndex = 0
    
    var selectedDay = ""
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
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
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
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    var showWeekdayformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd EEE HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Analysis"
        self.navigationController?.navigationBar.shadowImage = UIImage()
        segCon.translatesAutoresizingMaskIntoConstraints = false
        timeView.translatesAutoresizingMaskIntoConstraints = false
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
        
        setUpDay()
        selectedDay = "2020/07/02"
        getTrackTime()
        
        customizeCategoryChart(dataPoints: showCategoryStr, values: valuesDay)
        pieChart.entryLabelColor = UIColor.black
        pieChart.drawEntryLabelsEnabled = false
        pieChart.usePercentValuesEnabled = true
        //pieChart.setExtraOffsets(left: 5, top: 5, right: 5, bottom: 5)
        pieChart.transparentCircleRadiusPercent = 0.0
        pieChart.legend.horizontalAlignment = .center
        pieChart.legend.verticalAlignment = .bottom
        pieChart.holeRadiusPercent = 0.35
        
        pieChartWeek.entryLabelColor = UIColor.black
        pieChartWeek.drawEntryLabelsEnabled = false
        pieChartWeek.usePercentValuesEnabled = true
        //pieChartWeek.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
        pieChartWeek.transparentCircleRadiusPercent = 0.0
        pieChartWeek.legend.horizontalAlignment = .center
        pieChartWeek.legend.verticalAlignment = .bottom
        pieChartWeek.holeRadiusPercent = 0.35
        
        pieChartMonth.entryLabelColor = UIColor.black
        pieChartMonth.drawEntryLabelsEnabled = false
        pieChartMonth.usePercentValuesEnabled = true
        //pieChartMonth.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
        pieChartMonth.transparentCircleRadiusPercent = 0.0
        pieChartMonth.legend.horizontalAlignment = .center
        pieChartMonth.legend.verticalAlignment = .bottom
        pieChartMonth.holeRadiusPercent = 0.35
        
        pieChartYear.entryLabelColor = UIColor.black
        pieChartYear.drawEntryLabelsEnabled = false
        pieChartYear.usePercentValuesEnabled = true
        //pieChartYear.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
        pieChartYear.transparentCircleRadiusPercent = 0.0
        pieChartYear.legend.horizontalAlignment = .center
        pieChartYear.legend.verticalAlignment = .bottom
        pieChartYear.holeRadiusPercent = 0.35
        
        pieChart.isHidden = false
        pieChartWeek.isHidden = true
        pieChartMonth.isHidden = true
        pieChartYear.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool){
           if DBManager.getInstance().getDateTracks(String: trackDate) != nil{
               showTrack = DBManager.getInstance().getDateTracks(String: trackDate)
           }else{
               showTrack = [TrackModel]()
           }
    }
    
    @IBAction func segConChoose(_ sender: Any) {
        let getIndex = segCon.selectedSegmentIndex
        segConIndex = getIndex
        if getIndex == 0{
            customizeCategoryChart(dataPoints: showCategoryStr, values: valuesDay)
            //pieChart.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
            pieChart.transparentCircleRadiusPercent = 0.0
            pieChart.legend.horizontalAlignment = .center
            pieChart.legend.verticalAlignment = .bottom
            pieChart.holeRadiusPercent = 0.35
            pieChart.isHidden = false
            pieChartWeek.isHidden = true
            pieChartMonth.isHidden = true
            pieChartYear.isHidden = true
            setUpDay()
            selectedDay = "\(timeLabel.text!)"
        }else if getIndex == 1{
            customizeCategoryChartWeek(dataPoints: showCategoryStr, values: valuesWeek)
            //pieChartWeek.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
            pieChartWeek.transparentCircleRadiusPercent = 0.0
            pieChartWeek.legend.horizontalAlignment = .center
            pieChartWeek.legend.verticalAlignment = .bottom
            pieChartWeek.holeRadiusPercent = 0.35
            pieChart.isHidden = true
            pieChartWeek.isHidden = false
            pieChartMonth.isHidden = true
            pieChartYear.isHidden = true
            setUpWeek()
        }else if getIndex == 2{
            customizeCategoryChartMonth(dataPoints: showCategoryStr, values: valuesMonth)
            //pieChartMonth.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
            pieChartMonth.transparentCircleRadiusPercent = 0.0
            pieChartMonth.legend.horizontalAlignment = .center
            pieChartMonth.legend.verticalAlignment = .bottom
            pieChartMonth.holeRadiusPercent = 0.35
            pieChart.isHidden = true
            pieChartWeek.isHidden = true
            pieChartMonth.isHidden = false
            pieChartYear.isHidden = true
            setUpMonth()
        }else if getIndex == 3{
            customizeCategoryChartYear(dataPoints: showCategoryStr, values: valuesYear)
            //pieChartYear.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
            pieChartYear.transparentCircleRadiusPercent = 0.0
            pieChartYear.legend.horizontalAlignment = .center
            pieChartYear.legend.verticalAlignment = .bottom
            pieChartYear.holeRadiusPercent = 0.35
            pieChart.isHidden = true
            pieChartWeek.isHidden = true
            pieChartMonth.isHidden = true
            pieChartYear.isHidden = false
            setUpYear()
        }
        
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
        pieChart.data = pieChartData
        
        pieChart.rotationAngle = 0
        pieChart.legend.direction = .leftToRight
        pieChartDataSet.selectionShift = 5
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
        pieChartWeek.legend.direction = .leftToRight
        pieChartDataSet.selectionShift = 5
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
        pieChartMonth.legend.direction = .leftToRight
        pieChartDataSet.selectionShift = 5
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
        pieChartYear.legend.direction = .leftToRight
        pieChartDataSet.selectionShift = 5
    }
    
    func getTrackTime(){
        showTrack = DBManager.getInstance().getDateTracks(String: selectedDay)
        var startDay = ""
        var endDay = ""
//        var startWeek = ""
//        var endWeek = 0
//        var startMonth = ""
//        var endMonth = ""
//        var startYear = ""
//        var endYear = ""
        for i in 0...showTrack.count-1{
            startDay = showTrack[i].startTime
            endDay = showTrack[i].endTime
//            startWeek = showTrack[i].startTime
//            endWeek = Calendar.current.component(.weekOfYear, from: Date())
//            startMonth = showTrack[i].startTime
//            endMonth = showTrack[i].endTime
//            startYear = showTrack[i].startTime
//            endYear = showTrack[i].endTime
            
            if showTrack[i].startDate != selectedDay{
                startDay = "00:00"
            }
            if showTrack[i].endDate != selectedDay{
                endDay = "23:59"
            }
            
            let trackTimeDay = round(10*(showTimeformatter.date(from: endDay)?.timeIntervalSince(showTimeformatter.date(from: startDay)!))!/3600)/10
//            let trackTimeWeek = round(10*(showTimeformatter.date(from: endWeek)?.timeIntervalSince(showTimeformatter.date(from: startWeek)!))!/3600)/10
//            let trackTimeMonth = round(10*(showTimeformatter.date(from: endMonth)?.timeIntervalSince(showTimeformatter.date(from: startMonth)!))!/3600)/10
//            let trackTimeYear = round(10*(showTimeformatter.date(from: endYear)?.timeIntervalSince(showTimeformatter.date(from: startYear)!))!/3600)/10
            
            print("Item \(showTrack[i].categoryId): \(trackTimeDay)")
            
            valuesDay.enumerated().forEach{index, value in
                if showTrack[i].categoryId-1 == index{
                    valuesDay[index] = value+trackTimeDay
                }
            }
//            valuesWeek.enumerated().forEach{index, value in
//                if showTrack[i].categoryId-1 == index{
//                    valuesWeek[index] = value+trackTimeWeek
//                }
//            }
//            valuesMonth.enumerated().forEach{index, value in
//                if showTrack[i].categoryId-1 == index{
//                    valuesMonth[index] = value+trackTimeMonth
//                }
//            }
//            valuesYear.enumerated().forEach{index, value in
//                if showTrack[i].categoryId-1 == index{
//                    valuesYear[index] = value+trackTimeYear
//                }
//            }
        }
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
                vc.showDate = showDayformatter.date(from: timeLabel.text!)!
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
    
    @IBAction func TimeSegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "timeSegueBack"{
            if segConIndex == 0{
                let vc = segue.source as? DatePopupViewController
                date = vc!.datePicker.date
                tag = vc?.tag
                if tag == "analysis"{
                    timeLabel.text = showDayformatter.string(from: date)
                    selectedDay = "\(timeLabel.text!)"
                    for (index, value) in valuesDay.enumerated(){
                        valuesDay[index] = value*0.0
                    }
                    getTrackTime()
                    customizeCategoryChart(dataPoints: showCategoryStr, values: valuesDay)
                }
            }else if segConIndex == 1{
                let vc = segue.source as? PickerViewWeekViewController
                tag = vc?.tag
                if tag == "analysisWeek"{
                    timeLabel.text = vc?.pickerViewWeek.dateWeek
                }
            }else if segConIndex == 2{
                let vc = segue.source as? PickerViewController
                tag = vc?.tag
                if tag == "analysisMonthYear"{
                    timeLabel.text = vc?.pickerViewMonthYear.dateMonthYear
                }
            }else if segConIndex == 3{
                let vc = segue.source as? PickerViewYearController
                tag = vc?.tag
                if tag == "analysisYear"{
                    timeLabel.text = vc?.pickerViewYear.dateYear
                }
            }
        }
    }
    
    func setUpDay(){
//        if currentMonth < 9, currentDay < 10{
//            timeLabel.text = "\(currentYear)-0\(currentMonth)-0\(currentDay)"
//        }else{
//            timeLabel.text = "\(currentYear)-\(currentMonth)-\(currentDay)"
//        }
        currentDate = showDayformatter.string(from: Date())
        timeLabel.text = currentDate
    }
    
    func setUpWeek(){
        startWeekDay = showDayformatter.string(from: startOfWeek!)
        endWeekDay = showDayformatter.string(from: endOfWeek!)
        timeLabel.text = "\(startWeekDay) ~ \(endWeekDay)"
    }
    
    func setUpMonth(){
        timeLabel.text = months[currentMonth - 1] + " \(currentYear)"
    }
    
    func setUpYear(){
        timeLabel.text = "\(currentYear)"
    }
    
//    @IBAction func leftBtnAction(_ sender: UIButton) {
//        if segConIndex == 0{
//            currentDate = showDayformatter.string(from: Date.yesterday)
//            timeLabel.text = currentDate
//        }else if segConIndex == 1{
//            let lastWeek: Date = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
//            start = "\(showDayformatter.string(from: lastWeek.startOfWeek!))"
//            end = "\(showDayformatter.string(from: lastWeek.endOfWeek!))"
//            timeLabel.text = "\(start) ~ \(end)"
//        }else if segConIndex == 2{
//            currentMonth -= 1
//            if currentMonth == 0{
//                currentMonth = 12
//                currentYear -= 1
//            }
//            setUpMonth()
//        }else if segConIndex == 3{
//            currentYear -= 1
//            setUpYear()
//        }
//    }
//
//    @IBAction func rightBtnAction(_ sender: UIButton) {
//        if segConIndex == 0{
//            currentDay += 1
//            setUpDay()
//        }else if segConIndex == 1{
//            let dateFormat = DateFormatter()
//            dateFormat.dateFormat =  "yyyy-MM-dd"
//            let nextWeek: Date = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
//            start = "\(dateFormat.string(from: nextWeek.startOfWeek!))"
//            end = "\(dateFormat.string(from: nextWeek.endOfWeek!))"
//            timeLabel.text = "\(start) ~ \(end)"
//        }else if segConIndex == 2{
//            currentMonth += 1
//            if currentMonth == 13{
//                currentMonth = 1
//                currentYear += 1
//                }
//            setUpMonth()
//        }else if segConIndex == 3{
//            currentYear += 1
//            setUpYear()
//        }
//    }
    
    @IBAction func timeLabelBtnDatePopUp(_ sender: Any) {
        if segConIndex == 0{
            performSegue(withIdentifier: "analysisDatePopUp", sender: self)
        }else if segConIndex == 1{
            performSegue(withIdentifier: "analysisPickerViewWeek", sender: self)
        }else if segConIndex == 2{
            performSegue(withIdentifier: "analysisPickerView", sender: self)
        }else if segConIndex == 3{
            performSegue(withIdentifier: "analysisPickerViewYear", sender: self)
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
            alpha: CGFloat(0.8)
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
