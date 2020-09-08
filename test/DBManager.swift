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
    
    let user_id = UserDefaults.standard.integer(forKey: "user_id")
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
    
    var showDayformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    /*func for event*/
    func addEvent(_ modelInfo: EventModel) {
        shareInstance.database?.open()
        (shareInstance.database?.executeUpdate("INSERT INTO event (event_name,start_date,start_time,end_date,end_time,isAllDay,isAutomated,autoCategory,autoLocation,reminder) VALUES (?,?,?,?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.eventName ,modelInfo.startDate,modelInfo.startTime,modelInfo.endDate,modelInfo.endTime,modelInfo.allDay,modelInfo.autoRecord,modelInfo.autoCategory,modelInfo.autoLocation,modelInfo.reminder]))
        shareInstance.database?.close()
    }
    
    func deleteEvent(id: Int32){
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("DELETE FROM event WHERE event_id = \(id)", withArgumentsIn:[id])
        shareInstance.database?.close()
    }
    
    func editEvent(_ modelInfo: EventModel){
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("REPLACE INTO event (event_id,event_name,start_date,start_time,end_date,end_time,isAllDay,isAutomated,autoCategory,autoLocation,reminder) VALUES (?,?,?,?,?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.eventId,modelInfo.eventName ,modelInfo.startDate,modelInfo.startTime,modelInfo.endDate,modelInfo.endTime,modelInfo.allDay,modelInfo.autoRecord,modelInfo.autoCategory,modelInfo.autoLocation,modelInfo.reminder])
        shareInstance.database?.close()
    }
    
    func getEvents(String: String) -> [EventModel]!{
        
        var events: [EventModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM event WHERE start_date <= '\(String)' and end_date >= '\(String)' ORDER BY start_date,start_time ASC";
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
            let h = set?.int(forColumn: "autoCategory")
            let j = set?.int(forColumn: "autoLocation")
            let k = set?.string(forColumn: "reminder")
            
            let event: EventModel
            
            event = EventModel(eventId: i!, eventName: a!, startDate:b!, startTime: c!, endDate: d!, endTime: e!, allDay: f!, autoRecord: g!, autoCategory: h!, autoLocation: j!, reminder: k!)
            
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
    
    
    /*func for Category*/
    func getCategory(Int: Int32) -> CategoryModel!{
        
        var category : CategoryModel!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM category WHERE category_id = \(Int)";
        let set = try? shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "category_id")
            let a = set?.string(forColumn: "category_name")!
            let b = set?.string(forColumn: "category_color")!
            let c = set?.string(forColumn: "category_image")!
            
            category = CategoryModel(categoryId: i!, categoryName: a!, categoryColor: b!, category_image: c!)
        }
        set?.close()
        return category
    }
    
    func getAllCategory() -> [CategoryModel]!{
        
        var categories : [CategoryModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM category";
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
    //        return result
    //
    //    }
    
    /*func for location*/
    func saveLocation(_ modelInfo: LocationModel) -> Int32 {
        shareInstance.database?.open()
        var id : Int32!
        let isAdded = shareInstance.database?.executeUpdate("INSERT INTO location (longitude,latitude,start_date,start_time,weekday,duration,name1,category1,name2,category2,name3,category3,name4,category4,name5,category5,speed) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.longitude ,modelInfo.latitude,modelInfo.startDate,modelInfo.startTime,modelInfo.weekday,modelInfo.duration!,modelInfo.name1!,modelInfo.category1!,modelInfo.name2!,modelInfo.category2!,modelInfo.name3!,modelInfo.category3!,modelInfo.name4!,modelInfo.category4!,modelInfo.name5!,modelInfo.category5!,modelInfo.speed])
        if isAdded!{
            let sqlString1 = "SELECT MAX(location_id) AS Id FROM location";
            let set = try?shareInstance.database?.executeQuery(sqlString1, values: [])
            while ((set?.next())!) {
                let a = set?.int(forColumn: "Id")
                id = a
            }
            //return modelInfo.startTime
        }
        shareInstance.database?.close()
        return id!
    }
    
    //    func getLocName() -> String!{
    //        var location = ""
    //        shareInstance.database?.open()
    //        let sqlString = "SELECT name1 FROM location ORDER BY location_id DESC limit 1";
    //        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
    //
    //        while ((set?.next())!) {
    //            let i = set?.string(forColumn: "name1")
    //            location = i
    //        }
    //        set?.close()
    //        return location
    //    }
    
    //    func getLocation() -> LocationModel!{
    //
    //        var location : LocationModel!
    //        shareInstance.database?.open()
    //        let sqlString = "SELECT * FROM location ORDER BY start_time DESC limit 1";
    //        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
    //
    //        while ((set?.next())!) {
    //            let id = set?.int(forColumn: "location_id")
    //            let a = set?.double(forColumn: "longitude")
    //            let b = set?.double(forColumn: "latitude")
    //            let c = set?.string(forColumn: "start_time")!
    //            let d = set?.double(forColumn: "duration")
    //            let e = set?.string(forColumn: "name1")
    //            let f = set?.string(forColumn: "category1")
    //            let g = set?.string(forColumn: "name2")
    //            let h = set?.string(forColumn: "category2")
    //            let i = set?.string(forColumn: "name3")
    //            let j = set?.string(forColumn: "category3")
    //            let k = set?.string(forColumn: "name4")
    //            let l = set?.string(forColumn: "category4")
    //            let m = set?.string(forColumn: "name5")
    //            let n = set?.string(forColumn: "category5")
    //            let o = set?.double(forColumn: "speed")
    //
    //            location = LocationModel(locationId: id!, longitude: a!, latitude: b!, startTime: c!, duration: d, name1: e, name2: g, name3: i, name4: k, name5: m, category1: f,category2: h, category3: j,category4: l, category5: n,speed: o!)
    //        }
    //
    //        set?.close()
    //        return location
    //    }
    
    func getLocation(Int: Int32) -> LocationModel!{
        
        var location : LocationModel!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM location WHERE location_id = \(Int) order by location_id DESC";
        let set = try? shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let id = set?.int(forColumn: "location_id")
            let a = set?.double(forColumn: "longitude")
            let b = set?.double(forColumn: "latitude")
            let c = set?.string(forColumn: "start_date")!
            let c1 = set?.string(forColumn: "start_time")!
            let c2 = set?.int(forColumn: "weekday")
            let d = set?.double(forColumn: "duration")
            let e = set?.string(forColumn: "name1")
            let f = set?.string(forColumn: "category1")
            let g = set?.string(forColumn: "name2")
            let h = set?.string(forColumn: "category2")
            let i = set?.string(forColumn: "name3")
            let j = set?.string(forColumn: "category3")
            let k = set?.string(forColumn: "name4")
            let l = set?.string(forColumn: "category4")
            let m = set?.string(forColumn: "name5")
            let n = set?.string(forColumn: "category5")
            let o = set?.double(forColumn: "speed")
            
            location = LocationModel(locationId: id!, longitude: a!, latitude: b!, startDate: c!, startTime: c1!, weekday: c2!, duration: d, name1: e, name2: g, name3: i, name4: k, name5: m, category1: f,category2: h, category3: j,category4: l, category5: n,speed: o!)
        }
        set?.close()
        return location
    }
    
    func getMaxLocation() -> LocationModel!{
        
        var location : LocationModel!
        shareInstance.database?.open()
        let sqlString = "SELECT * from location where location_id order by location_id desc limit 1";
        
        let set = try? shareInstance.database?.executeQuery(sqlString, values: [])
        while ((set?.next())!) {
            let id = set?.int(forColumn: "location_id")
            let a = set?.double(forColumn: "longitude")
            let b = set?.double(forColumn: "latitude")
            let c = set?.string(forColumn: "start_date")!
            let c1 = set?.string(forColumn: "start_time")!
            let c2 = set?.int(forColumn: "weekday")
            let d = set?.double(forColumn: "duration")
            let e = set?.string(forColumn: "name1")
            let f = set?.string(forColumn: "category1")
            let g = set?.string(forColumn: "name2")
            let h = set?.string(forColumn: "category2")
            let i = set?.string(forColumn: "name3")
            let j = set?.string(forColumn: "category3")
            let k = set?.string(forColumn: "name4")
            let l = set?.string(forColumn: "category4")
            let m = set?.string(forColumn: "name5")
            let n = set?.string(forColumn: "category5")
            let o = set?.double(forColumn: "speed")
            
            location = LocationModel(locationId: id!, longitude: a!, latitude: b!, startDate: c!, startTime: c1!, weekday: c2!, duration: d, name1: e, name2: g, name3: i, name4: k, name5: m, category1: f,category2: h, category3: j,category4: l, category5: n,speed: o!)
        }
        set?.close()
        return location
    }
    
    func saveDuration(double: Double) {
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("UPDATE location SET duration = \(double) WHERE location_id = (SELECT MAX(location_id) FROM location) ", withArgumentsIn:[double])
        
        shareInstance.database?.close()
    }
    
    
    /*func for savePlace*/
    func addPlace(_ modelInfo: PlaceModel) -> Int32{
        var id : Int32!
        shareInstance.database?.open()
        let sqlString = "INSERT INTO savedPlace (place_name,place_category,place_longitude,place_latitude,regionRadius,my_place) SELECT * FROM (SELECT '\(modelInfo.placeName)', '\(modelInfo.placeCategory)', \(modelInfo.placeLongitude), \(modelInfo.placeLatitude),\(modelInfo.regionRadius), \(modelInfo.myPlace)) AS tmp WHERE NOT EXISTS (SELECT * FROM savedPlace WHERE place_name = '\(modelInfo.placeName)') ";
        let isAdded = shareInstance.database?.executeUpdate(sqlString, withArgumentsIn:[modelInfo.placeName ,modelInfo.placeCategory,modelInfo.placeLongitude,modelInfo.placeLatitude,modelInfo.regionRadius,modelInfo.myPlace])
        if isAdded!{
            let sqlString1 = "SELECT MAX(place_id) AS Id FROM savedPlace";
            let set = try?shareInstance.database?.executeQuery(sqlString1, values: [])
            while ((set?.next())!) {
                let a = set?.int(forColumn: "Id")
                id = a
                var isMyPlace = "0"
                if modelInfo.myPlace{
                    isMyPlace = "1"
                }
                let data = ["user_id":String(user_id),"user_place_id":String(id),"place_name":String(modelInfo.placeName),"place_category":String(modelInfo.placeCategory),"place_longitude":String(modelInfo.placeLongitude),"place_latitude":String(modelInfo.placeLatitude),"region_radius":String(modelInfo.regionRadius),"my_place":isMyPlace]
                net.addSavedplaceData(data: data){
                    (status_code) in
                    if (status_code != nil) {
                        print("addSavedplaceData\(status_code!)")
                    }
                }
            }
        }else{
            let sqlString2 = "SELECT place_id AS Id FROM savedPlace WHERE place_name = '\(modelInfo.placeName)'";
            let set = try?shareInstance.database?.executeQuery(sqlString2, values: [])
            while ((set?.next())!) {
                let a = set?.int(forColumn: "Id")
                id = a
            }
        }
        shareInstance.database?.close()

        return id!
        //return isAdded!
    }
    
    func editPlace(_ modelInfo: PlaceModel){
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("REPLACE INTO savedPlace (place_id,place_name,place_category,place_longitude,place_latitude,regionRadius,my_place) VALUES (?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.placeId!,modelInfo.placeName,modelInfo.placeCategory,modelInfo.placeLongitude,modelInfo.placeLatitude,modelInfo.regionRadius,modelInfo.myPlace])
        shareInstance.database?.close()
        let data = ["user_id":String(user_id),"user_place_id":String(modelInfo.placeId!),"place_Name":String(modelInfo.placeName),"place_category":String(modelInfo.placeCategory),"place_longitude":String(modelInfo.placeLongitude),"place_latitude":String(modelInfo.placeLatitude),"region_radius":String(modelInfo.regionRadius),"my_place":String(modelInfo.myPlace)]
        net.updateSavedplaceData(data: data){
            (status_code) in
            if (status_code != nil) {
                print("updateSavedplaceData\(status_code!)")
            }
        }
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
            let c = set?.double(forColumn: "place_longitude")
            let d = set?.double(forColumn: "place_latitude")
            let e = set?.bool(forColumn: "my_place")
            let f = set?.double(forColumn: "regionRadius")
            
            place = PlaceModel(placeId: i!, placeName: a!, placeCategory: b!, placeLongitude: c!, placeLatitude: d!, regionRadius: f!, myPlace: e!)
        }
        set?.close()
        return place
    }
    
    func getNotMyPlaces() -> [PlaceModel]!{
        
        var places : [PlaceModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM savedPlace WHERE my_place = 0";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "place_id")
            let a = set?.string(forColumn: "place_name")
            let b = set?.string(forColumn: "place_category")
            let c = set?.double(forColumn: "place_longitude")
            let d = set?.double(forColumn: "place_latitude")
            let e = set?.bool(forColumn: "my_place")
            let f = set?.double(forColumn: "regionRadius")
            
            let place: PlaceModel
            
            if places == nil{
                places = [PlaceModel]()
            }
            
            place = PlaceModel(placeId: i!, placeName: a!, placeCategory: b!, placeLongitude: c!, placeLatitude: d!, regionRadius: f!, myPlace: e!)
            places.append(place)
        }
        set?.close()
        return places
    }
    
    func getMyPlaces() -> [PlaceModel]!{
        
        var places : [PlaceModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM savedPlace WHERE my_place = 1";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "place_id")
            let a = set?.string(forColumn: "place_name")
            let b = set?.string(forColumn: "place_category")
            let c = set?.double(forColumn: "place_longitude")
            let d = set?.double(forColumn: "place_latitude")
            let e = set?.bool(forColumn: "my_place")
            let f = set?.double(forColumn: "regionRadius")
            
            let place: PlaceModel
            
            if places == nil{
                places = [PlaceModel]()
            }
            place = PlaceModel(placeId: i!, placeName: a!, placeCategory: b!, placeLongitude: c!, placeLatitude: d!, regionRadius: f!, myPlace: e!)
            places.append(place)
        }
        set?.close()
        return places
    }
    
    func deleteMyPlace(id: Int32) {
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("DELETE FROM savedPlace WHERE place_id = \(id)", withArgumentsIn:[id])
        shareInstance.database?.close()
        
        let data = ["user_id":String(user_id),"user_place_id":String(id)]
        net.deleteSavedplaceData(data: data){
            (status_code) in
            if (status_code != nil) {
                print("deleteSavedplaceData\(status_code!)")
            }
        }
    }
    
    func getMaxPlace() -> Int32{
        
        var id : Int32!
        shareInstance.database?.open()
        let sqlString = "SELECT MAX(place_id) AS Id FROM savedPlace";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let a = set?.int(forColumn: "Id")
            id = a
        }
        set?.close()
        return id
    }
    
    //    func editPlaceData(id: Int32, p: PlaceModel) -> Bool{
    //        shareInstance.database?.open()
    //        let isDone =  shareInstance.database?.executeUpdate("UPDATE savedPlace SET place_name = '\(p.placeName)', place_category = '\(p.placeCategory)', place_longitude = \(p.placeLongitude), place_latitude = \(p.placeLatitude),my_place = \(p.myPlace) WHERE place_id = \(id)" ,withArgumentsIn:[id,p])
    //        shareInstance.database?.close()
    //        return isDone!
    //    }
    
    /*func for task*/
    func addTask(_ modelInfo: TaskModel) {
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("INSERT INTO task (task_name,task_time,task_deadline,reminder,task_location,addToCal,isPinned,isDone) VALUES (?,?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.taskName ,modelInfo.taskTime,modelInfo.taskDeadline,modelInfo.reminder,modelInfo.taskLocation,modelInfo.addToCal,modelInfo.isPinned,modelInfo.isDone])
        shareInstance.database?.close()
    }
    
    func deleteTask(id: Int32) {
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("DELETE FROM task WHERE task_id = \(id)", withArgumentsIn:[id])
        shareInstance.database?.close()
    }
    
    func editTask(_ modelInfo: TaskModel) {
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("REPLACE INTO task (task_id,task_name,task_time,task_deadline,reminder,task_location,addToCal,isPinned,isDone) VALUES (?,?,?,?,?,?,?,?,?)", withArgumentsIn:[modelInfo.taskId,modelInfo.taskName ,modelInfo.taskTime,modelInfo.taskDeadline,modelInfo.reminder,modelInfo.taskLocation,modelInfo.addToCal,modelInfo.isPinned,modelInfo.isDone])
        shareInstance.database?.close()
    }
    
    func getMaxTask() -> Int32{
        
        var id : Int32!
        shareInstance.database?.open()
        let sqlString = "SELECT MAX(task_id) AS Id FROM task";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let a = set?.int(forColumn: "Id")
            id = a
        }
        set?.close()
        return id
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
            let d = set?.string(forColumn: "reminder")
            let e = set?.int(forColumn: "task_location")
            let f = set?.bool(forColumn: "addToCal")
            let g = set?.bool(forColumn: "isPinned")
            let h = set?.bool(forColumn: "isDone")
            
            let task: TaskModel
            
            if tasks == nil{
                tasks = [TaskModel]()
            }
            task = TaskModel(taskId: i!, taskName: a!, taskTime: b!, taskDeadline: c!, taskLocation: e!, reminder: d!, addToCal: f!, isPinned: g!, isDone: h!)
            tasks.append(task)
        }
        set?.close()
        return tasks
    }
    
    func getAllUndoneTask() -> [TaskModel]!{
        
        var tasks: [TaskModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM task WHERE isDone = 0 ORDER BY isPinned DESC , task_deadline ASC";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "task_id")
            let a = set?.string(forColumn: "task_name")!
            let b = set?.string(forColumn: "task_time")
            let c = set?.string(forColumn: "task_deadline")
            let d = set?.string(forColumn: "reminder")
            let e = set?.int(forColumn: "task_location")
            let f = set?.bool(forColumn: "addToCal")
            let g = set?.bool(forColumn: "isPinned")
            let h = set?.bool(forColumn: "isDone")
            
            let task: TaskModel
            
            if tasks == nil{
                tasks = [TaskModel]()
            }
            task = TaskModel(taskId: i!, taskName: a!, taskTime: b!, taskDeadline: c!, taskLocation: e!, reminder: d!, addToCal: f!, isPinned: g!, isDone: h!)
            tasks.append(task)
        }
        set?.close()
        return tasks
    }
    
    func getAllDoneTask() -> [TaskModel]!{
        
        var tasks: [TaskModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM task WHERE isDone = 1 ORDER BY isPinned DESC , task_deadline ASC";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "task_id")
            let a = set?.string(forColumn: "task_name")!
            let b = set?.string(forColumn: "task_time")
            let c = set?.string(forColumn: "task_deadline")
            let d = set?.string(forColumn: "reminder")
            let e = set?.int(forColumn: "task_location")
            let f = set?.bool(forColumn: "addToCal")
            let g = set?.bool(forColumn: "isPinned")
            let h = set?.bool(forColumn: "isDone")
            
            let task: TaskModel
            
            if tasks == nil{
                tasks = [TaskModel]()
            }
            task = TaskModel(taskId: i!, taskName: a!, taskTime: b!, taskDeadline: c!, taskLocation: e!, reminder: d!, addToCal: f!, isPinned: g!, isDone: h!)
            tasks.append(task)
        }
        set?.close()
        return tasks
    }
    
    func deleteDoneTask(id: Int32) {
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("DELETE FROM task WHERE task_id = \(id)", withArgumentsIn:[id])
        shareInstance.database?.close()
    }
    
    func pinTask(id: Int32) {
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("UPDATE task SET isPinned = 1 WHERE task_id = \(id)", withArgumentsIn:[id])
        shareInstance.database?.close()
    }
    
    func unPinTask(id: Int32) {
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("UPDATE task SET isPinned = 0 WHERE task_id = \(id)", withArgumentsIn:[id])
        shareInstance.database?.close()
    }
    
    func doneTask(id: Int32) {
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("UPDATE task SET isDone = 1 WHERE task_id = \(id)", withArgumentsIn: [id])
        shareInstance.database?.close()
    }
    
    /*func for track*/
    //get selected date當天的track
    func getDateTracks(String: String) -> [TrackModel]!{
        
        var tracks: [TrackModel]!
        shareInstance.database?.open()
        
        let sqlString = "SELECT * FROM track WHERE (start_date || ' ' || start_time) BETWEEN '\(String+" 00:00" )' and '\(String+" 23:59" )' or (end_date || ' ' || end_time) BETWEEN '\(String+" 00:00" )' and '\(String+" 23:59" )' "
        
        //let sqlString = "SELECT * FROM track WHERE start_date <= '\(String)' and end_date >= '\(String)' ORDER BY start_date ASC,start_time ASC";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "track_id")
            let a = set?.string(forColumn: "start_date")
            let b = set?.string(forColumn: "start_time")
            let w = set?.int(forColumn: "weekDay")
            let c = set?.string(forColumn: "end_date")
            let d = set?.string(forColumn: "end_time")
            let e = set?.int(forColumn: "category_id")
            let f = set?.int(forColumn: "location_id")
            let g = set?.int(forColumn: "place_id")
            
            let track: TrackModel
            
            if tracks == nil{
                tracks = [TrackModel]()
            }
            
            track = TrackModel(trackId: i!, startDate: a!, startTime: b!, weekDay: w! ,endDate: c!, endTime: d!,categoryId: e!, locationId: f!, placeId: g!)
            tracks.append(track)
        }
        set?.close()
        return tracks
    }
    
    //get selected date當週的track
    func getWeekTracks(year: String, week: Int) -> [TrackModel]!{
        var tracks: [TrackModel]!
        shareInstance.database?.open()
        let sqlString = "select * from track where (strftime('%Y %W',start_date)='\(year) \(week)' and weekday != 1) or (strftime('%Y %W',end_date) = '\(year) \(week)' and weekday != 1) or (strftime('%Y %W',start_date) = '\(year) \(week-1)' AND weekday = 1) or  (strftime('%Y %W',end_date) = '\(year) \(week-1)' AND strftime('%w',end_date) = '0')"
        //let sqlString = "SELECT * FROM track WHERE (start_date || ' ' || start_time) BETWEEN '\(String+" 00:00" )' and '\(String+" 23:59" )' or (end_date || ' ' || end_time) BETWEEN '\(String+" 00:00" )' and '\(String+" 23:59" )' "
        
        //let sqlString = "SELECT * FROM track WHERE start_date <= '\(String)' and end_date >= '\(String)' ORDER BY start_date ASC,start_time ASC";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "track_id")
            let a = set?.string(forColumn: "start_date")
            let b = set?.string(forColumn: "start_time")
            let w = set?.int(forColumn: "weekDay")
            let c = set?.string(forColumn: "end_date")
            let d = set?.string(forColumn: "end_time")
            let e = set?.int(forColumn: "category_id")
            let f = set?.int(forColumn: "location_id")
            let g = set?.int(forColumn: "place_id")
            
            let track: TrackModel
            
            if tracks == nil{
                tracks = [TrackModel]()
            }
            
            track = TrackModel(trackId: i!, startDate: a!, startTime: b!, weekDay: w! ,endDate: c!, endTime: d!,categoryId: e!, locationId: f!, placeId: g!)
            tracks.append(track)
        }
        set?.close()
        return tracks
    }
    
    //get selected date當月的track
    func getMonthTracks(Year: String,Month: String) -> [TrackModel]!{
        let select = "\(Year)-\(Month)"
        var tracks: [TrackModel]!
        shareInstance.database?.open()
        let sqlString =  "select * from track where strftime('%Y-%m',start_date)='\(select)' or strftime('&Y-%m',end_date)='\(select)'"
        //           let sqlString = "SELECT * FROM track WHERE (start_date || ' ' || start_time) BETWEEN '\(String+" 00:00" )' and '\(String+" 23:59" )' or (end_date || ' ' || end_time) BETWEEN '\(String+" 00:00" )' and '\(String+" 23:59" )' "
        
        //let sqlString = "SELECT * FROM track WHERE start_date <= '\(String)' and end_date >= '\(String)' ORDER BY start_date ASC,start_time ASC";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "track_id")
            let a = set?.string(forColumn: "start_date")
            let b = set?.string(forColumn: "start_time")
            let w = set?.int(forColumn: "weekDay")
            let c = set?.string(forColumn: "end_date")
            let d = set?.string(forColumn: "end_time")
            let e = set?.int(forColumn: "category_id")
            let f = set?.int(forColumn: "location_id")
            let g = set?.int(forColumn: "place_id")
            
            let track: TrackModel
            
            if tracks == nil{
                tracks = [TrackModel]()
            }
            
            track = TrackModel(trackId: i!, startDate: a!, startTime: b!, weekDay: w! ,endDate: c!, endTime: d!,categoryId: e!, locationId: f!, placeId: g!)
            tracks.append(track)
        }
        set?.close()
        return tracks
    }
    
    
    //    func deleteTrackPlace(id: Int32) -> Bool{
    //        shareInstance.database?.open()
    //        let isDone = shareInstance.database?.executeUpdate("UPDATE track SET place_id = NULL WHERE track_id = \(id)", withArgumentsIn: [id])
    //        shareInstance.database?.close()
    //        return isDone!
    //    }
    //
    //    func editTrackPlace(a: Int32, b: Int32) -> Bool{
    //        shareInstance.database?.open()
    //        let isDone = shareInstance.database?.executeUpdate("UPDATE track SET place_id = \(a) WHERE track_id = \(b)", withArgumentsIn: [a,b])
    //        shareInstance.database?.close()
    //        return isDone!
    //    }
    
    //新增track
    func addTrack(_ modelInfo: TrackModel) {
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("INSERT INTO track (start_date,start_time,weekDay,end_date,end_time,category_id,location_id,place_id) VALUES (?,?,?,?,?,?,?,?)" ,withArgumentsIn: [modelInfo.startDate,modelInfo.startTime,modelInfo.weekDay,modelInfo.endDate,modelInfo.endTime,modelInfo.categoryId,modelInfo.locationId,modelInfo.placeId!])
        shareInstance.database?.close()
    }
    
    //insert Track（還沒寫完！）
    
    //編輯track（不包含location）
    func editTrack(oldModelInfo: TrackModel,newModelInfo: TrackModel){
        shareInstance.database?.open()
        
        let data :[String:String] = ["user_id":String(user_id), "new_start_date":String(newModelInfo.startDate), "new_start_time":String(newModelInfo.startTime), "new_weekday":String(newModelInfo.weekDay), "new_end_date":String(newModelInfo.endDate), "new_end_time":String(newModelInfo.endTime), "new_category_id":String(newModelInfo.categoryId), "new_location_id":String(newModelInfo.locationId), "new_place_id":String(newModelInfo.placeId ?? 0), "old_start_date":String(oldModelInfo.startDate), "old_start_time":String(oldModelInfo.startTime), "old_weekday":String(oldModelInfo.weekDay), "old_end_date":String(oldModelInfo.endDate), "old_end_time":String(oldModelInfo.endTime), "old_category_id":String(oldModelInfo.categoryId), "old_location_id":String(oldModelInfo.locationId), "old_place_id":String(oldModelInfo.placeId ?? 0)]
        net.updateTrackData(data: data){
            (status_code) in
            if (status_code != nil) {
                print("updateTrackData\(status_code!)")
            }
        }
        
        let newStart = newModelInfo.startDate+" "+newModelInfo.startTime
        let newEnd = newModelInfo.endDate+" "+newModelInfo.endTime
        let oldStart = oldModelInfo.startDate+" "+oldModelInfo.startTime
        let oldEnd = oldModelInfo.endDate+" "+oldModelInfo.endTime
        
        //沒改時間
        if newStart == oldStart && newEnd == oldEnd{
            shareInstance.database?.executeUpdate("UPDATE track SET category_id = \(newModelInfo.categoryId),place_id = \(newModelInfo.placeId!) WHERE track_id = \(newModelInfo.trackId!)", withArgumentsIn: [])
        }else if newStart < oldStart && newEnd < oldEnd{
            //6-9改成5-8
            //刪掉包含在5-8的
            //shareInstance.database?.executeUpdate("DELETE FROM track WHERE (start_date || ' ' || start_time) >= '\(newModelInfo.startDate+" "+newModelInfo.startTime)' and (end_date || ' ' || end_time) <= '\(newModelInfo.endDate+" "+newModelInfo.endTime)'",withArgumentsIn:[newModelInfo.startDate+" "+newModelInfo.startTime,newModelInfo.endDate+" "+newModelInfo.endTime])
            //結束時間在5-8中間的UPDATE成5
            shareInstance.database?.executeUpdate("UPDATE track SET end_date = '\(newModelInfo.startDate)',end_time = '\(newModelInfo.startTime)' WHERE (end_date || ' ' || end_time) >= '\(newModelInfo.startDate+" "+newModelInfo.startTime)' and (end_date || ' ' || end_time) <= '\(newModelInfo.endDate+" "+newModelInfo.endTime)' ",withArgumentsIn:[])
            //UPDATE該筆資料6-9改成5-8
            shareInstance.database?.executeUpdate("UPDATE track SET start_date = '\(newModelInfo.startDate)',start_time = '\(newModelInfo.startTime)',end_date = '\(newModelInfo.endDate)',end_time = '\(newModelInfo.endTime)',category_id = \(newModelInfo.categoryId),place_id = \(newModelInfo.placeId!) WHERE track_id = \(oldModelInfo.trackId!)",withArgumentsIn:[])
            //新增一筆8-9第19類
            shareInstance.database?.executeUpdate("INSERT INTO track (start_date,start_time,weekDay,end_date,end_time,category_id,location_id,place_id) VALUES (?,?,?,?,?,?,?,?) ",withArgumentsIn:[newModelInfo.endDate,newModelInfo.endTime,newModelInfo.weekDay,oldModelInfo.endDate,oldModelInfo.endTime,19,oldModelInfo.locationId,oldModelInfo.placeId!])
        }else if newStart > oldStart && newEnd > oldEnd {
            //6-9改成7-10
            //刪掉包含在7-10的
            shareInstance.database?.executeUpdate("DELETE FROM track WHERE (start_date || ' ' || start_time) >= '\(newModelInfo.startDate+" "+newModelInfo.startTime)' and (end_date || ' ' || end_time) <= '\(newModelInfo.endDate+" "+newModelInfo.endTime)'",withArgumentsIn:[newModelInfo.startDate+" "+newModelInfo.startTime,newModelInfo.endDate+" "+newModelInfo.endTime])
            //開始時間在7-10中間的UPDATE成10
            shareInstance.database?.executeUpdate("UPDATE track SET start_date = '\(newModelInfo.endDate)',start_time = '\(newModelInfo.endTime)' WHERE (start_date || ' ' || start_time) >= '\(newModelInfo.startDate+" "+newModelInfo.startTime)' and (start_date || ' ' || start_time) <= '\(newModelInfo.endDate+" "+newModelInfo.endTime)' ",withArgumentsIn:[])
            //UPDATE該筆資料6-9改成7-10
            shareInstance.database?.executeUpdate("UPDATE track SET start_date = '\(newModelInfo.startDate)',start_time = '\(newModelInfo.startTime)',end_date = '\(newModelInfo.endDate)',end_time = '\(newModelInfo.endTime)',category_id = \(newModelInfo.categoryId),place_id = \(newModelInfo.placeId!) WHERE track_id = \(oldModelInfo.trackId!)",withArgumentsIn:[])
            //新增一筆6-7第19類
            shareInstance.database?.executeUpdate("INSERT INTO track (start_date,start_time,weekDay,end_date,end_time,category_id,location_id,place_id) VALUES (?,?,?,?,?,?,?,?) ",withArgumentsIn:[oldModelInfo.startDate,oldModelInfo.startTime,oldModelInfo.weekDay,newModelInfo.startDate,newModelInfo.startTime,19,oldModelInfo.locationId,oldModelInfo.placeId!])
        }else if (newStart < oldStart && newEnd > oldEnd) || (newStart <= oldStart && newEnd > oldEnd) || (newStart < oldStart && newEnd >= oldEnd){
            //6-9改成5-10
            //刪掉包含在5-10的
            shareInstance.database?.executeUpdate("DELETE FROM track WHERE (start_date || ' ' || start_time) >= '\(newModelInfo.startDate+" "+newModelInfo.startTime)' and (end_date || ' ' || end_time) <= '\(newModelInfo.endDate+" "+newModelInfo.endTime)'",withArgumentsIn:[newModelInfo.startDate+" "+newModelInfo.startTime,newModelInfo.endDate+" "+newModelInfo.endTime])
            //結束時間在5-10中間的UPDATE成5
            shareInstance.database?.executeUpdate("UPDATE track SET end_date = '\(newModelInfo.startDate)',end_time = '\(newModelInfo.startTime)' WHERE (end_date || ' ' || end_time) >= '\(newModelInfo.startDate+" "+newModelInfo.startTime)' and (end_date || ' ' || end_time) <= '\(newModelInfo.endDate+" "+newModelInfo.endTime)' ",withArgumentsIn:[])
            //開始時間在5-10中間的UPDATE成10
            shareInstance.database?.executeUpdate("UPDATE track SET start_date = '\(newModelInfo.endDate)',start_time = '\(newModelInfo.endTime)' WHERE (start_date || ' ' || start_time) >= '\(newModelInfo.startDate+" "+newModelInfo.startTime)' and (start_date || ' ' || start_time) <= '\(newModelInfo.endDate+" "+newModelInfo.endTime)' ",withArgumentsIn:[])
            //新增一筆5-10
            shareInstance.database?.executeUpdate("INSERT INTO track (start_date,start_time,weekDay,end_date,end_time,category_id,location_id,place_id) VALUES (?,?,?,?,?,?,?,?) ",withArgumentsIn:[newModelInfo.startDate,newModelInfo.startTime,newModelInfo.weekDay,newModelInfo.endDate,newModelInfo.endTime,newModelInfo.categoryId,newModelInfo.locationId,newModelInfo.placeId!])
            
        }else if (newStart > oldStart && newEnd < oldEnd) || (newStart >= oldStart && newEnd < oldEnd) || (newStart > oldStart && newEnd <= oldEnd){
            //6-9改成7-8
            //UPDATE該筆資料6-9改成7-8
            shareInstance.database?.executeUpdate("UPDATE track SET start_date = '\(newModelInfo.startDate)',start_time = '\(newModelInfo.startTime)',end_date = '\(newModelInfo.endDate)',end_time = '\(newModelInfo.endTime)',category_id = \(newModelInfo.categoryId),place_id = \(newModelInfo.placeId!) WHERE track_id = \(oldModelInfo.trackId!)",withArgumentsIn:[])
            if newStart != oldStart{
                //新增一筆6-7
                shareInstance.database?.executeUpdate("INSERT INTO track (start_date,start_time,weekDay,end_date,end_time,category_id,location_id,place_id) VALUES (?,?,?,?,?,?,?,?)",withArgumentsIn:[oldModelInfo.startDate,oldModelInfo.startTime,oldModelInfo.weekDay,newModelInfo.startDate,newModelInfo.startTime,19,newModelInfo.locationId,newModelInfo.placeId!])
            }
            if newEnd != oldEnd{
                //新增一筆8-9
                shareInstance.database?.executeUpdate("INSERT INTO track (start_date,start_time,weekDay,end_date,end_time,category_id,location_id,place_id) VALUES (?,?,?,?,?,?,?,?)",withArgumentsIn:[newModelInfo.endDate,newModelInfo.endTime,newModelInfo.weekDay,oldModelInfo.endDate,oldModelInfo.endTime,19,oldModelInfo.locationId,oldModelInfo.placeId!])
            }
        }
        shareInstance.database?.close()
    
        
    }
    
    func deleteTrack(Int: Int32){
        shareInstance.database?.open()
        shareInstance.database?.executeUpdate("UPDATE track SET category_id = 19 WHERE track_id = \(Int) ", withArgumentsIn:[Int])
        
        let sqlString = "SELECT * FROM track WHERE track_id = \(Int)";
               let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
               
        while ((set?.next())!) {
            let sd = set?.string(forColumn: "start_date")
            let st = set?.string(forColumn: "start_time")
            let data = ["user_id":String(user_id),"start_date":String(sd!),"start_time":String(st!)]
                   net.deleteTrackData(data: data){
                       (status_code) in
                       if (status_code != nil) {
                           print("deleteTrackData\(status_code!)")
                       }
                   }
            
        }
        set?.close()
        shareInstance.database?.close()
        
    }
    
    //測試用
    func tete() -> [LocationModel]!{
        
        var locations: [LocationModel]!
        shareInstance.database?.open()
        let sqlString = "SELECT * FROM location";
        let set = try?shareInstance.database?.executeQuery(sqlString, values: [])
        
        while ((set?.next())!) {
            let i = set?.int(forColumn: "location_id")
            let a = set?.double(forColumn: "longitude")
            let b = set?.double(forColumn: "latitude")
            let c = set?.string(forColumn: "start_date")
            let c1 = set?.string(forColumn: "start_time")
            let c2 = set?.int(forColumn: "weekday")
            let d = set?.double(forColumn: "duration")
            let e = set?.string(forColumn: "name1")
            let f = set?.string(forColumn: "name2")
            let g = set?.string(forColumn: "name3")
            let h = set?.string(forColumn: "name4")
            let j = set?.string(forColumn: "name5")
            let k = set?.double(forColumn: "speed")
            
            let location: LocationModel
            
            if locations == nil{
                locations = [LocationModel]()
            }
            location = LocationModel(locationId: i, longitude: a!, latitude: b!, startDate: c!, startTime: c1!, weekday:c2!, duration: d!, name1: e, name2: f, name3: g, name4: h, name5: j, category1: "", category2: "", category3: "", category4: "", category5: "", speed: k!)
            locations.append(location)
        }
        set?.close()
        return locations
    }
    
    
    
}
