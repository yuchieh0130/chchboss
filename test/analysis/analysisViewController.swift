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
    
    var categoryValues = [34.0, 67.0, 89.0, 45.0, 44.0, 12.0, 28.0, 90.0, 23.0, 60.0, 57.0, 17.0, 26.0, 37.0, 95.0, 54.0, 64.0, 87.0]
    var values = [0.0, 40.0, 63.0, 0.0, 44.0, 12.0, 0.0, 90.0, 0.0, 60.0, 0.0, 17.0, 0.0, 37.0, 0.0, 54.0, 64.0, 11.0]
    var values1 = [54.0, 67.0, 89.0, 0.0, 44.0, 12.0, 28.0, 90.0, 23.0, 60.0, 57.0, 17.0, 0.0, 37.0, 0.0, 0.0,0.0, 0.0]
    var values2 = [70.0, 67.0, 89.0, 74.0, 44.0, 12.0, 5.0, 90.0, 0.0, 60.0, 9.0, 0.0, 26.0, 0.0, 95.0, 54.0, 64.0, 87.0]
    var index0 = 0
    var index1 = 0
    var index2 = 0
    var index3 = 0
    var total = 0.0
    var percentage = Array<Double>()
    var segConIndex = 0
    
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var currentDay = Calendar.current.component(.day, from: Date())
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Analysis"
        
        var categoryTotal = categoryValues.reduce(0, +)
        total = categoryTotal
        var categoryPercentage = categoryValues.map{(round(($0/total)*1000))/10}
        percentage = categoryPercentage
        
        //會直接取代原本array裡面的value
//        for (index, value) in categoryValues.enumerated(){
//            print("Item \(index + 1): \((round((value/total)*1000))/10)")
//        }
//        categoryPercentage.enumerated().forEach{index, value in
//            categoryPercentage[index] = (round((value/total)*1000))/10
//        }
        
        showCategory = DBManager.getInstance().getAllCategory()
        for i in 0...showCategory.count-1{
            showCategoryStr.append(showCategory[i].categoryName)
            showCategoryColor.append(showCategory[i].categoryColor)
        }
        
        customizeCategoryChart(dataPoints: showCategoryStr, values: categoryValues)
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
        
        setUpDay()
    }
    
    @IBAction func segConChoose(_ sender: Any) {
        var getIndex = segCon.selectedSegmentIndex
        segConIndex = getIndex
        if getIndex == 0{
            customizeCategoryChart(dataPoints: showCategoryStr, values: categoryValues)
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
        }else if getIndex == 1{
            customizeCategoryChartWeek(dataPoints: showCategoryStr, values: values)
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
            customizeCategoryChartMonth(dataPoints: showCategoryStr, values: values1)
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
            customizeCategoryChartYear(dataPoints: showCategoryStr, values: values2)
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
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        pieChartData.setValueTextColor(UIColor.black)
        // 4. Assign it to the chart’s data
        pieChart.data = pieChartData
        
        pieChart.rotationAngle = 0
        pieChart.legend.direction = .leftToRight
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
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        pieChartData.setValueTextColor(UIColor.black)
        // 4. Assign it to the chart’s data
        pieChartWeek.data = pieChartData
        
        pieChartWeek.rotationAngle = 0
        pieChartWeek.legend.direction = .leftToRight
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
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        pieChartData.setValueTextColor(UIColor.black)
        // 4. Assign it to the chart’s data
        pieChartMonth.data = pieChartData
        
        pieChartMonth.rotationAngle = 0
        pieChartMonth.legend.direction = .leftToRight
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
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        pieChartData.setValueTextColor(UIColor.black)
        // 4. Assign it to the chart’s data
        pieChartYear.data = pieChartData
        
        pieChartYear.rotationAngle = 0
        pieChartYear.legend.direction = .leftToRight
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if segConIndex == 0{
            if let dataSet0 = pieChart.data?.dataSets[ highlight.dataSetIndex] {
                let sliceIndex: Int = dataSet0.entryIndex(entry: entry)
                index0 = sliceIndex
            }
        }else if segConIndex == 1{
            if let dataSet1 = pieChartWeek.data?.dataSets[ highlight.dataSetIndex] {
                 let sliceIndex: Int = dataSet1.entryIndex(entry: entry)
                 index1 = sliceIndex
             }
        }else if segConIndex == 2{
            if let dataSet2 = pieChartMonth.data?.dataSets[ highlight.dataSetIndex] {
                 let sliceIndex: Int = dataSet2.entryIndex(entry: entry)
                 index2 = sliceIndex
             }
        }else if segConIndex == 3{
            if let dataSet3 = pieChartYear.data?.dataSets[ highlight.dataSetIndex] {
                 let sliceIndex: Int = dataSet3.entryIndex(entry: entry)
                 index3 = sliceIndex
             }
        }
        performSegue(withIdentifier: "analysisToCombineChart", sender: self)
    }
    
//    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
//        var colors: [UIColor] = []
//        for _ in 0..<numbersOfColor {
//            let red = Double(arc4random_uniform(256))
//            let green = Double(arc4random_uniform(256))
//            let blue = Double(arc4random_uniform(256))
//            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
//            colors.append(color)
//        }
//        return colors
//    }
    
    private func colorsOfCategory(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for i in 0...numbersOfColor-1{
            let color = hexStringToUIColor (hex: "\(showCategoryColor[i])")
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
            alpha: CGFloat(0.8)
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tag = nil
        if (segue.identifier == "analysisToCombineChart"){
            if let vc = segue.destination as? combineChartViewController{
                if segConIndex == 0{
                    vc.name = "\(showCategory[index0].categoryName)"
                    vc.color = hexStringToUIColor (hex:"\(showCategory[index0].categoryColor)")
                    vc.time = "\(categoryValues[index0])"
                }else if segConIndex == 1{
                    vc.name = "\(showCategory[index1].categoryName)"
                    vc.color = hexStringToUIColor (hex:"\(showCategory[index1].categoryColor)")
                    vc.time = "\(values[index1])"
                }else if segConIndex == 2{
                    vc.name = "\(showCategory[index2].categoryName)"
                    vc.color = hexStringToUIColor (hex:"\(showCategory[index2].categoryColor)")
                    vc.time = "\(values1[index2])"
                }else if segConIndex == 3{
                    vc.name = "\(showCategory[index3].categoryName)"
                    vc.color = hexStringToUIColor (hex:"\(showCategory[index3].categoryColor)")
                    vc.time = "\(values2[index3])"
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
        if segConIndex == 0{
            let vc = segue.source as? DatePopupViewController
            date = vc!.datePicker.date
            tag = vc?.tag
            if tag == "analysis"{
                timeLabel.text = showDayformatter.string(from: date)
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
    
    func setUpDay(){
        if currentMonth < 9{
            timeLabel.text = "\(currentYear)-0\(currentMonth)-\(currentDay)"
        }else{
            timeLabel.text = "\(currentYear)-\(currentMonth)-\(currentDay)"
        }
        
    }
    
    func setUpWeek(){
        timeLabel.text = "still thinking"
    }
    
    func setUpMonth(){
        timeLabel.text = months[currentMonth - 1] + " \(currentYear)"
    }
    
    func setUpYear(){
        timeLabel.text = "\(currentYear)"
    }
    
    @IBAction func leftBtnAction(_ sender: UIButton) {
        if segConIndex == 0{
            currentDay -= 1
            setUpDay()
        }else if segConIndex == 1{
            setUpWeek()
        }else if segConIndex == 2{
            currentMonth -= 1
            if currentMonth == 0{
                currentMonth = 12
                currentYear -= 1
            }
            setUpMonth()
        }else if segConIndex == 3{
            currentYear -= 1
            setUpYear()
        }
    }
    
    @IBAction func rightBtnAction(_ sender: UIButton) {
        if segConIndex == 0{
            currentDay += 1
            setUpDay()
        }else if segConIndex == 1{
            setUpWeek()
        }else if segConIndex == 2{
            currentMonth += 1
            if currentMonth == 13{
                currentMonth = 1
                currentYear += 1
                }
            setUpMonth()
        }else if segConIndex == 3{
            currentYear += 1
            setUpYear()
        }
    }
    
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
    
    
    
}
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
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
