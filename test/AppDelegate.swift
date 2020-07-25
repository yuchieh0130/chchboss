import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    //    let locationManager = CLLocationManager()
    var myLocationManager = CLLocationManager()
    //var myLocation :CLLocation!
    //var currentSpeed :CLLocationSpeed = CLLocationSpeed()
    var currentLocation: CLLocation!
    //用來判斷要不要存進db
    var lastSpeed:Double = 55.66
    var lastStartTime:String = ""
    var lastStartDate:String = ""
    var lastLocation: CLLocation!
    var lastName1 = ""
    var lastSpeeds = [Double]()
    
    var placesClient: GMSPlacesClient!
    var filterList = [String]()
    var collectionArr = [String]()
    
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
        
        //myLocationManager = CLLocationManager()
        //        myLocationManager.startMonitoringVisits()
        myLocationManager.delegate = self
        myLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        //kCLLocationAccuracyHundredMeters
        //kCLLocationAccuracyNearestTenMeters
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest //kCLLocationAccuracyNearestTenMeters //kCLLocationAccuracyBestForNavigation
        myLocationManager.allowsBackgroundLocationUpdates = true
        myLocationManager.pausesLocationUpdatesAutomatically = false
        myLocationManager.activityType = CLActivityType.fitness
        
        myLocationManager.requestAlwaysAuthorization()
        myLocationManager.startUpdatingLocation()
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge,.carPlay], completionHandler: (granted, error))
        self.lastStartDate = showDate.string(from: Date())
        self.lastStartTime = showTime.string(from: Date())
        return true
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        //取得目前的座標位置
        //let c = locations[0] as CLLocation
        //print(locations)
        //currentLocation = CLLocationCoordinate2D(latitude: c.coordinate.latitude, longitude: c.coordinate.longitude);
        
        //    取得時間
        //let currentTime = Date()
        //let dateFormatter: DateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        // 設定時區(台灣)
        //dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        //dateFormatString = dateFormatter.string(from: Date())
        
        //currentSpeed = myLocationManager.location!.speed
        //        if myLocationManager.location!.speed != lastSpeed{
        //            saveSpeed()
        //        }
        //        if myLocationManager.location!.speed == -1.0 && myLocationManager.location!.speed != lastSpeed{
        //            saveInDB()
        //        }
        self.currentLocation = locations[0] as CLLocation
        if lastLocation == nil{
            saveInDB()
        }else if myLocationManager.location!.speed == -1 && lastSpeed > 0 {
            lastSpeeds.removeAll()
            if lastLocation.distance(from: currentLocation) > 150{
                saveSpeed()
                saveInDB()
            }
        }else if myLocationManager.location!.speed >= 0 {
            if lastSpeed == -1{
                lastStartDate = self.showDate.string(from: Date())
                lastStartTime = self.showTime.string(from: Date())
            }
            lastSpeeds.append(myLocationManager.location!.speed)
        }
        //        if myLocationManager.location!.horizontalAccuracy>=0{
        //            //myLocationManager.stopUpdatingLocation()
        //            if myLocationManager.location!.speed > 0{
        //               saveSpeed()
        //            }else{
        //               saveInDB()
        //            }
        //        }
        self.lastSpeed = myLocationManager.location!.speed
        
    }
    
    func saveSpeed(){
        
        let latitude = Double(self.currentLocation.coordinate.latitude)
        let longitude = Double(self.currentLocation.coordinate.longitude)
        let startDate = lastStartDate
        let startTime = lastStartTime
        let weekday = Calendar.current.component(.weekday, from: Date())
        var total = 0.0
        for i in lastSpeeds{
            total += i
        }
        let speed = total/Double(lastSpeeds.count)
        
        let modelInfo = LocationModel(locationId: 0, longitude: longitude, latitude: latitude, startDate: startDate, startTime: startTime, weekday: Int32(weekday), duration: 0, name1: "", name2: "", name3: "", name4: "", name5: "", category1: "", category2: "", category3: "", category4: "", category5: "", speed: speed)
        
        ///////Duration這邊要改
        let duration = Date().timeIntervalSince(self.showTime.date(from: self.lastStartTime)!)
        DBManager.getInstance().saveDuration(double: duration)
        DBManager.getInstance().saveLocation(modelInfo)
        self.lastSpeed = speed
        
    }
    
    func saveInDB(){
        self.myLocationManager.delegate = nil
        likelyPlaces.removeAll()
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                // print(placeLikelihoods)
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                    //                    self.tblView.reloadData()
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
            let speed = self.myLocationManager.location!.speed
            
            let modelInfo = LocationModel(locationId: 0, longitude: longitude, latitude: latitude, startDate: startDate, startTime: startTime, weekday: Int32(weekday), duration: 0, name1: name1, name2: name2, name3: name3, name4: name4, name5: name5, category1: category1, category2: category2, category3: category3, category4: category4, category5: category5, speed: speed)
            
            let duration = Date().timeIntervalSince(self.showTime.date(from: self.lastStartTime)!)
            
            DBManager.getInstance().saveDuration(double: duration)
            DBManager.getInstance().saveLocation(modelInfo)
            
            let data : [String: String] = ["location_id":"0", "longitude":String(longitude), "latitude":String(latitude), "start_date":startDate, "start_time":startTime,"weekday":String(weekday), "duration":String(duration), "speed":String(speed), "name1":name1, "name2":name2, "name3":name3, "name4":name4, "name5":name5, "category1":category1, "category2":category2, "category3":category3, "category4":category4, "category5":category5]
            
            //            let data : [String: String] = ["location_id":"0", "longitude":String(self.longitude), "latitude":String(self.latitude), "start_time":self.startTime, "duration":String(self.duration), "speed":String(self.speed), "name1":self.name1, "name2":self.name2, "name3":self.name3, "name4":self.name4, "name5":self.name5, "category1":self.category1, "category2":self.category2, "category3":self.category3, "category4":self.category4, "category5":self.category5]
            
            self.net.postLocationData(data: data){
                (status_code) in
                if (status_code != nil) {
                    print(status_code!)
                }
            }
            
            //self.lastStartTime = startTime
            self.lastName1 = name1
            self.lastLocation = CLLocation(latitude: latitude, longitude: longitude)
            self.lastSpeed = -1.0
            //self.myLocationManager.startUpdatingLocation()
            //self.myLocationManager.delegate = nil
            self.myLocationManager.delegate = self
        })
    }
    
    
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
        print("visitlocation update")
        // create CLLocation from the coordinates of CLVisit
        //    let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        
        
        // Get location description
    }
    
    //  func newVisitReceived(_ visit: CLVisit, description: String) {
    //    let location = Location(visit: visit, descriptionString: description)
    //
    //    // Save location to disk
    //  }
}

