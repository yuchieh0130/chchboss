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

@IBDesignable
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
    
    var showCategory = [CategoryModel]()
    var showCategoryStr = [String]()
    var showCategoryColor = [String]()
    
    var categoryValues = [34.0, 67.0, 89.0, 45.0, 44.0, 12.0, 28.0, 90.0, 23.0, 60.0, 57.0, 17.0, 26.0, 37.0, 95.0, 54.0, 64.0, 87.0]
    let category = ["Lesson", "Work", "Exercise", "Meals", "Study", "Commute", "Travel", "Sleep", "Default"]
    var index = 0
    var total = 0.0
    var percentage = Array<Double>()
    
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
        
        customizeCategoryChart(dataPoints: showCategoryStr, values: percentage)
        pieChart.entryLabelColor = UIColor.black
        pieChart.drawEntryLabelsEnabled = false
        pieChart.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
        pieChart.transparentCircleRadiusPercent = 0.0
        pieChart.legend.horizontalAlignment = .center
        pieChart.legend.verticalAlignment = .bottom
        pieChart.holeRadiusPercent = 0.35
        
        pieChartWeek.entryLabelColor = UIColor.black
        pieChartWeek.drawEntryLabelsEnabled = false
        pieChartWeek.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
        pieChartWeek.transparentCircleRadiusPercent = 0.0
        pieChartWeek.legend.horizontalAlignment = .center
        pieChartWeek.legend.verticalAlignment = .bottom
        pieChartWeek.holeRadiusPercent = 0.35
        
        pieChartMonth.entryLabelColor = UIColor.black
        pieChartMonth.drawEntryLabelsEnabled = false
        pieChartMonth.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
        pieChartMonth.transparentCircleRadiusPercent = 0.0
        pieChartMonth.legend.horizontalAlignment = .center
        pieChartMonth.legend.verticalAlignment = .bottom
        pieChartMonth.holeRadiusPercent = 0.35
        
        pieChartYear.entryLabelColor = UIColor.black
        pieChartYear.drawEntryLabelsEnabled = false
        pieChartYear.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
        pieChartYear.transparentCircleRadiusPercent = 0.0
        pieChartYear.legend.horizontalAlignment = .center
        pieChartYear.legend.verticalAlignment = .bottom
        pieChartYear.holeRadiusPercent = 0.35
        
        pieChart.isHidden = false
        pieChartWeek.isHidden = true
        pieChartMonth.isHidden = true
        pieChartYear.isHidden = true
    }
    
    @IBAction func segConChoose(_ sender: Any) {
        var getIndex = segCon.selectedSegmentIndex        
        if getIndex == 0{
            customizeCategoryChart(dataPoints: showCategoryStr, values: percentage)
            pieChart.isHidden = false
            pieChartWeek.isHidden = true
            pieChartMonth.isHidden = true
            pieChartYear.isHidden = true
        }else if getIndex == 1{
            customizeCategoryChartWeek(dataPoints: showCategoryStr, values: percentage)
            pieChart.isHidden = true
            pieChartWeek.isHidden = false
            pieChartMonth.isHidden = true
            pieChartYear.isHidden = true
        }else if getIndex == 2{
            customizeCategoryChartMonth(dataPoints: showCategoryStr, values: percentage)
            pieChart.isHidden = true
            pieChartWeek.isHidden = true
            pieChartMonth.isHidden = false
            pieChartYear.isHidden = true
        }else if getIndex == 3{
            customizeCategoryChartYear(dataPoints: showCategoryStr, values: percentage)
            pieChart.isHidden = true
            pieChartWeek.isHidden = true
            pieChartMonth.isHidden = true
            pieChartYear.isHidden = false
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
        if let dataSet = chartView.data?.dataSets[ highlight.dataSetIndex] {
            let sliceIndex: Int = dataSet.entryIndex(entry: entry)
            index = sliceIndex
            //print( "Selected slice index: \( sliceIndex)")
    }
        performSegue(withIdentifier: "analysisToCombineChart", sender: self)
    }

//    func customizeLineChart(dataPoints: [String], values: [Double]){
//        lineChart.delegate = self
//        var dataEntries: [ChartDataEntry] = []
//        var dataDays: [String] = []
//        var count = 0
//        for i in 0..<dataPoints.count {
//            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
//            dataEntries.append(dataEntry)
//            dataDays.append(dataPoints[count])
//            if count == dataPoints.count - 1 {
//                count = 0
//            }else{
//                count = count + 1
//            }
//        }
//        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
//        lineChartDataSet.circleColors = colorsOfCategory(numbersOfColor: dataPoints.count)
//        let lineChartData = LineChartData(dataSet: lineChartDataSet)
//        lineChart.data = lineChartData
//
//    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
    
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
        if (segue.identifier == "analysisToCombineChart"){
            if let vc = segue.destination as? combineChartViewController{
                print(index)
                vc.name = "\(showCategory[index].categoryName)"
                vc.color = hexStringToUIColor (hex:"\(showCategory[index].categoryColor)")
                vc.time = "\(categoryValues[index])"
            }
        }
        
    }
    
    @IBAction func leftBtnAction(_ sender: Any) {
    }
    @IBAction func rightBtnAction(_ sender: Any) {
    }
    
    
}

//    dataSet.colors = ChartColorTemplates.colorful()
//    ChartColorTemplates.liberty()
//    ChartColorTemplates.joyful()
//    ChartColorTemplates.pastel()
//    ChartColorTemplates.colorful()
//    ChartColorTemplates.vordiplom()
//    ChartColorTemplates.material()
