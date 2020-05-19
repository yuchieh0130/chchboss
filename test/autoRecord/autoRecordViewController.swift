//
//  autoRecordViewController.swift
//  test
//
//  Created by 王義甫 on 2020/4/4.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar
import Floaty

class autoRecordViewController: UIViewController{
   
    @IBOutlet var calendarView: JTAppleCalendarView!
    var selectedDay:String = ""
    var numberOfRows = 1
    
    var formatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           formatter.timeZone = TimeZone.ReferenceType.system
           return formatter
       }
    
    @IBOutlet var tableView: UITableView!
    var showTrack  = [TrackModel]()
    
    //mapview button
    @IBAction func btn(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        calendarView.scrollingMode = .stopAtEachCalendarFrame //scrolling modes
        calendarView.scrollDirection = .horizontal
        calendarView.showsVerticalScrollIndicator = false
        calendarView.reloadData(withanchor: Date()) //初始畫面顯示當月月份
        
        title = "Track"
        
        let floaty = Floaty(frame: CGRect(x: self.view.frame.width - 70, y: self.view.frame.height - 150, width: 45, height: 45))
        floaty.addItem(title:"Add Event", handler: {_ in
            self.performSegue(withIdentifier: "trackToEvent", sender: self)
        })
        floaty.addItem(title: "Add Task", handler: {_ in
            self.performSegue(withIdentifier: "trackToTask", sender: self)
        })
        self.view.addSubview(floaty)
    }

        func configureCell(view: JTAppleCell?, cellState: CellState){
            guard let cell = view as? DateCell else {return}
            cell.dateLabel.text = cellState.text
            handleCellTextColor(cell: cell, cellState: cellState)
            handleCellSelected(cell: cell, cellState: cellState)
        }
    
        func handleCellTextColor(cell:DateCell, cellState: CellState){
            if cellState.dateBelongsTo == .thisMonth{
                cell.dateLabel.textColor = UIColor.black
            }else{
                cell.dateLabel.textColor = UIColor.gray
            }
        }
        
        /*selected cell setting*/
        func handleCellSelected(cell: DateCell, cellState: CellState){
            if cellState.isSelected{
                cell.selectedView.isHidden = false
                selectedDay = formatter.string(from: cellState.date)
                if DBManager.getInstance().getDateTracks(String: selectedDay) != nil{
                    showTrack = DBManager.getInstance().getDateTracks(String: selectedDay)
                }else{
                    showTrack = [TrackModel]()
                }
                tableView.reloadData()
            }else{
                cell.selectedView.isHidden = true
                
            }
        }
        
}


    extension autoRecordViewController: JTAppleCalendarViewDataSource {
        
        func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
            
            let startDate = Date()-(60*60*24*365)
            let endDate = Date()+(60*60*24*365)
            
            if numberOfRows == 6{
                return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: numberOfRows)
            }else{
                return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: numberOfRows, generateInDates: .forFirstMonthOnly, generateOutDates: .off, hasStrictBoundaries: false)
            }
            return ConfigurationParameters(startDate: startDate, endDate: endDate, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid)
        }
    }

    extension autoRecordViewController: JTAppleCalendarViewDelegate {
        
        func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
            let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
            self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
            return cell
        }
        
        func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
            configureCell(view: cell, cellState: cellState)
        }
        
        func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState){
            configureCell(view: cell, cellState: cellState)
        }
        
        func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
            return true
        }
        
        func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date,cell: JTAppleCell?, cellState: CellState){
            configureCell(view: cell, cellState: cellState)
        }
        
        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            let visibleDates = calendarView.visibleDates()
            calendarView.viewWillTransition(to: .zero, with: coordinator, anchorDate: visibleDates.monthDates.first?.date)
        }

        func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date),at indexPath: IndexPath) -> JTAppleCollectionReusableView{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy MMMM"
            
            let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
            header.monthTitle.text = formatter.string(from: range.start)
            return header
        }
        
        func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
            return MonthSize(defaultSize: 50)
        }
}

extension autoRecordViewController: UITableViewDelegate,UITableViewDataSource {
    //DataSource管理cell數量、section數量、多少列、及顯示內容
    //Delegate處理TableView的外觀(列高、標題列高、第x列要內縮多少)及一些觸發事件
    
    //必要、需要幾個cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showTrack.count
    }
    
    //必要、設定cell的樣式
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell",for: indexPath) as! trackCell
        cell.time.text = "\(showTrack[indexPath.row].startTime) - \(showTrack[indexPath.row].endTime)"
        let category = DBManager.getInstance().getCategory(Int: showTrack[indexPath.row].categoryId)
        cell.category.text = category?.categoryName
            cell.placeName.text = showTrack[indexPath.row].placeName
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "", sender: nil)
    
    }
    
}
