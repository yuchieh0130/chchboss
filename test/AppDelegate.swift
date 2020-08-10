import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    var myLocationManager = CLLocationManager()
    
    var currentLocation: CLLocation!
    var currentSpeed: Double = 55.66
    var currentTime = Date()
    var lastSpeed:Double = 55.66
    var lastLocation: CLLocation!
    var lastSpeeds = [Double]()
    
    var placesClient: GMSPlacesClient!
    //var filterList = [String]()
    //var collectionArr = [String]()
    
    let net = NetworkController()
    
    var showDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    var showTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    var showDateTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    var selectPlaces:[GMSPlace] = []
    var selectedPlace: GMSPlace?
    var location : LocationModel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let googleApiKey = "AIzaSyDby_1_EFPvVbDWYx06bwgMwt_Sz3io2xQ"
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
        
        Util.copyDatabase("project.db")
        placesClient = GMSPlacesClient.shared()
    
        myLocationManager.delegate = self
        myLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        //kCLLocationAccuracyHundredMeters
        //kCLLocationAccuracyNearestTenMeters
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        //kCLLocationAccuracyNearestTenMeters
        //kCLLocationAccuracyBestForNavigation
        myLocationManager.allowsBackgroundLocationUpdates = true
        myLocationManager.pausesLocationUpdatesAutomatically = false
        myLocationManager.activityType = CLActivityType.fitness
        
        myLocationManager.requestAlwaysAuthorization()
        myLocationManager.startUpdatingLocation()
        
//        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                print("允許")
            } else {
                print("不允許")
            }
        })
        
        return true
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
    
        self.currentSpeed = myLocationManager.location!.speed
        self.currentLocation = locations[0] as CLLocation
        self.currentTime = Date()
        
        if lastLocation == nil{
            lastSpeeds.append(0)
            saveLocation()
        }else if currentSpeed == -1 && lastSpeed > 0 {
            lastSpeeds.removeAll()
            if lastLocation.distance(from: currentLocation) > 150{
                saveSpeed()
                saveLocation()
            }
        }else if currentSpeed > -1{
            lastSpeeds.append(currentSpeed)
        }
        
        self.lastSpeed = currentSpeed
        self.lastLocation = currentLocation
       
    }
    
    func saveLocation(){
        self.myLocationManager.delegate = nil
        
        likelyPlaces.removeAll()
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                }
            }
            
            for i in 0...4{
                self.selectPlaces.append(self.likelyPlaces[i])
            }
            
            let latitude = Double(self.currentLocation.coordinate.latitude)
            let longitude = Double(self.currentLocation.coordinate.longitude)
            let startDate = self.showDate.string(from: Date())
            let startTime = self.showTime.string(from: Date())
            let weekday = Calendar.current.component(.weekday, from: Date())
            let name1 = self.likelyPlaces[0].name!
            let name2 = self.likelyPlaces[1].name!
            let name3 = self.likelyPlaces[2].name!
            let name4 = self.likelyPlaces[3].name!
            let name5 = self.likelyPlaces[4].name!
            let category1 = self.likelyPlaces[0].types![0]
            let category2 = self.likelyPlaces[1].types![0]
            let category3 = self.likelyPlaces[2].types![0]
            let category4 = self.likelyPlaces[3].types![0]
            let category5 = self.likelyPlaces[4].types![0]
            let user_id = UserDefaults.standard.integer(forKey: "user_id")
            
            let modelInfo = LocationModel(locationId: 0, longitude: longitude, latitude: latitude, startDate: startDate, startTime: startTime, weekday: Int32(weekday), duration: 0, name1: name1, name2: name2, name3: name3, name4: name4, name5: name5, category1: category1, category2: category2, category3: category3, category4: category4, category5: category5, speed: self.currentSpeed)
            
            let _ = DBManager.getInstance().saveLocation(modelInfo)
            
            let data : [String: String] = ["longitude":String(modelInfo.longitude), "latitude":String(modelInfo.latitude), "start_date":modelInfo.startDate, "start_time":modelInfo.startTime,"weekday":String(modelInfo.weekday), "duration":"0", "speed":String(modelInfo.speed), "name1":modelInfo.name1!, "name2":modelInfo.name2!, "name3":modelInfo.name3!, "name4":modelInfo.name4!, "name5":modelInfo.name5!, "category1":modelInfo.category1!, "category2":modelInfo.category2!, "category3":modelInfo.category3!, "category4":modelInfo.category4!, "category5":modelInfo.category5!, "user_id":String(user_id) ]
                       
            self.net.postLocationData(data: data){
                (status_code) in
                if (status_code != nil) {
                    print(status_code!)
                }
            }
        
            self.myLocationManager.delegate = self
            
        })
        
    }
    
    func saveSpeed(){
        
        self.myLocationManager.delegate = nil
        
        let latitude = Double(self.currentLocation.coordinate.latitude)
        let longitude = Double(self.currentLocation.coordinate.longitude)
        let startDate = self.showDate.string(from: currentTime)
        let startTime = self.showTime.string(from: currentTime)
        let weekday = Calendar.current.component(.weekday, from: currentTime)
        var total = 0.0
        for i in lastSpeeds{
            total += i
        }
        let speed = total/Double(lastSpeeds.count)
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        
        let modelInfo = LocationModel(locationId: 0, longitude: longitude, latitude: latitude, startDate: startDate, startTime: startTime, weekday: Int32(weekday), duration: 0, name1: "", name2: "", name3: "", name4: "", name5: "", category1: "", category2: "", category3: "", category4: "", category5: "", speed: speed)
        
        DBManager.getInstance().saveLocation(modelInfo)
        
        let data : [String: String] = ["location_id":"0", "longitude":String(modelInfo.longitude), "latitude":String(modelInfo.latitude), "start_date":modelInfo.startDate, "start_time":modelInfo.startTime,"weekday":String(modelInfo.weekday), "duration":"0", "speed":String(modelInfo.speed), "name1":modelInfo.name1!, "name2":modelInfo.name2!, "name3":modelInfo.name3!, "name4":modelInfo.name4!, "name5":modelInfo.name5!, "category1":modelInfo.category1!, "category2":modelInfo.category2!, "category3":modelInfo.category3!, "category4":modelInfo.category4!, "category5":modelInfo.category5!, "user_id":String(user_id)]
                   
        self.net.postLocationData(data: data){
            (status_code) in
            if (status_code != nil) {
                print(status_code!)
            }
        }
        
        self.myLocationManager.delegate = self
        
    }
        
//    func locationDB(){
//        self.myLocationManager.delegate = nil
//
//         if lastLocation == nil{
//                lastStopTime = self.showDateTime.string(from: Date())
//                lastSpeeds.append(0)
//                searchFivePlace()
//        }else if currentSpeed == -1 && lastSpeed > 0 {
//                searchFivePlace()
//                lastStopTime = self.showDateTime.string(from: Date())
//        }else if currentSpeed >= 0 {
//                if lastSpeed == -1 && Date().timeIntervalSince(self.showDateTime.date(from: self.lastStopTime)!) > 300 {
//                        //&& lastLocation.distance(from: currentLocation) > 150
//                    saveSpeed()
//                    lastSpeeds.removeAll()
//                    lastMoveTime = self.showDateTime.string(from: Date())
//                    saveInDB()
//                }
//            lastSpeeds.append(currentSpeed)
//        }
//                //        if myLocationManager.location!.horizontalAccuracy>=0{
//                //            //myLocationManager.stopUpdatingLocation()
//                //            if myLocationManager.location!.speed > 0{
//                //               saveSpeed()
//                //            }else{
//                //               saveInDB()
//                //            }
//                //        }
//        self.lastSpeed = currentSpeed
//        self.myLocationManager.delegate = self
//    }

//    func saveSpeed(){
//
//        let latitude = Double(self.currentLocation.coordinate.latitude)
//        let longitude = Double(self.currentLocation.coordinate.longitude)
//        let startDate = self.showDate.string(from: self.showDateTime.date(from: self.lastMoveTime)!)
//        let startTime = self.showTime.string(from: self.showDateTime.date(from: self.lastMoveTime)!)
//        let weekday = Calendar.current.component(.weekday, from: Date())
//        var total = 0.0
//        for i in lastSpeeds{
//            total += i
//        }
//        let speed = total/Double(lastSpeeds.count)
//        let duration = self.showDateTime.date(from: self.lastStopTime)!.timeIntervalSince(self.showDateTime.date(from: self.lastMoveTime)!)
//
//        let modelInfo = LocationModel(locationId: 0, longitude: longitude, latitude: latitude, startDate: startDate, startTime: startTime, weekday: Int32(weekday), duration: duration, name1: "", name2: "", name3: "", name4: "", name5: "", category1: "", category2: "", category3: "", category4: "", category5: "", speed: speed)
        
        //DBManager.getInstance().saveDuration(double: duration)
        //let _ = DBManager.getInstance().saveLocation(modelInfo)
        //self.lastSpeed = speed
        
    //}
    
// func saveInDB(){
//        likelyPlaces.removeAll()
//        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
//            if let error = error {
//                print("Current Place error: \(error.localizedDescription)")
//                return
//            }
//
//            // Get likely places and add to the list.
//            if let likelihoodList = placeLikelihoods {
//                // print(placeLikelihoods)
//                for likelihood in likelihoodList.likelihoods {
//                    let place = likelihood.place
//                    self.likelyPlaces.append(place)
//                    //                    self.tblView.reloadData()
//                }
//            }
//
//            for i in 0...4{
//                self.selectPlaces.append(self.likelyPlaces[i])
//            }
//
//            let latitude = Double(self.currentLocation.coordinate.latitude)
//            let longitude = Double(self.currentLocation.coordinate.longitude)
//            let startDate = self.showDate.string(from: Date())
//            let startTime = self.showTime.string(from: Date())
//            let weekday = Calendar.current.component(.weekday, from: Date())
//            let name1 = self.likelyPlaces[0].name!
//            let name2 = self.likelyPlaces[1].name!
//            let name3 = self.likelyPlaces[2].name!
//            let name4 = self.likelyPlaces[3].name!
//            let name5 = self.likelyPlaces[4].name!
//            let category1 = self.likelyPlaces[0].types![0]
//            let category2 = self.likelyPlaces[1].types![0]
//            let category3 = self.likelyPlaces[2].types![0]
//            let category4 = self.likelyPlaces[3].types![0]
//            let category5 = self.likelyPlaces[4].types![0]
//            let speed = self.myLocationManager.location!.speed
//
//            let modelInfo = LocationModel(locationId: 0, longitude: longitude, latitude: latitude, startDate: startDate, startTime: startTime, weekday: Int32(weekday), duration: 0, name1: name1, name2: name2, name3: name3, name4: name4, name5: name5, category1: category1, category2: category2, category3: category3, category4: category4, category5: category5, speed: speed)
//
//            let duration = Date().timeIntervalSince(self.showTime.date(from: self.lastStartDateTime)!)
            
            //DBManager.getInstance().saveDuration(double: duration)
//        let duration = Date().timeIntervalSince(self.showDateTime.date(from: self.lastStopTime)!)
//        let _ = DBManager.getInstance().saveLocation(self.lastPlaceModel)
//        let _ = DBManager.getInstance().saveDuration(double: duration)
//
//
//        let data : [String: String] = ["location_id":"0", "longitude":String(lastPlaceModel.longitude), "latitude":String(lastPlaceModel.latitude), "start_date":lastPlaceModel.startDate, "start_time":lastPlaceModel.startTime,"weekday":String(lastPlaceModel.weekday), "duration":String(duration), "speed":String(lastPlaceModel.speed), "name1":lastPlaceModel.name1!, "name2":lastPlaceModel.name2!, "name3":lastPlaceModel.name3!, "name4":lastPlaceModel.name4!, "name5":lastPlaceModel.name5!, "category1":lastPlaceModel.category1!, "category2":lastPlaceModel.category2!, "category3":lastPlaceModel.category3!, "category4":lastPlaceModel.category4!, "category5":lastPlaceModel.category5!]
//
//            self.net.postLocationData(data: data){
//                (status_code) in
//                if (status_code != nil) {
//                    print(status_code!)
//                }
//            }
            
            //self.lastStartTime = startTime
            //self.lastName1 = name1
            //self.lastLocation = CLLocation(latitude: lastPlaceModel.latitude, longitude: lastPlaceModel.longitude)
            //self.lastSpeed = -1.0
            //self.lastStartDateTime = self.showDateTime.string(from: Date())
            //self.myLocationManager.startUpdatingLocation()
        
        //})
        
//    }
    
//    func searchFivePlace(){
//        //self.myLocationManager.delegate = nil
//        likelyPlaces.removeAll()
//        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
//            if let error = error {
//                print("Current Place error: \(error.localizedDescription)")
//                return
//            }
//
//            // Get likely places and add to the list.
//            if let likelihoodList = placeLikelihoods {
//                // print(placeLikelihoods)
//                for likelihood in likelihoodList.likelihoods {
//                    let place = likelihood.place
//                    self.likelyPlaces.append(place)
//                    //                    self.tblView.reloadData()
//                }
//            }
//
//            for i in 0...4{
//                self.selectPlaces.append(self.likelyPlaces[i])
//            }
//
//            let latitude = Double(self.currentLocation.coordinate.latitude)
//            let longitude = Double(self.currentLocation.coordinate.longitude)
//            let startDate = self.showDate.string(from: Date())
//            let startTime = self.showTime.string(from: Date())
//            let weekday = Calendar.current.component(.weekday, from: Date())
//            let name1 = self.likelyPlaces[0].name!
//            let name2 = self.likelyPlaces[1].name!
//            let name3 = self.likelyPlaces[2].name!
//            let name4 = self.likelyPlaces[3].name!
//            let name5 = self.likelyPlaces[4].name!
//            let category1 = self.likelyPlaces[0].types![0]
//            let category2 = self.likelyPlaces[1].types![0]
//            let category3 = self.likelyPlaces[2].types![0]
//            let category4 = self.likelyPlaces[3].types![0]
//            let category5 = self.likelyPlaces[4].types![0]
//            //let duration = Date().timeIntervalSince(self.showTime.date(from: self.lastStartDateTime)!)
//
//            self.lastPlaceModel = LocationModel(locationId: 0, longitude: longitude, latitude: latitude, startDate: startDate, startTime: startTime, weekday: Int32(weekday), duration: 0, name1: name1, name2: name2, name3: name3, name4: name4, name5: name5, category1: category1, category2: category2, category3: category3, category4: category4, category5: category5, speed: self.currentSpeed)
//
//            //self.lastSpeed = -1.0
//            //self.myLocationManager.delegate = self
//        })
//    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    }
    
}
