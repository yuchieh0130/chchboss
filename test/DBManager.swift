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
        let isAdded = (shareInstance.database?.executeUpdate("INSERT INTO event (event_name,start_date,start_time,end_date,end_time,isAllDay,isAutomated,hasReminder) VALUES (?,?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.eventName ,modelInfo.startDate,modelInfo.startTime,modelInfo.endDate,modelInfo.endTime,modelInfo.allDay,modelInfo.autoRecord,modelInfo.reminder]))
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
        let isEdited = shareInstance.database?.executeUpdate("REPLACE INTO event (event_id,event_name,start_date,start_time,end_date,end_time,isAllDay,isAutomated,hasReminder) VALUES (?,?,?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.eventId,modelInfo.eventName ,modelInfo.startDate,modelInfo.startTime,modelInfo.endDate,modelInfo.endTime,modelInfo.allDay,modelInfo.autoRecord,modelInfo.reminder])
        shareInstance.database?.close()
        return isEdited!
    }
    
    func getEvents(String: String) -> [EventModel]!{
        
        var events: [EventModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM event WHERE start_date <= '\(String)' and end_date >= '\(String)' ORDER BY start_time ASC";
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
            let j = set?.string(forColumn: "hasReminder")
            
            let event: EventModel
            
            if c == nil && e == nil{
                event = EventModel(eventId: i!, eventName: a!, startDate:b!, startTime: c, endDate: d!, endTime: e, allDay: f!, autoRecord: g!, reminder: j!)
            }else{
                event = EventModel(eventId: i!, eventName: a!, startDate:b!, startTime: c, endDate: d!, endTime: e, allDay: f!, autoRecord: g!, reminder: j!)
            }
            
            if events == nil{
                events = [EventModel]()
            }
            events.append(event)
        }
        set?.close()
        return events
    }
    
    func getMaxEvent() -> Int32{
        
        var id : Int32!
        shareInstance.database?.open()
        let sqlString = "SELECT MAX(event_id) AS Id FROM event";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let a = set?.int(forColumn: "Id")
            id = a
        }
        set?.close()
        return id
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
        let isSave = shareInstance.database?.executeUpdate("INSERT INTO location (longitude,latitude,start_time,end_time,nearest_name,nearest_category) VALUES (?,?,?,?,?,?)", withArgumentsIn:[modelInfo.longitude ,modelInfo.latitude,modelInfo.startTime,modelInfo.endTime,modelInfo.nearestName,modelInfo.nearestCategory])
        
        shareInstance.database?.close()
        return isSave!
    }
    
    func getLocName() -> String!{
        var location : String!
        shareInstance.database?.open()
        let sqlString = "SELECT nearest_name FROM location ORDER BY location_id DESC limit 1";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.string(forColumn: "nearest_name")
            location = i
        }
        set?.close()
        return location
    }
    
    func getLocation(Int: Int32) -> LocationModel!{
        
        var location : LocationModel!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM location WHERE location_id = '\(Int)' ";
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
    
    func addPlace(_ modelInfo: PlaceModel) -> Bool{
        shareInstance.database?.open()
        let isSave = shareInstance.database?.executeUpdate("INSERT INTO savedPlace (place_name,place_category,place_longtitude,place_lantitude,my_place) VALUES (?,?,?,?,?)", withArgumentsIn:[modelInfo.placeName ,modelInfo.placeCategory,modelInfo.placeLongtitude,modelInfo.placeLantitude,modelInfo.myPlace])
        
        shareInstance.database?.close()
        return isSave!
    }
    
    func getPlace(Int: Int32) -> PlaceModel!{
        
        var place : PlaceModel!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM savedPlace WHERE place_id = \(Int) ";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "place_id")
            let a = set?.string(forColumn: "place_name")
            let b = set?.string(forColumn: "place_category")
            let c = set?.double(forColumn: "place_longtitude")
            let d = set?.double(forColumn: "place_lantitude")
            let e = set?.bool(forColumn: "my_place")
            
            place = PlaceModel(placeId: i!, placeName: a!, placeCategory: b!, placeLongtitude: c!, placeLantitude: d!, myPlace: e!)
        }
        set?.close()
        return place
    }
    
    func getMyPlace() -> [PlaceModel]!{
        
        var places : [PlaceModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM savedPlace ";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "place_id")
            let a = set?.string(forColumn: "place_name")
            let b = set?.string(forColumn: "place_category")
            let c = set?.double(forColumn: "place_longtitude")
            let d = set?.double(forColumn: "place_lantitude")
            let e = set?.bool(forColumn: "my_place")
            
            let place: PlaceModel
            
            if places == nil{
                places = [PlaceModel]()
            }
            place = PlaceModel(placeId: i!, placeName: a!, placeCategory: b!, placeLongtitude: c!, placeLantitude: d!, myPlace: e!)
            places.append(place)
        }
        set?.close()
        return places
    }
    
    func addTask(_ modelInfo: TaskModel) -> Bool{
        shareInstance.database?.open()
        let isAdded = shareInstance.database?.executeUpdate("INSERT INTO task (task_name,task_time,task_deadline,hasReminder,task_location,addToCal,isPinned,isDone) VALUES (?,?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.taskName ,modelInfo.taskTime,modelInfo.taskDeadline,modelInfo.reminder,modelInfo.taskLocation,modelInfo.addToCal,modelInfo.isPinned,modelInfo.isDone])
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
        let isEdited = shareInstance.database?.executeUpdate("REPLACE INTO task (task_id,task_name,task_time,task_deadline,hasReminder,task_location,addToCal,isPinned,isDone) VALUES (?,?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.taskId,modelInfo.taskName ,modelInfo.taskTime,modelInfo.taskDeadline,modelInfo.reminder,modelInfo.taskLocation,modelInfo.addToCal,modelInfo.isPinned,modelInfo.isDone])
        shareInstance.database?.close()
        return isEdited!
    }
    
    //get selected date當天的task
    func getDateTasks(String: String) -> [TaskModel]!{
        
        var tasks: [TaskModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM task WHERE task_deadline LIKE '%\(String)%' AND addToCal = 1";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "task_id")
            let a = set?.string(forColumn: "task_name")!
            let b = set?.string(forColumn: "task_time")
            let c = set?.string(forColumn: "task_deadline")
            let d = set?.bool(forColumn: "hasReminder")
            let e = set?.string(forColumn: "task_location")
            let f = set?.bool(forColumn: "addToCal")
            let g = set?.bool(forColumn: "isPinned")
            let h = set?.bool(forColumn: "isDone")
            
            let task: TaskModel
                       
            if tasks == nil{
               tasks = [TaskModel]()
            }
               task = TaskModel(taskId: i!, taskName: a!, taskTime: b, taskDeadline: c, reminder: d!, taskLocation: e!, addToCal: f!, isPinned: g!, isDone: h!)
               tasks.append(task)
            }
        set?.close()
        return tasks
    }
    
    func getAllUndoneTask() -> [TaskModel]!{
        
        var tasks: [TaskModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM task ORDER BY isPinned DESC , task_deadline ASC WHERE isDone = 0";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "task_id")
            let a = set?.string(forColumn: "task_name")!
            let b = set?.string(forColumn: "task_time")
            let c = set?.string(forColumn: "task_deadline")
            let d = set?.bool(forColumn: "hasReminder")
            let e = set?.string(forColumn: "task_location")
            let f = set?.bool(forColumn: "addToCal")
            let g = set?.bool(forColumn: "isPinned")
            let h = set?.bool(forColumn: "isDone")
            
            let task: TaskModel
            
            if tasks == nil{
                tasks = [TaskModel]()
            }
            task = TaskModel(taskId: i!, taskName: a!, taskTime: b, taskDeadline: c, reminder: d!, taskLocation: e!, addToCal: f!, isPinned: g!, isDone: h!)
            tasks.append(task)
        }
        set?.close()
        return tasks
    }
    
    func getAllDoneTask() -> [TaskModel]!{
        
        var tasks: [TaskModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM task ORDER BY isPinned DESC , task_deadline ASC WHERE isDone = 1";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "task_id")
            let a = set?.string(forColumn: "task_name")!
            let b = set?.string(forColumn: "task_time")
            let c = set?.string(forColumn: "task_deadline")
            let d = set?.bool(forColumn: "hasReminder")
            let e = set?.string(forColumn: "task_location")
            let f = set?.bool(forColumn: "addToCal")
            let g = set?.bool(forColumn: "isPinned")
            let h = set?.bool(forColumn: "isDone")
            
            let task: TaskModel
            
            if tasks == nil{
                tasks = [TaskModel]()
            }
            task = TaskModel(taskId: i!, taskName: a!, taskTime: b, taskDeadline: c, reminder: d!, taskLocation: e!, addToCal: f!, isPinned: g!, isDone: h!)
            tasks.append(task)
        }
        set?.close()
        return tasks
    }
    
    func pinTask(id: Int32) -> Bool{
        shareInstance.database?.open()
        let isPinned = shareInstance.database?.executeUpdate("UPDATE task SET isPinned = 1 WHERE task_id = \(id)", withArgumentsIn:[id])
        shareInstance.database?.close()
        return isPinned!
    }
    
    func unPinTask(id: Int32) -> Bool{
           shareInstance.database?.open()
           let unPinned = shareInstance.database?.executeUpdate("UPDATE task SET isPinned = 0 WHERE task_id = \(id)", withArgumentsIn:[id])
           shareInstance.database?.close()
           return unPinned!
       }
    
    
    
    
}
