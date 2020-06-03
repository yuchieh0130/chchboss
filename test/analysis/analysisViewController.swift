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
    @IBOutlet var barChart: BarChartView!
    
    var showCategory = [CategoryModel]()
    var showCategoryStr = [String]()
    
    let players = ["Mo", "Sherry", "Dylan", "Stasia", "Andrey", "CH"]
    let goals = [6, 8, 26, 30, 8, 10]
    let sports = ["Tennis", "Basketball", "Baseball", "Golf"]
    let counts = [45, 76, 34, 97]
    let yep = [34, 67, 89, 45, 44, 12, 28, 90, 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Analysis"
        
        pieChart.chartDescription?.text = "CHCHBOSS"
        customizePieChart(dataPoints: players, values: goals.map{ Double($0) })
        
        barChart.chartDescription?.text = "CHCHBOSS"
        
        showCategory = DBManager.getInstance().getAllCategory()
        for i in 0...showCategory.count-1{
            showCategoryStr.append(showCategory[i].categoryName)
        }
    }
    
    @IBAction func segConChoose(_ sender: Any) {
        var getIndex = segCon.selectedSegmentIndex
        print(getIndex)
        
        if getIndex == 0{
            customizePieChart(dataPoints: players, values: goals.map{ Double($0) })
            barChart.isHidden = true
        }else if getIndex == 1{
            customizePieChart(dataPoints: sports, values: counts.map{
                Double($0) })
            barChart.isHidden = true
        }else if getIndex == 2{
            customizePieChart(dataPoints: showCategoryStr, values: yep.map{ Double($0)})
            barChart.isHidden = true
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
    
//    dataSet.colors = ChartColorTemplates.colorful()
//    ChartColorTemplates.liberty()
//    ChartColorTemplates.joyful()
//    ChartColorTemplates.pastel()
//    ChartColorTemplates.colorful()
//    ChartColorTemplates.vordiplom()
//    ChartColorTemplates.material()
    
   
    
    
}
