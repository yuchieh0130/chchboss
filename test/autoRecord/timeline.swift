//
//  timeline.swift
//  test
//
//  Created by 謝宛軒 on 2020/7/1.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class timeline : UIViewController, UIScrollViewDelegate{
    
    var myScrollView: UIScrollView!
    var fullSize :CGSize!
    var hourSize = 0
    
    var hours = [String]()
    var date = ""
        
    var showDayformatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           formatter.timeZone = TimeZone.ReferenceType.system
           return formatter
       }
    
    override func viewDidLoad(){
        fullSize = UIScreen.main.bounds.size
        hourSize = Int(fullSize.height/4)
        myScrollView = UIScrollView()
        //可見視圖範圍
        myScrollView.frame = CGRect(x: 0, y: 100, width: fullSize.width,height: fullSize.height - 20)
        //實際視圖範圍
        myScrollView.contentSize = CGSize(width: fullSize.width,height: fullSize.height * 6+80)
        //滑動條
        myScrollView.showsVerticalScrollIndicator = true
        myScrollView.showsHorizontalScrollIndicator = false
        myScrollView.indicatorStyle = .black
        myScrollView.isScrollEnabled = true
        myScrollView.delegate = self
        
        self.view.addSubview(myScrollView)
        timelabel()
        createTimeLines(hours: hours,view:myScrollView)
        let dateLabel = UILabel(frame:CGRect(x:view.center.x-50,y:50,width: 100,height: 40))
        dateLabel.text = date
        self.view.addSubview(dateLabel)
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
            let time = UILabel(frame:CGRect(x:20,y:hourSize*i+50,width: 50,height: 50))
            time.text = hours[i]
            let line = UIView(frame:CGRect(x:80,y:hourSize*i+25+50,width:Int(fullSize.width)-100,height: 1))
            line.backgroundColor = UIColor.gray
            view.addSubview(time)
            view.addSubview(line)
            
        }
    }
    
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
