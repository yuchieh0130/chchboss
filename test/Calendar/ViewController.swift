import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet var addEventButtom : UIButton!
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    var numberOfRows = 6
    
    @IBOutlet var tableView: UITableView!
    var eventId :Int32?
    var event: EventModel?

    var selectedDay:String = ""
    var showEvent = [EventModel]()
    
    
    /*func performSegue,prepare: use segue to trans to new page*/
    /*need to set segue identifier*/
    //    open override func performSegue(withIdentifier identifier: String, sender: Any?){
    //    }
    
    /*use button tag to judge whic object to triggle the button*/
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        switch segue.identifier {
        case "addEvent":
            if let addVC = segue.destination as? addViewController{
                if calendarView.selectedDates.isEmpty == false{
                    addVC.selectedDay = calendarView.selectedDates
                }
            }
        case "editEvent":
            if let editVC = segue.destination as? addViewController{
                editVC.event = event
            }
        default:
            print("")
        }
    }
    
    /*button to add event*/
    /*OR: self.presentViewController(controllername(), animated: true, completion: nil)，要切換的畫面、過場動畫、切換完成後執行的動作*/
    @IBAction func addEvent(_ sender: Any){
        event = nil
        performSegue(withIdentifier: "addEvent", sender: sender)
    }
    
    
    /*viewcontroller viewdidload*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.scrollingMode = .stopAtEachCalendarFrame //scrolling modes
        calendarView.scrollDirection = .horizontal
        calendarView.showsVerticalScrollIndicator = false
        calendarView.reloadData(withanchor: Date()) //初始畫面顯示當月月份
        
        //註冊.xib檔
        //self.tableView.register(UINib(nibName: "eventTableViewCell", bundle: nil), forCellReuseIdentifier: "eventTableViewCell")
        
        title = "Calendar"
    }
    
    override func viewWillAppear(_ animated: Bool){
           calendarView.reloadData()
       }
       
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    /*cell view setting*/
    func configureCell(view: JTAppleCell?, cellState: CellState){
        guard let cell = view as? DateCell else {return}
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        showDotView(cell: cell, cellState: cellState)
    }
    
    /*inDates and outDates cell setting*/
    //list of dateBelongsTo:thisMonth, previousMonthWithinboundary, previousMonthOutsideboundary, followingMonthWithinboundary, followingMonthOutsideboundary*/
    //hidden inDates and outDates: cell.isHidden = false/true
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
            if DBManager.getInstance().getEvent(String: selectedDay) != nil{
                showEvent = DBManager.getInstance().getEvent(String: selectedDay)
            }else{
                showEvent = [EventModel]()
            }
            tableView.reloadData()
        }else{
            cell.selectedView.isHidden = true
            
        }
    }
    
    /*dot view*/
    func showDotView(cell: DateCell, cellState: CellState) {
        if DBManager.getInstance().getEvent(String: formatter.string(from: cellState.date)) != nil{
            cell.dotView.isHidden = false
        }else{
            cell.dotView.isHidden = true
        }
    }
    
    /*func to change color*/
    //    func hexStringToUIColor (hex:String) -> UIColor {
    //        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    //
    //        if (cString.hasPrefix("#")) {
    //            cString.remove(at: cString.startIndex)
    //        }
    //
    //        if ((cString.count) != 6) {
    //            return UIColor.gray
    //        }
    //
    //        var rgbValue:UInt64 = 0
    //        Scanner(string: cString).scanHexInt64(&rgbValue)
    //
    //        return UIColor(
    //            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
    //            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
    //            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
    //            alpha: CGFloat(1.0)
    //        )
    //    }
    
    //    func color(cell: DateCell, cellState: CellState){
    //        for _ in calendarDataSource.keys{
    //            if cellState.day == .monday {
    //                cell.dotView.backgroundColor = hexStringToUIColor(hex:"ff5f5b")
    //                //print(calendarDataSource[a])
    //            }
    //        }
    //    }
    
    /*button to change between week and month*/
    @IBAction func toogle(_ sender: Any){
        if numberOfRows == 6{
            self.constraint.constant = 100
            self.numberOfRows = 1
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }){
                completed in
                self.calendarView.reloadData(withanchor: Date()) //anchordDate is optional
            }
        }else{
            self.constraint.constant = 350
            self.numberOfRows = 6
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.calendarView.reloadData(withanchor: Date())
            })
        }
    }
    
}


extension ViewController: JTAppleCalendarViewDataSource {
    
    /*configureCalendar full parameter list: startDate, endDate, numberOfRows, calendar(region/timezone/Arabic), generateInDates(last month day), generateOutDates(next month day), firstDatOfWeek, hasStrictBoundaries(control month boundaries, true/false)*/
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

extension ViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
     //To-Do: 長按可以一次選好幾天、可以反選、預設今天為第一天？
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState){
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date,cell: JTAppleCell?, cellState: CellState){
        configureCell(view: cell, cellState: cellState)
    }
    
    /*rotation: set the first visible monthDates as anchor focus date*/
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let visibleDates = calendarView.visibleDates()
        calendarView.viewWillTransition(to: .zero, with: coordinator, anchorDate: visibleDates.monthDates.first?.date)
    }
    
    /*header delegate*/
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

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    //DataSource管理cell數量、section數量、多少列、及顯示內容
    //Delegate處理TableView的外觀(列高、標題列高、第x列要內縮多少)及一些觸發事件
    
    //必要、需要幾個cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showEvent.count
    }
    
    //必要、設定cell的樣式
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:eventTableViewCell = tableView.dequeueReusableCell(withIdentifier: "eventTableViewCell", for: indexPath) as! eventTableViewCell
        cell.eventName?.text = showEvent[indexPath.row].eventName
        if showEvent[indexPath.row].startTime != nil && showEvent[indexPath.row].endTime != nil{
            let time = showEvent[indexPath.row].startTime! + "-" + showEvent[indexPath.row].endTime!
            cell.eventTime?.text = time
        }else{
            cell.eventTime?.text = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        event = showEvent[indexPath.row]
        performSegue(withIdentifier: "editEvent", sender: nil)
    }
    
}



