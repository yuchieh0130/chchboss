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
    
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let ITEM_COUNT = 12
    var name = "Behaviors"
    
    @IBAction func returnBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segConChoose(_ sender: Any) {
        var getIndex = segCon.selectedSegmentIndex
        
        if getIndex == 0{
            setChartData()
        }else if getIndex == 1{
            setChartData()
        }else if getIndex == 2{
            setChartData()
        }else if getIndex == 3{
            setChartData()
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        combineChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        combineChart.delegate = self
        combineChart.drawGridBackgroundEnabled = false
        combineChart.drawBarShadowEnabled = false
        combineChart.highlightFullBarEnabled = false
        combineChart.drawOrder = [DrawOrder.bar.rawValue, DrawOrder.line.rawValue]
        
        //x axis
        let xAxis = combineChart.xAxis
        xAxis.labelPosition = .bothSided
        xAxis.axisMinimum = 0.0
        xAxis.granularity = 1.0  //距離
        xAxis.valueFormatter = BarChartFormatter()
        xAxis.centerAxisLabelsEnabled = true
        xAxis.setLabelCount(12, force: true)
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
        combineChart.chartDescription?.text = "Combine Chart"
        
        setChartData()
        
        categoryName.text = name
    }
    
    func setChartData(){
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        combineChart.xAxis.axisMaximum = data.xMax + 0.25
        combineChart.data = data
    }
    
    func generateLineData() -> LineChartData{
        var entries = [ChartDataEntry]()
        for index in 0..<ITEM_COUNT{
            entries.append(ChartDataEntry(x: Double(index) + 0.5, y: (Double(arc4random_uniform(15) + 5))))
        }
        let lineChartDataSet = LineChartDataSet(entries: entries, label: "Line Chart Data Set")
        lineChartDataSet.colors = colorsOfCharts(numbersOfColor: ITEM_COUNT)
        let data = LineChartData()
        data.addDataSet(lineChartDataSet)
        return data
    }
    
    func generateBarData() -> BarChartData{
        var entries1 = [BarChartDataEntry]()
        var entries2 = [BarChartDataEntry]()
        
        for _ in 0..<ITEM_COUNT{
            entries1.append(BarChartDataEntry(x: 0.0, y: (Double(arc4random_uniform(25) + 25))))
            // stacked
            entries2.append(BarChartDataEntry(x: 0.0, yValues: [Double(arc4random_uniform(13) + 12), Double(arc4random_uniform(13) + 12)]))
        }
        
        let set1 = BarChartDataSet(entries: entries1, label: "Bar 1")
        set1.colors = colorsOfCharts(numbersOfColor: ITEM_COUNT)
        set1.valueTextColor = UIColor.black
        set1.valueFont = NSUIFont.systemFont(ofSize: CGFloat(10.0))
        set1.axisDependency = .left
        
        let set2 = BarChartDataSet(entries: entries2, label: "Bar 2")
        set2.stackLabels = ["Stack 1", "Stack 2"]
        set2.colors = colorsOfCharts(numbersOfColor: ITEM_COUNT)
        set2.valueTextColor = UIColor.red
        set2.valueFont = NSUIFont.systemFont(ofSize: CGFloat(10.0))
        set2.axisDependency = .left
        
        //BarChartData
        let groupSpace = 0.06
        let barSpace = 0.01
        let barWidth = 0.46
        
        // x2 dataset
        // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
        let data = BarChartData(dataSets: [set1, set2])
        data.barWidth = barWidth
        // make this BarData object grouped
        data.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)     // start at x = 0
        return data
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
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected : x = \(highlight.x)")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("chartValueNothingSelected")
    }
    
    public class BarChartFormatter: NSObject, IAxisValueFormatter
    {
        var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            let modu =  Double(value).truncatingRemainder(dividingBy: Double(months.count))
            return months[ Int(modu) ]
        }
    }
    

}
