//
//  timeline.swift
//  test
//
//  Created by 謝宛軒 on 2020/7/1.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

public struct Style {
    public var timeline = TimelineStyle()
    public init() {}
}

public struct TimelineStyle {
    //public var startFromFirstEvent: Bool = true
    //public var eventFont: UIFont = .boldSystemFont(ofSize: 12)
    public var offsetEvent: CGFloat = 1
    public var startHour: Int = 0
    public var heightLine: CGFloat = 0.5
    public var offsetLineLeft: CGFloat = 10
    public var offsetLineRight: CGFloat = 10
    public var backgroundColor: UIColor = .white
    public var widthTime: CGFloat = 40
    public var heightTime: CGFloat = 20
    public var offsetTimeX: CGFloat = 10
    public var offsetTimeY: CGFloat = 50
    public var timeColor: UIColor = .gray
    public var timeFont: UIFont = .systemFont(ofSize: 12)
    public var scrollToCurrentHour: Bool = true
    public var widthEventViewer: CGFloat = 0
    public var iconFile: UIImage? = nil
    public var colorIconFile: UIColor = .black
    public var showCurrentLineHour: Bool = true
//    public var currentLineHourFont: UIFont = .systemFont(ofSize: 12)
//    public var currentLineHourColor: UIColor = .red
//    public var currentLineHourWidth: CGFloat = 50
//    public var movingMinutesColor: UIColor = .systemBlue
//    public var shadowColumnColor: UIColor = .systemTeal
//    public var shadowColumnAlpha: CGFloat = 0.1
}

final class TimelineLabel: UILabel {
    var valueHash: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TimelineView: UIView{
    
    var hours = [String]()
    private var style = Style()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = style.timeline.backgroundColor
        return scroll
    }()
    
    private func createTimesLabel(start: Int) -> [TimelineLabel] {
        
        var times = [TimelineLabel]()
        
//        for hr in 0...24{
//            var string = hr < 10 ? "0" + "\(hr)" : "\(hr)"
//            for min in 0...59{
//                let i = min < 10 ? "0" + "\(hr)" : "\(hr)"
//                string.append("\(i)")
//            }
//            hours.append(string)
//        }
        for (idx, hour) in hours.enumerated() where idx >= start {
        let yTime = (style.timeline.offsetTimeY + style.timeline.heightTime) * CGFloat(idx - start)
        let time = TimelineLabel(frame: CGRect(x: style.timeline.offsetTimeX,
                                               y: yTime,
                                               width: style.timeline.widthTime,
                                               height: style.timeline.heightTime))
            time.tag = idx - start
            times.append(time)
        }
        return times
    }
    
    private func createLines(times: [TimelineLabel]) -> [UIView] {
        var lines = [UIView]()
        for (idx, time) in times.enumerated() {
            let xLine = time.frame.width + style.timeline.offsetTimeX + style.timeline.offsetLineLeft
            let lineFrame = CGRect(x: xLine,
                                   y: time.center.y,
                                   width: frame.width - xLine,
                                   height: style.timeline.heightLine)
            let line = UIView(frame: lineFrame)
            line.backgroundColor = .gray
            line.tag = idx
            lines.append(line)
        }
        return lines
    }
    
    func create(){
        let start = 0
        let times = createTimesLabel(start: start)
        let lines = createLines(times: times)
        
        let heightAllTimes = times.reduce(0, { $0 + ($1.frame.height + style.timeline.offsetTimeY) })
        scrollView.contentSize = CGSize(width: frame.width, height: heightAllTimes + 20)
        times.forEach({ scrollView.addSubview($0) })
        lines.forEach({ scrollView.addSubview($0) })

        let offset = style.timeline.widthTime + style.timeline.offsetTimeX + style.timeline.offsetLineLeft
        //let widthPage = (frame.width - offset) / CGFloat(dates.count)
        let widthPage = (frame.width - offset) / 1
        let heightPage = (CGFloat(times.count) * (style.timeline.heightTime + style.timeline.offsetTimeY)) - 75
    }
    
    init(style: Style, frame: CGRect) {
        for hr in 0...24{
            var string = hr < 10 ? "0" + "\(hr)" : "\(hr)"
            for min in 0...59{
                let i = min < 10 ? "0" + "\(hr)" : "\(hr)"
                string.append("\(i)")
            }
            hours.append(string)
        }
        self.style = style
        super.init(frame: frame)
        
        var scrollFrame = frame
        scrollFrame.origin.y = 0
        scrollView.frame = scrollFrame
        addSubview(scrollView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
