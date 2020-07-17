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

class combineChartViewController: UIViewController, ChartViewDelegate{
    
    @IBOutlet var combineChart: CombinedChartView!
    @IBOutlet var returnBtn: UIButton!
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var segCon: UISegmentedControl!
    @IBOutlet var todayTime: UIView!
    @IBOutlet var todayTimeLabel: UILabel! //顯示的title
    @IBOutlet var timeLabel: UILabel!  //顯示時長
    
    var showCategory = [CategoryModel]()
    var showCategoryStr = [String]()
    var showCategoryColor = [String]()
    var name = "Behaviors"
    var color = UIColor()
    var time = "Time"
    
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var value = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0]
    
    @IBAction func returnBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        combineChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayTime.isHidden = false
        todayTimeLabel.isHidden = false
        timeLabel.isHidden = false
        combineChart.isHidden = true
        
        categoryName.text = name
        todayTimeLabel.text = "Today's \(name) time"
        timeLabel.textColor = UIColor.black
        timeLabel.backgroundColor = color
        timeLabel.text = time
        
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
        combineChart.drawOrder = [DrawOrder.bar.rawValue, DrawOrder.line.rawValue]
        
        //x axis
        let xAxis = combineChart.xAxis
        xAxis.labelPosition = .bothSided
//        xAxis.axisMinimum = 0.0
//        xAxis.axisMaximum = 11.0
        xAxis.granularityEnabled = true
        xAxis.granularity = 1.0  //距離
        xAxis.valueFormatter = BarChartFormatter()
        xAxis.centerAxisLabelsEnabled = false
        xAxis.setLabelCount(12, force: true)
        xAxis.drawGridLinesEnabled = false
        //left axis
        let leftAxis = combineChart.leftAxis
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0.0
       //right axis
        let rightAxis = combineChart.rightAxis
        rightAxis.drawGridLinesEnabled = false
        rightAxis.axisMinimum = 0.0
        //legend
        let legend = combineChart.legend
        legend.wordWrapEnabled = true
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        //description
        combineChart.chartDescription?.enabled = true
        
        setChartData()
        //combineChart.isHidden = true
    }
    
    @IBAction func segConChoose(_ sender: Any) {
        var getIndex = segCon.selectedSegmentIndex
        
        if getIndex == 0{
            todayTime.isHidden = false
            todayTimeLabel.isHidden = false
            timeLabel.isHidden = false
            combineChart.isHidden = true
        }else if getIndex == 1{
            todayTime.isHidden = true
            todayTimeLabel.isHidden = true
            timeLabel.isHidden = true
            setChartData()
            combineChart.isHidden = false
        }else if getIndex == 2{
            todayTime.isHidden = true
            todayTimeLabel.isHidden = true
            timeLabel.isHidden = true
            setChartData()
            combineChart.isHidden = false
        }else if getIndex == 3{
            todayTime.isHidden = true
            todayTimeLabel.isHidden = false
            timeLabel.isHidden = true
            setChartData()
            combineChart.isHidden = false

        }
        
    }
    
    func setChartData(){
        let data = CombinedChartData()
        data.lineData = generateLineData(dataPoints: months, values: value)
        data.barData = generateBarData(dataPoints: months, values: value)
        combineChart.xAxis.axisMaximum = data.xMax
        combineChart.xAxis.axisMinimum = data.xMin
        combineChart.data = data
    }
    
    func generateLineData(dataPoints: [String], values: [Double]) -> LineChartData{
        var dataEntries = [ChartDataEntry]()
        for i in 0..<dataPoints.count{
            let dataEntry = ChartDataEntry(x: values[i], y: (Double(arc4random_uniform(25) + 25)))
            //Double(i)
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Line Chart")
        lineChartDataSet.colors = [UIColor.gray]
        lineChartDataSet.circleColors = colorsOfCategory(numbersOfColor: dataPoints.count)
        let data = LineChartData()
        data.addDataSet(lineChartDataSet)
        return data
    }
    
    func generateBarData(dataPoints: [String], values: [Double]) -> BarChartData{
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<dataPoints.count{
            let dataEntry = BarChartDataEntry(x: Double(i), y: (Double(arc4random_uniform(25) + 25)))
            //Double(values[i])
            dataEntries.append(dataEntry)
        }
        
        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "Bar Chart")
        barChartDataSet.colors = colorsOfCategory(numbersOfColor: dataPoints.count)
        barChartDataSet.valueTextColor = UIColor.black
        barChartDataSet.valueFont = NSUIFont.systemFont(ofSize: CGFloat(10.0))
        barChartDataSet.axisDependency = .left
        
        //BarChartData
        let groupSpace = 0.06
        let barSpace = 0.01
        let barWidth = 0.46
        
        let data = BarChartData()
        data.barWidth = barWidth
        data.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
        data.addDataSet(barChartDataSet)
        return data
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected : x = \(highlight.x)")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("chartValueNothingSelected")
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
    
    public class BarChartFormatter: NSObject, IAxisValueFormatter
    {
        var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var days: [String]! = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            let moduMonth =  Double(value).truncatingRemainder(dividingBy: Double(months.count))
            let moduDay = Double(value).truncatingRemainder(dividingBy: Double(days.count))
            return months[Int(moduMonth)]
        }
    }
    

}
