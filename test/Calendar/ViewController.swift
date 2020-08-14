import UIKit
import JTAppleCalendar
import Floaty

class ViewController: UIViewController{
    
    @IBOutlet var safeArea: UIView!
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet weak var calendarLayout: NSLayoutConstraint!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var testCalendar = Calendar.current
    
    var showDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    var showMonthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    var showYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    var numberOfRows = 6
    
    @IBOutlet var tableView: UITableView!
    var eventId :Int32?
    var event: EventModel?
    var task: TaskModel?

    var selectedDay = ""
    var showEvent = [EventModel]()
    var showTask = [TaskModel]()
    
    /*func performSegue,prepare: use segue to trans to new page*/
    /*need to set segue identifier*/
    //    open override func performSegue(withIdentifier identifier: String, sender: Any?){
    //    }
    
    /*use button tag to judge whic object to triggle the button*/
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        switch segue.identifier {
        case "addEvent":
            if let navVC = segue.destination as? UINavigationController, let
                addVC = navVC.topViewController as? addViewController{
                if calendarView.selectedDates.isEmpty == false{
                    addVC.selectedDay = calendarView.selectedDates
                }
            }
        case "editEvent":
            if let navVC = segue.destination as? UINavigationController, let
                editVC = navVC.topViewController as? addViewController{
                editVC.event = event
            }
        case "editCalTask":
            if let navVC = segue.destination as? UINavigationController, let
                editVC = navVC.topViewController as? addTaskViewController{
                editVC.task = task
            }
        case "eventAddTask":
            if let navVC = segue.destination as? UINavigationController, let addVC = navVC.topViewController as? addTaskViewController{
                addVC.task = task
            }
        case "timeline":
            if let VC = segue.destination as? timeline{
                VC.date = selectedDay
            }
        default:
            print("")
        }
    }
    
    /*button to add event*/
    /*OR: self.presentViewController(controllername(), animated: true, completion: nil)，要切換的畫面、過場動畫、切換完成後執行的動作*/
    @objc func addEvent(_ sender: Any){
        event = nil
        performSegue(withIdentifier: "addEvent", sender: sender)
    }
    
    @objc func locationDB(_ sender: Any){
        event = nil
        performSegue(withIdentifier: "tete", sender: sender)
    }
    
    
    /*viewcontroller viewdidload*/
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLayoutSubviews()
        
        let addBtn = UIBarButtonItem(title: "＋", style: .plain, target: self, action: #selector(addEvent(_:)))
        navigationItem.leftBarButtonItems = [addBtn]
        let locationDBBtn = UIBarButtonItem(title: "loc", style: .plain, target: self, action: #selector(locationDB(_:)))
        let todayBtn = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(transToTaday(_:)))
//        let weekBtn = UIBarButtonItem(title: "Week", style: .plain, target: self, action: #selector(toogle(_:)))
        navigationItem.rightBarButtonItems = [todayBtn, locationDBBtn]
        
        calendarView.scrollingMode = .stopAtEachSection //scrolling modes
        calendarView.scrollDirection = .horizontal
        calendarView.showsVerticalScrollIndicator = false
        calendarLayout.constant = safeArea.frame.size.height/2.5

        //初始畫面顯示
        yearLabel.text = showYearFormatter.string(from: Date())
        monthLabel.text = showMonthFormatter.string(from: Date())
        //註冊.xib檔
        //self.tableView.register(UINib(nibName: "eventTableViewCell", bundle: nil), forCellReuseIdentifier: "eventTableViewCell")
        
        title = "Calendar"
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let floaty = Floaty(frame: CGRect(x: self.view.frame.width - 67, y: self.view.frame.height - 145, width: 45, height: 45))
        floaty.buttonColor = UIColor(red: 247/255, green: 199/255, blue: 88/255, alpha: 1)
        floaty.plusColor = UIColor.white
        floaty.itemButtonColor = UIColor(red: 67/255, green: 76/255, blue: 123/255, alpha: 1)
        floaty.itemTitleColor =  UIColor(red: 67/255, green: 76/255, blue: 123/255, alpha: 1)
//        UIColor(red: 190/255, green: 155/255, blue: 116/255, alpha: 1)
        floaty.overlayColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        floaty.itemShadowColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        if #available(iOS 13.0, *) {
            floaty.addItem("Add Task", icon: UIImage(systemName: "doc.text"), handler: {_ in
                self.performSegue(withIdentifier: "eventAddTask", sender: self)
            })
            floaty.addItem("Add Event", icon: UIImage(systemName: "calendar"), handler: {_ in
                self.performSegue(withIdentifier: "addEvent", sender: self)
            })
        } else {
            floaty.addItem("Add Task", icon: UIImage(named: "task"), handler: {_ in
                self.performSegue(withIdentifier: "eventAddTask", sender: self)
            })
            floaty.addItem("Add Event", icon: UIImage(named: "calendar"), handler: {_ in
                self.performSegue(withIdentifier: "addEvent", sender: self)
            })
        }
        floaty.openAnimationType = .slideUp
        floaty.isDraggable = true
        floaty.hasShadow = false
        floaty.autoCloseOnTap = true
        floaty.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(floaty)
    }
    
    override func viewWillAppear(_ animated: Bool){
        //初始畫面顯示
        //calendarView.frame.height = UIScreen.main.bounds.height/2
        //calendarView.bounds.height = UIScreen.main.bounds.height/2
        
        if selectedDay == ""{
            calendarView.reloadData(withanchor: Date())
            monthLabel.text = showMonthFormatter.string(from: Date())
        }else{
            calendarView.reloadData(withanchor: showDayFormatter.date(from: selectedDay))
            monthLabel.text = showMonthFormatter.string(from: showDayFormatter.date(from: selectedDay)!)
        }
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
          
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
       }
    
    @IBAction func eventUnwindSegue(segue: UIStoryboardSegue){
        if segue.identifier == "eventUnwindSegue"{
            let VC = segue.source as? addViewController
            var added = [Date]()
            added.append(showDayFormatter.date(from: VC!.startDate)!)
        if calendarView.selectedDates != added{
             calendarView.selectDates(added)
        }
            calendarView.reloadData()
        }
    }
    
    
//    @IBAction func nextMonth(_ sender: Any){
//        calendarView.scrollToDate(calendarView.visibleDates().monthDates.last!.date+86400, triggerScrollToDateDelegate: true, animateScroll: true, preferredScrollPosition: .none, extraAddedOffset: .zero, completionHandler: nil)
//    }
//
//    @IBAction func lastMonth(_ sender: Any){
//        calendarView.scrollToDate(calendarView.visibleDates().monthDates.first!.date-86400, triggerScrollToDateDelegate: true, animateScroll: true, preferredScrollPosition: .none, extraAddedOffset: .zero, completionHandler: nil)
//    }
    
    
    
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
        if cellState.isSelected && cellState.dateBelongsTo == .thisMonth{
            cell.selectedView.isHidden = false
            selectedDay = showDayFormatter.string(from: cellState.date)
            if DBManager.getInstance().getEvents(String: selectedDay) != nil{
                showEvent = DBManager.getInstance().getEvents(String: selectedDay)
            }else{
                showEvent = [EventModel]()
            }
            if DBManager.getInstance().getDateTasks(String: selectedDay) != nil{
                showTask = DBManager.getInstance().getDateTasks(String: selectedDay)
            }else{
                 showTask = [TaskModel]()
            }
            tableView.reloadData()
        }else{
            cell.selectedView.isHidden = true
            
        }
    }
    
    /*dot view*/
    func showDotView(cell: DateCell, cellState: CellState) {
        if DBManager.getInstance().getEvents(String: showDayFormatter.string(from: cellState.date)) != nil{
            cell.dotView_event.isHidden = false
        }else{
            cell.dotView_event.isHidden = true
        }
        if DBManager.getInstance().getDateTasks(String: showDayFormatter.string(from: cellState.date)) != nil{
            cell.dotView_task.isHidden = false
        }else{
            cell.dotView_task.isHidden = true
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
    
    @objc func transToTaday(_ sender: Any){
        calendarView.reloadData(withanchor: Date())
        monthLabel.text = showMonthFormatter.string(from: Date())
    }
    
    /*button to change between week and month*/
    @objc func toogle(_ sender: Any){
        if numberOfRows == 6 {
            self.numberOfRows = 1
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }){
                completed in
                if self.selectedDay == ""{
                    self.calendarView.reloadData(withanchor: Date())
                    self.monthLabel.text = self.showMonthFormatter.string(from: Date())
                }else{
                    self.calendarView.reloadData(withanchor: self.showDayFormatter.date(from: self.selectedDay))
                    self.monthLabel.text = self.showMonthFormatter.string(from: self.showDayFormatter.date(from: self.selectedDay)!)
                }
                //self.calendarView.reloadData(withanchor: Date()) //anchordDate is optional
            }
        }else{
            self.numberOfRows = 6
//            if calendarView.visibleDates().outdates.count < 7{
//                self.numberOfRows = 5
//            }else{
//                self.numberOfRows = 6
//            }
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
        
        let parameters = ConfigurationParameters(startDate: startDate,
        endDate: endDate,
        numberOfRows: numberOfRows,
        calendar: testCalendar,
        generateInDates: .forAllMonths,
        generateOutDates: .tillEndOfRow,
        firstDayOfWeek: .sunday,
        hasStrictBoundaries: true)
        
        return parameters
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
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if cell?.isSelected == true{
            calendarView.deselectDates(from: date)
            selectedDay = ""
            showEvent.removeAll()
            showTask.removeAll()
            //showEvent = [EventModel]()
            //showTask = [TaskModel]()
            tableView.reloadData()
            return false
        }else{
            return true
        }
//        if cellState.dateBelongsTo != .thisMonth{
//            calendarView.deselectDates(from: date)
//            return false
//        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState){
        configureCell(view: cell, cellState: cellState)
    }
    
    /*rotation: set the first visible monthDates as anchor focus date*/
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let visibleDates = calendarView.visibleDates()
        calendarView.viewWillTransition(to: .zero, with: coordinator, anchorDate: visibleDates.monthDates.first?.date)
    }
    
    /*header delegate*/
 //   func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date),at indexPath: IndexPath) -> JTAppleCollectionReusableView{
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy MMMM"
//        
 //       let header = JTAppleCollectionReusableView()
        //calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
//        header.monthTitle.text = formatter.string(from: range.start)
  //      return header
//    }
    
//    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
//        return MonthSize(defaultSize: 50)
//    }
    
    func calendar(_ calendar: JTAppleCalendarView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        monthLabel.text = showMonthFormatter.string(from: visibleDates.monthDates[0].date)
        yearLabel.text = showYearFormatter.string(from: visibleDates.monthDates[0].date)
        
//        if calendarView.visibleDates().outdates.count < 7{
//            self.numberOfRows = 5
//        }else{
//            self.numberOfRows = 6
//        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        //self.calendarView.reloadDates(visibleDates.monthDates)

//        monthLabel.text = showMonthFormatter.string(from: calendarView.visibleDates().monthDates.last!.date)
//        yearLabel.text = showYearFormatter.string(from: calendarView.visibleDates().monthDates.last!.date)
    }

    
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    //DataSource管理cell數量、section數量、多少列、及顯示內容
    //Delegate處理TableView的外觀(列高、標題列高、第x列要內縮多少)及一些觸發事件
    
    //必要、需要幾個cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedDay != ""{
            return showTask.count+showEvent.count+1
        }else{
             return 0
        }
    }
    
    //必要、設定cell的樣式
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = showTask.count
        if indexPath.row == 0{
            let cell0 : timelineCell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as! timelineCell
            cell0.selectionStyle = .none
            return cell0
        }else if indexPath.row-1 < showTask.count{
            let cell1 : calTaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: "calTaskTableViewCell", for: indexPath) as! calTaskTableViewCell
            cell1.taskName.text = showTask[indexPath.row-1].taskName
            cell1.taskTime.text = showTask[indexPath.row-1].taskDeadline
            if showTask[indexPath.row-1].isDone == false{
                cell1.taskDone.isHidden = true
            }else{
                cell1.taskDone.isHidden = false
                cell1.taskDone.text = "DONE"
                cell1.taskDone.textColor = UIColor(red: 107/255, green: 123/255, blue: 228/255, alpha: 1)
                cell1.taskDone.font = UIFont.boldSystemFont(ofSize: 16.0)
                
            }
            return cell1
        }else{
            let cell2 : eventTableViewCell = tableView.dequeueReusableCell(withIdentifier: "eventTableViewCell", for: indexPath) as! eventTableViewCell
            cell2.eventName?.text = showEvent[indexPath.row-1-i].eventName
//            if showEvent[indexPath.row-i].startTime != nil && showEvent[indexPath.row-i].endTime != nil
            if showEvent[indexPath.row-1-i].allDay != true{
                let time = showEvent[indexPath.row-1-i].startTime + "-" + showEvent[indexPath.row-1-i].endTime
                cell2.eventTime?.text = time
            }else{
                cell2.eventTime?.text = "all day"
            }
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let i = showTask.count
        if indexPath.row == 0{
            performSegue(withIdentifier: "timeline", sender: nil)
        }else if indexPath.row-1 < showTask.count{
            task = showTask[indexPath.row-1]
            if task?.isDone == false {
                performSegue(withIdentifier: "editCalTask", sender: nil)
            }else if task?.isDone == true{
                let controller = UIAlertController(title: "Task is DONE", message: "This task is marked as DONE", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(okAction)
                present(controller, animated: true, completion: nil)
            }
        }else{
            event = showEvent[indexPath.row-i-1]
            performSegue(withIdentifier: "editEvent", sender: nil)
        }
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UIScreen.main.bounds.height/24
        }else{
            return UIScreen.main.bounds.height/12
        }
    }
    
}



