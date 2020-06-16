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
class analysisViewController: UIViewController {
    
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
    let yep = [34, 67, 89, 45, 44, 12, 28, 90, 23]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Analysis"
        
        pieChart.chartDescription?.text = "CHCHBOSS"
        customizePieChart(dataPoints: players, values: goals.map{ Double($0) })
        
        lineChart.isHidden = true
        
        showCategory = DBManager.getInstance().getAllCategory()
        for i in 0...showCategory.count-1{
            showCategoryStr.append(showCategory[i].categoryName)
            showCategoryColor.append(showCategory[i].categoryColor)
        }
    }
    
    @IBAction func segConChoose(_ sender: Any) {
        var getIndex = segCon.selectedSegmentIndex        
        if getIndex == 0{
            customizePieChart(dataPoints: players, values: goals.map{ Double($0) })
            pieChart.drawEntryLabelsEnabled = true
            pieChart.entryLabelColor = UIColor.white
            pieChart.isHidden = false
            lineChart.isHidden = true
        }else if getIndex == 1{
            customizePieChart(dataPoints: sports, values: counts.map{
                Double($0) })
            pieChart.drawEntryLabelsEnabled = true
            pieChart.entryLabelColor = UIColor.white
            pieChart.isHidden = false
            lineChart.isHidden = true
        }else if getIndex == 2{
            customizeCategoryChart(dataPoints: showCategoryStr, values: yep.map{ Double($0)})
            pieChart.entryLabelColor = UIColor.black
            pieChart.drawEntryLabelsEnabled = false
            pieChart.isHidden = false
            lineChart.isHidden = true
        }else if getIndex == 3{
            pieChart.isHidden = true
            lineChart.isHidden = false
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
    }
    
    //    func customizeBarChart(dataPoints: [String], values: [Double]) {
    //        var dataEntries: [ChartDataEntry] = []
    //        for i in 0..<dataPoints.count {
    //            let dataEntry = BarChartDataEntry(x: values[i], yValues: [values[i]], data: dataPoints[i])
    //          dataEntries.append(dataEntry)
    //        }
    //        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
    //        barChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
    //        let barChartData = BarChartData(dataSet: barChartDataSet)
    //             let format = NumberFormatter()
    //             format.numberStyle = .none
    //             let formatter = DefaultValueFormatter(formatter: format)
    //             barChartData.setValueFormatter(formatter)
    //             // 4. Assign it to the chart’s data
    //             barChart.data = barChartData
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
    
    
    
    //    dataSet.colors = ChartColorTemplates.colorful()
    //    ChartColorTemplates.liberty()
    //    ChartColorTemplates.joyful()
    //    ChartColorTemplates.pastel()
    //    ChartColorTemplates.colorful()
    //    ChartColorTemplates.vordiplom()
    //    ChartColorTemplates.material()
    
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
