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
    @IBOutlet var pieChart: PieChartView!
    @IBOutlet var lineChart: LineChartView!
    
    var showCategory = [CategoryModel]()
    var showCategoryStr = [String]()
    var showCategoryColor = [String]()
    
    let players = ["Mo", "Sherry", "Dylan", "Stasia", "Andrey", "CH"]
    let goals = [6, 8, 26, 30, 8, 10]
    let sports = ["Tennis", "Basketball", "Baseball", "Golf"]
    let counts = [45, 76, 34, 97]
    let categoryValues = [34, 67, 89, 45, 44, 12, 28, 90, 23, 60, 57, 17, 26, 37, 95, 54, 64, 87]
    let category = ["Lesson", "Work", "Exercise", "Meals", "Study", "Commute", "Travel", "Sleep", "Default"]
    let line = [110.0, 120.0, 130.0, 140.0, 150.0, 160.0, 170.0, 180.0, 190.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Analysis"
        
        showCategory = DBManager.getInstance().getAllCategory()
        for i in 0...showCategory.count-1{
            showCategoryStr.append(showCategory[i].categoryName)
            showCategoryColor.append(showCategory[i].categoryColor)
        }
        
        customizeCategoryChart(dataPoints: showCategoryStr, values: categoryValues.map{ Double($0)})
        pieChart.chartDescription?.text = "CHCHBOSS"
        pieChart.entryLabelColor = UIColor.black
        pieChart.drawEntryLabelsEnabled = false
        pieChart.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
        pieChart.transparentCircleRadiusPercent = 0.0
        pieChart.legend.horizontalAlignment = .center
        pieChart.legend.verticalAlignment = .bottom
        pieChart.holeRadiusPercent = 0.35
        lineChart.isHidden = true
    }
    
    @IBAction func segConChoose(_ sender: Any) {
        var getIndex = segCon.selectedSegmentIndex        
        if getIndex == 0{
            customizeCategoryChart(dataPoints: showCategoryStr, values: categoryValues.map{ Double($0)})
            pieChart.isHidden = false
            lineChart.isHidden = true
        }else if getIndex == 1{
            customizePieChart(dataPoints: sports, values: counts.map{
                Double($0) })
            pieChart.isHidden = false
            lineChart.isHidden = true
        }else if getIndex == 2{
            customizePieChart(dataPoints: players, values: goals.map{ Double($0) })
            pieChart.isHidden = false
            lineChart.isHidden = true
        }else if getIndex == 3{
            customizeLineChart(dataPoints: category, values: line)
            lineChart.chartDescription?.text = "CHCHBOSS"
            pieChart.isHidden = true
            lineChart.isHidden = false
            lineChart.dragEnabled = true
            lineChart.doubleTapToZoomEnabled = false
            lineChart.drawGridBackgroundEnabled = false
        }
        
    }
    
    func customizePieChart(dataPoints: [String], values: [Double]) {
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        pieChart.data = pieChartData
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
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        pieChartData.setValueTextColor(UIColor.black)
        // 4. Assign it to the chart’s data
        pieChart.data = pieChartData
        
        pieChart.rotationAngle = 0
        pieChart.legend.direction = .leftToRight
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = chartView.data?.dataSets[ highlight.dataSetIndex] {
            let sliceIndex: Int = dataSet.entryIndex(entry: entry)
            print( "Selected slice index: \( sliceIndex)")
            performSegue(withIdentifier: "analysisToCombineChart", sender: self)
        }
    }
    
    func customizeLineChart(dataPoints: [String], values: [Double]){
        lineChart.delegate = self
        var dataEntries: [ChartDataEntry] = []
        var dataDays: [String] = []
        var count = 0
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
            dataDays.append(dataPoints[count])
            if count == dataPoints.count - 1 {
                count = 0
            }else{
                count = count + 1
            }
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        lineChartDataSet.circleColors = colorsOfCategory(numbersOfColor: dataPoints.count)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChart.data = lineChartData
        
    }
    
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
            let vc = segue.destination as! combineChartViewController
//            for i in 0...showCategory.count-1{
//            vc.categoryName.text = showCategory[i].categoryName
//            }
    }
    
    
    
}

//    dataSet.colors = ChartColorTemplates.colorful()
//    ChartColorTemplates.liberty()
//    ChartColorTemplates.joyful()
//    ChartColorTemplates.pastel()
//    ChartColorTemplates.colorful()
//    ChartColorTemplates.vordiplom()
//    ChartColorTemplates.material()
}
