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
    
    func editEvent(_ modelInfo: EventModel) -> Bool{
        shareInstance.database?.open()
        let isEdited = shareInstance.database?.executeUpdate("REPLACE INTO event (event_id,event_name,start_date,start_time,end_date,end_time,isAllDay,isAutomated,isTask,hasReminder) VALUES (?,?,?,?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.eventId,modelInfo.eventName ,modelInfo.startDate,modelInfo.startTime,modelInfo.endDate,modelInfo.endTime,modelInfo.allDay,modelInfo.autoRecord,modelInfo.task,modelInfo.reminder])
        shareInstance.database?.close()
        return isEdited!
    }
    
    func getEvent(String: String) -> [EventModel]!{
        
        var events: [EventModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM event WHERE start_date <= '\(String)' and end_date >= '\(String)'";
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
        let sqlString = "SELECT category_id,category_name,category_color,category_image FROM category";
        let set = try? shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "category_id")
            let a = set?.string(forColumn: "category_name")!
            let b = set?.string(forColumn: "category_color")!
            let c = set?.string(forColumn: "category_image")!
            
            let category: CategoryModel
            category = CategoryModel(categoryId: i!, categoryName: a!, categoryColor: b!, category_image: c!)
            
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
        let isSave = shareInstance.database?.executeUpdate("INSERT INTO location (longitude,latitude,start_time,end_time,location_category,location_name,nearest_name,nearest_category) VALUES (?,?,?,?,?,?)", withArgumentsIn:[modelInfo.longitude ,modelInfo.latitude,modelInfo.startTime,modelInfo.endTime,modelInfo.nearestName,modelInfo.nearestCategory])
        
        shareInstance.database?.close()
        return isSave!
    }
    
    func getLocation(String: String) -> LocationModel!{
        
        var location : LocationModel!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM location WHERE location_id = '\(String)' ";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "location_id")
            let a = set?.double(forColumn: "longitude")
            let b = set?.double(forColumn: "latitude")
            let c = set?.string(forColumn: "start_time")!
            let d = set?.string(forColumn: "end_time")!
            let e = set?.string(forColumn: "nearest_name")
            let f = set?.string(forColumn: "nearest_category")
            
            location = LocationModel(locationId: i!, longitude: a!, latitude: b!, startTime: c!, endTime: d!, nearestName: e!, nearestCategory: f!)
        }
        
        set?.close()
        return location
    }
    
    func savePlace(_ modelInfo: PlaceModel) -> Bool{
        shareInstance.database?.open()
        let isSave = shareInstance.database?.executeUpdate("INSERT INTO savedPlace (place_name,place_category,place_longtitude,place_lantitude) VALUES (?,?,?,?)", withArgumentsIn:[modelInfo.placeName ,modelInfo.placeCategory,modelInfo.placeLongtitude,modelInfo.placeLantitude])
        
        shareInstance.database?.close()
        return isSave!
    }
    
    func getPlace() -> PlaceModel!{
           
           var place : PlaceModel!
           shareInstance.database?.open()
           let sqlString = "SELECT * FROM savedPlace ";
           let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
           
           while ((set?.next())!) {
               let i = set?.int(forColumn: "place_id")
               let a = set?.string(forColumn: "place_name")
               let b = set?.string(forColumn: "place_category")
               let c = set?.double(forColumn: "place_longtitude")
               let d = set?.double(forColumn: "place_lantitude")
               
               place = PlaceModel(placeId: i!, placeName: a!, placeCategory: b!, placeLongtitude: c!, placeLantitude: d!)
           }
           set?.close()
           return place
    }
    
    func addTask(_ modelInfo: TaskModel) -> Bool{
        shareInstance.database?.open()
        let isAdded = shareInstance.database?.executeUpdate("INSERT INTO task (task_name,task_time,task_deadline,hasReminder,task_location) VALUES (?,?,?,?,?)", withArgumentsIn:[modelInfo.taskName ,modelInfo.addTaskTime,modelInfo.taskDeadline,modelInfo.taskReminder,modelInfo.taskLocation])
        
        shareInstance.database?.close()
        return isAdded!
    }
    
    func deleteTask(id: Int32) -> Bool{
        shareInstance.database?.open()
        let isDeleted = shareInstance.database?.executeUpdate("DELETE FROM task WHERE task_id = \(id)", withArgumentsIn:[id])
        shareInstance.database?.close()
        return isDeleted!
    }
    
    func editTask(_ modelInfo: TaskModel) -> Bool{
        shareInstance.database?.open()
        let isEdited = shareInstance.database?.executeUpdate("REPLACE INTO task (task_id,task_name,task_time,task_deadline,hasReminder,task_location) VALUES (?,?,?,?,?,?)", withArgumentsIn:[modelInfo.taskId,modelInfo.taskName ,modelInfo.addTaskTime,modelInfo.taskDeadline,modelInfo.taskReminder,modelInfo.taskLocation])
        shareInstance.database?.close()
        return isEdited!
    }
    
    func getTask() -> [TaskModel]!{
        
        var tasks: [TaskModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM task";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "task_id")
            let a = set?.string(forColumn: "task_name")!
            let b = set?.string(forColumn: "task_time")
            let c = set?.string(forColumn: "task_deadline")!
            let d = set?.bool(forColumn: "hasReminder")
            let e = set?.string(forColumn: "task_location")
            
            let task: TaskModel
            
            if tasks == nil{
                tasks = [TaskModel]()
            }
            task = TaskModel(taskId: i!, taskName: a!, addTaskTime: b, taskDeadline: c, taskReminder: d!, taskLocation: e)

            tasks.append(task)
        }
        set?.close()
        return tasks
    }
    
}
