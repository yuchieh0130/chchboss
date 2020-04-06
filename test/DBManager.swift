//
//  DBManger.swift
//  test
//
//  Created by 謝宛軒 on 2020/3/10.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import UIKit

/*inplement singleton*/
var shareInstance = DBManager()

class DBManager: NSObject {
    
    var database: FMDatabase? = nil //FMDatabase object
    override init() {
        super.init()
    }
    
    /*enable code in other class call DBManager Function*/
    class func getInstance() -> DBManager{
        if shareInstance.database == nil{
            shareInstance.database = FMDatabase(path: Util.getPath("project.db"))
        }
        return shareInstance
    }
    
    func addEvent(_ modelInfo: EventModel) -> Bool{
        shareInstance.database?.open()
        let isAdded = shareInstance.database?.executeUpdate("INSERT INTO event (event_name,start_date,start_time,end_date,end_time,isAllDay,isAutomated,isTask,hasReminder) VALUES (?,?,?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.eventName ,modelInfo.startDate,modelInfo.startTime,modelInfo.endDate,modelInfo.endTime,modelInfo.allDay,modelInfo.autoRecord,modelInfo.task,modelInfo.reminder])
        
        shareInstance.database?.close()
        return isAdded!
    }
    
    func deleteEvent(id: Int32) -> Bool{
        shareInstance.database?.open()
        let isDeleted = shareInstance.database?.executeUpdate("DELETE FROM event WHERE event_id = \(id)", withArgumentsIn:[id])
        shareInstance.database?.close()
        return isDeleted!
    }
    
    //    func deleteEvent(String: String) -> Bool{
    //        shareInstance.database?.open()
    //        let isDeleted = shareInstance.database?.executeUpdate("DELETE FROM event WHERE event_id = '\(String)'", withArgumentsIn:[String])
    //        shareInstance.database?.close()
    //        return isDeleted!
    //    }
    
    
    func editEvent(_ modelInfo: EventModel) -> Bool{
        shareInstance.database?.open()
        let isEdited = shareInstance.database?.executeUpdate("REPLACE INTO event (event_id,event_name,start_date,start_time,end_date,end_time,isAllDay,isAutomated,isTask,hasReminder) VALUES (?,?,?,?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.eventId,modelInfo.eventName ,modelInfo.startDate,modelInfo.startTime,modelInfo.endDate,modelInfo.endTime,modelInfo.allDay,modelInfo.autoRecord,modelInfo.task,modelInfo.reminder])
        shareInstance.database?.close()
        return isEdited!
    }
    
    func getEvent(String: String) -> [EventModel]!{
        
        var events: [EventModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM event WHERE start_date = '\(String)' ";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "event_id")
            let a = set?.string(forColumn: "event_name")!
            let b = set?.string(forColumn: "start_date")!
            let c = set?.string(forColumn: "start_time")
            let d = set?.string(forColumn: "end_date")!
            let e = set?.string(forColumn: "end_time")
            let f = set?.bool(forColumn: "isAllDay")
            let g = set?.bool(forColumn: "isAutomated")
            let h = set?.bool(forColumn: "isTask")
            let j = set?.bool(forColumn: "hasReminder")
            
            let event: EventModel
            
            if c == nil && e == nil{
                event = EventModel(eventId: i!, eventName: a!, startDate:b!, startTime: c, endDate: d!, endTime: e, allDay: f!, autoRecord: g!, task: h!, reminder: j!)
            }else{
                event = EventModel(eventId: i!, eventName: a!, startDate:b!, startTime: c, endDate: d!, endTime: e, allDay: f!, autoRecord: g!, task: h!, reminder: j!)
            }
            
            if events == nil{
                events = [EventModel]()
            }
            events.append(event)
        }
        set?.close()
        return events
    }
    
    func getCategory() -> [CategoryModel]!{
        
        var categories : [CategoryModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT category_id,category_name,color FROM category";
        let set = try? shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "category_id")
            let a = set?.string(forColumn: "category_name")!
            let b = set?.string(forColumn: "color")!
            
            let category: CategoryModel
            category = CategoryModel(categoryId: i!, categoryName: a!, color: b!)
            
            if categories == nil{
                categories = [CategoryModel]()
            }
            categories.append(category)
        }
        set?.close()
        return categories
    }
    
    //    func getColor() -> [String:String]{
    //
    //        var result = [String:String]()
    //        shareInstance.database?.open()
    //        let sqlString = "SELECT category_name,color FROM category";
    //        let set = try? shareInstance.database?.executeQuery(sqlString, values: [])
    //
    //        while ((set?.next())!) {
    //            let a = set?.string(forColumn: "category_name")!
    //            let b = set?.string(forColumn: "color")!
    //            result[a ?? "AA"] = b ?? "BB"
    //        }
    //        set?.close()
    //        print(result)
    //        return result
    //
    //    }
    
    func saveLocation(_ modelInfo: LocationModel) -> Bool{
        shareInstance.database?.open()
        let isSave = shareInstance.database?.executeUpdate("INSERT INTO location (longitude,latitude,start_time,end_time,location_category,location_name) VALUES (?,?,?,?,?,?)", withArgumentsIn:[modelInfo.longitude ,modelInfo.lantitude,modelInfo.startTime,modelInfo.endTime,modelInfo.locationCategory,modelInfo.locationName])
        
        shareInstance.database?.close()
        return isSave!
    }
    
}
