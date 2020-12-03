//
//  timeline.swift
//  test
//
//  Created by 謝宛軒 on 2020/7/1.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class timeline : UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate{
    
    var myScrollView: UIScrollView!
    var fullSize :CGSize!
    var hourSize = 0
    var hours = [String]()
    var date = ""
    var showDate = ""
    var trackViews = [UIButton]()
    
    var showTrack  = [TrackModel]()
    var track :TrackModel?
    var tap = UITapGestureRecognizer()
    
    var showTimeformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    var showDayformatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           formatter.timeZone = TimeZone.ReferenceType.system
           return formatter
       }
    
    var showDateTimeformatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm"
           formatter.timeZone = TimeZone.ReferenceType.system
           return formatter
       }
    
    override func viewDidLoad(){
        fullSize = UIScreen.main.bounds.size
        hourSize = Int(fullSize.height/5)
        myScrollView = UIScrollView()
        //可見視圖範圍
        myScrollView.frame = CGRect(x: 0, y: 60, width: fullSize.width,height: fullSize.height - 20)
        //實際視圖範圍
        myScrollView.contentSize = CGSize(width: fullSize.width,height:fullSize.height/5*24+80)
        //滑動條
        myScrollView.showsVerticalScrollIndicator = true
        myScrollView.showsHorizontalScrollIndicator = false
        myScrollView.indicatorStyle = .black
        myScrollView.isScrollEnabled = true
        myScrollView.delegate = self
        
        self.view.addSubview(myScrollView)
        timelabel()
        createTimeLines(hours: hours,view:myScrollView)

        let dateLabel = UIButton.init(type: .custom)
        dateLabel.setTitle("\(showDate)", for: .normal)
        dateLabel.setTitleColor(UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1), for: .normal)
        dateLabel.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: dateLabel)]
        
//        tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool){
           trackViews.forEach({$0.removeFromSuperview()})
           if DBManager.getInstance().getDateTracks(String: date) != nil{
               showTrack = DBManager.getInstance().getDateTracks(String: date)
            createTracks(view: myScrollView)
           }else{
               showTrack = [TrackModel]()
           }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTrack"{
            if let VC = segue.destination as? editAutoRecordViewController{
                VC.track = track!
            }
        }
    }
    
    @IBAction func editAutoSegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "editAutoSegueBack"{
            //showTrack = DBManager.getInstance().getDateTracks(String: date)
            //view.subviews.forEach({$0.removeFromSuperview()})
            //subviews
            //subviews.forEach({ $0.removeFromSuperview() })
            
            createTracks(view: myScrollView)
        }
    }
    
    
    func timelabel(){
        for hr in 0...24{
            var string = hr < 10 ? "0" + "\(hr)" : "\(hr)"
//            for min in 0...59{
//                let i = min < 10 ? "0" + "\(hr)" : "\(hr)"
//                string.append("\(i)")
//            }
            string.append(":00")
            hours.append(string)
        }
    }
    
    func createTimeLines(hours: [String],view: UIScrollView){
        for i in 0...24{
            let time = UILabel(frame:CGRect(x:20,y:hourSize*i,width: 55,height: 50))
            time.text = hours[i]
            time.font = .boldSystemFont(ofSize: 18)
            time.textColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
            let line = UIView(frame:CGRect(x:90,y:hourSize*i+25,width:Int(fullSize.width)-110,height: 1))
            line.backgroundColor = UIColor.gray
            view.addSubview(time)
            view.addSubview(line)
            
        }
    }
    
    func createTracks(view: UIScrollView){
        var drawStart = ""
        var drawEnd = ""
        for i in 0...showTrack.count-1{
            drawStart = showTrack[i].startTime
            drawEnd = showTrack[i].endTime
            if showTrack[i].startDate != date{
                drawStart = "00:00"
            }
            if showTrack[i].endDate != date{
                drawEnd = "23:59"
            }
            let height = (showTimeformatter.date(from: drawEnd)?.timeIntervalSince(showTimeformatter.date(from: drawStart)!))!/3600*Double(hourSize)
            let y = (showTimeformatter.date(from: drawStart)?.timeIntervalSince(showTimeformatter.date(from: "00:00")!))!/3600*Double(hourSize)
//            let height = (showTimeformatter.date(from: showTrack[i].endTime)?.timeIntervalSince(showTimeformatter.date(from: showTrack[i].startTime)!))!/3600*Double(hourSize)
//            let y = (showTimeformatter.date(from: showTrack[i].startTime)?.timeIntervalSince(showTimeformatter.date(from: "00:00")!))!/3600*Double(hourSize)
            let category = DBManager.getInstance().getCategory(Int: showTrack[i].categoryId)
            let trackView = UIButton(frame:CGRect(x:90,y:26+Int(y),width: Int(fullSize.width)-110,height: Int(height)-4))
            trackView.tag = i
            trackView.backgroundColor = hexStringToUIColor(hex: category!.categoryColor)
            trackView.layer.borderWidth = 2.5
            trackView.layer.borderColor = hexStringToUIColor_border(hex: category!.categoryColor).cgColor
//            trackView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//            trackView.layer.shadowOpacity = 0.2
//            trackView.layer.shadowOffset = CGSize(width: 5, height: 5)
            trackView.layer.cornerRadius = 10
            trackView.addTarget(self, action: #selector(self.editAutoRecord), for: .touchUpInside)
            let categoryLabel: UILabel!
            if height < 70{
                categoryLabel = UILabel(frame:CGRect(x:20,y:0,width: 500,height: height))
            }else{
                categoryLabel = UILabel(frame:CGRect(x:20,y:20,width: 500,height: 50))
            }
            categoryLabel.text = "\(category!.categoryName)"
            categoryLabel.font = .boldSystemFont(ofSize: 16)
            trackView.addSubview(categoryLabel)
            //trackView.layer.borderColor = hexStringToUIColor_border(hex: category!.categoryColor).cgColor
            //trackView.layer.borderWidth = 3
            trackViews.append(trackView)
            view.addSubview(trackView)
        }
    }
    
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
//    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
//        performSegue(withIdentifier: "editTrack", sender:self )
//    }
    
    @IBAction func addTrack(_ sender: UIButton){
        
    }
    
    
    @objc func editAutoRecord(sender: UIButton!){
        track = showTrack[sender.tag]
        performSegue(withIdentifier: "editTrack", sender:self )
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
            alpha: CGFloat(0.3)
        )
    }
    
    func hexStringToUIColor_border (hex:String) -> UIColor {
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
            alpha: CGFloat(1)
        )
    }
}
