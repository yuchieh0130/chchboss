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
    var showDayformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    var showCategory = [CategoryModel]()
    var showCategoryStr = [String]()
    var showCategoryColor = [String]()
    var name = "Behaviors"
    var color = UIColor()
    var time = "Time"
    var segConIndex = 0
    var years: [String]!
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var monthsFullName = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var monthDays: [String] = []
    var value = [7.5, 7.0, 7.2, 5.9, 5.4, 4.5, 0.0, 21.7, 12.1, 0.0, 0.0, 0.0]
    var valueForMonth = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    
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
        
//        let currentDate = showDayformatter.string(from: Date())
//        showTimeLabel = currentDate
        
        let startWeekDay = showDayformatter.string(from: startOfWeek!)
        let endWeekDay = showDayformatter.string(from: endOfWeek!)
        showTimeLabel = "\(startWeekDay) ~ \(endWeekDay)"
        
        let data = CombinedChartData()
        //data.lineData = generateLineData(dataPoints: days, values: value)
        data.barData = generateBarData(dataPoints: days, values: value)
        combineChart.data = data
        //x axis
        combineChart.xAxis.labelPosition = .bottom
        combineChart.xAxis.labelFont = UIFont.systemFont(ofSize: 11.8)
        combineChart.xAxis.drawGridLinesEnabled = false
        combineChart.xAxis.granularityEnabled = true
        combineChart.xAxis.granularity = 1.0  //距離
        combineChart.xAxis.axisMinimum = data.xMin - 0.5
        combineChart.xAxis.axisMaximum = data.xMax + 0.5
        combineChart.xAxis.centerAxisLabelsEnabled = false
        combineChart.xAxis.labelCount = 7
        combineChart.xAxis.valueFormatter = self
        combineChart.leftAxis.labelFont = UIFont.systemFont(ofSize: 15.0)
    
        var years: [String] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...12{
                years.append("\(year)")
                year -= 1
            }
        }
        self.years = years
        
        timeLabel.isHidden = true
        combineChart.isHidden = false
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
            timeLabel.isHidden = true
            combineChart.isHidden = false
            let startWeekDay = showDayformatter.string(from: startOfWeek!)
            let endWeekDay = showDayformatter.string(from: endOfWeek!)
            showTimeLabel = "\(startWeekDay) ~ \(endWeekDay)"
            
            let data = CombinedChartData()
            data.lineData = generateLineData(dataPoints: days, values: value)
            data.barData = generateBarData(dataPoints: days, values: value)
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
        }else if getIndex == 1{
            timeLabel.isHidden = true
            combineChart.isHidden = false
            showTimeLabel = monthsFullName[currentMonth - 1] + " \(currentYear)"
            
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
            
            let data = CombinedChartData()
            data.lineData = generateLineData(dataPoints: monthDays, values: valueForMonth)
            data.barData = generateBarData(dataPoints: monthDays, values: valueForMonth)
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
        }else if getIndex == 2{
            timeLabel.isHidden = true
            combineChart.isHidden = false
            showTimeLabel = "\(currentYear)"
            
            let data = CombinedChartData()
            data.lineData = generateLineData(dataPoints: months, values: value)
            data.barData = generateBarData(dataPoints: months, values: value)
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
                vc.tag = "analysisWeek"
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
                    showCategory = DBManager.getInstance().getAllCategory()
                    showTimeLabel = (vc!.pickerViewWeek.dateWeek)
                }
            }else if segConIndex == 1{
                let vc = segue.source as? PickerViewController
                tag = vc?.tag
                if tag == "combineChartMonthYear"{
                    showCategory = DBManager.getInstance().getAllCategory()
                    showTimeLabel = vc!.pickerViewMonthYear.dateMonthYear
                    
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
                    let data = CombinedChartData()
                    data.lineData = generateLineData(dataPoints: monthDays, values: valueForMonth)
                    data.barData = generateBarData(dataPoints: monthDays, values: valueForMonth)
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
                }
            }else if segConIndex == 2{
                let vc = segue.source as? PickerViewYearController
                tag = vc?.tag
                if tag == "combineChartYear"{
                    showTimeLabel = vc!.pickerViewYear.dateYear
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

