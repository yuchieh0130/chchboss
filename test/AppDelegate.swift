import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import UserNotifications
import LineSDK

var myLocationManager = CLLocationManager()
let net = NetworkController()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    //var myLocationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentSpeed: Double = 55.66
    var currentTime = Date()
    
    var enterTime = Date()
    var exitTime = Date()
    //var lastSpeed:Double = 55.66
    //var lastLocation: CLLocation!
    //var lastSpeeds = [Double]()
    
    var placesClient: GMSPlacesClient!
    //var filterList = [String]()
    //var collectionArr = [String]()
    //var myPlaces = [PlaceModel]()
    
    //let net = NetworkController()
    
    var showDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
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
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    //var selectPlaces:[GMSPlace] = []
    //var selectedPlace: GMSPlace?
    //var location : LocationModel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("BunnyTrack Launch")
        
        LoginManager.shared.setup(channelID: "1654884598", universalLinkURL: nil)
        
        if UserDefaults.standard.bool(forKey: "isLogIn"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! tabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabBarController
        }
        
        // Override point for customization after application launch.
        let googleApiKey = "AIzaSyA1aip55jDmoNfeOeSwXfGlBFtTlU5olrA"
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
        
        Util.copyDatabase("project.db")
        placesClient = GMSPlacesClient.shared()
        
        myLocationManager.delegate = self
        myLocationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        //kCLLocationAccuracyBestForNavigation：導航最高精確，，需要使用GPS。例如：汽車導航時使用。
        //kCLLocationAccuracyBest;//高精確
        //kCLLocationAccuracyNearestTenMeters：10米，10米附近的精準度可能是GPS & WiFi混用
        //kCLLocationAccuracyHundredMeters：百米，百米附近的精準度只用 WiFi
        //kCLLocationAccuracyKilometer：千米
        //kCLLocationAccuracyThreeKilometers：三公里，1～3公里內用基地台來確認位置。
        myLocationManager.allowsBackgroundLocationUpdates = true
        myLocationManager.pausesLocationUpdatesAutomatically = false
        //myLocationManager.activityType = CLActivityType.fitness
        myLocationManager.activityType = .other
        //myLocationManager.requestAlwaysAuthorization()
        myLocationManager.startUpdatingLocation()
        myLocationManager.startMonitoringSignificantLocationChanges()
        //        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        //        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
        //            print(myLocationManager.monitoredRegions)
        //            startMonitorRegion()
        //        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                print("允許通知")
            } else {
                print("不允許通知")
                DispatchQueue.main.async(){
                    let alertController = UIAlertController(title: "Turn On Notifications", message: "Notifications have been turned off for BunnyTrack. \n Go to Settings > Notifications > BunnyTrack to allow notifiactions 🥕", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
            }
        })
        UNUserNotificationCenter.current().delegate = self
        sleep(2)
        return true
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
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            print(myLocationManager.monitoredRegions)
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("BunnyTrack Active")
        if CLLocationManager.authorizationStatus() == .notDetermined{
            myLocationManager.requestAlwaysAuthorization()
        }else if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
            DispatchQueue.main.async(){
                let alertController = UIAlertController(title: "Turn On Location Services", message: "Location services have been turned off, which may affect BunnyTrack's accuracy of predicting behavior. \n Please go to Settings > Privacy > Location Services to allow BuunyTrack improve your lifestyle 🥕", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }else{
            print("accept location Authorization!")
        }
        
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        let last_track_id = UserDefaults.standard.integer(forKey: "last_track_id")
        print("User ID : \(user_id), Last Track ID : \(last_track_id)")
        
        let data = ["user_id":String(user_id),"last_track_id":String(last_track_id)]
        net.pushTrackData(data: data){
            (return_list) in
            if let status_code = return_list?[0],
                let data = return_list?[1] as? [[AnyObject]],
                let last_track_id = return_list?[2]{
                if status_code as! Int == 200{
                    UserDefaults.standard.set(last_track_id, forKey: "last_track_id")
                    for i in 0...data.count-1{
                        let modelInfo = TrackModel(trackId: 0, startDate: data[i][2] as! String, startTime: data[i][3] as! String, weekDay: (data[i][4] as! NSNumber).int32Value, endDate: data[i][5] as! String, endTime: data[i][6]  as! String, categoryId: (data[i][7] as! NSNumber).int32Value, locationId: 1, placeId: 1)
                        DBManager.getInstance().addTrack(modelInfo)
                    }
                }
                else{
                    print("pushTrackData\(status_code)")
                }
            }else{
                print("pushTrackData ERROR")
            }
        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return LoginManager.shared.application(application, open: url, options: options)
    }
    
}

//func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//    print("open url")
//    return LoginManager.shared.application(app, open: url)
//}

extension AppDelegate: CLLocationManagerDelegate, UNUserNotificationCenterDelegate{
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        
        myLocationManager.delegate = nil
        
        self.currentSpeed = myLocationManager.location!.speed
        self.currentLocation = locations[0] as CLLocation
        self.currentTime = Date()
        
        saveLocation()
        
        //        if lastLocation == nil{
        //            lastSpeeds.append(0)
        //            saveLocation()
        //        }else if currentSpeed == -1 && lastSpeed > 0 {
        //            lastSpeeds.removeAll()
        //            if lastLocation.distance(from: currentLocation) > 150{
        //                saveSpeed()
        //                saveLocation()
        //            }
        //        }else if currentSpeed > -1{
        //            lastSpeeds.append(currentSpeed)
        //        }
        
        //        self.lastSpeed = currentSpeed
        //        self.lastLocation = currentLocation
        
    }
    
    func saveLocation(){
        myLocationManager.delegate = nil
        
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
            //                        for i in 0...4{
            //                            self.selectPlaces.append(self.likelyPlaces[i])
            //                        }
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
            let id = DBManager.getInstance().saveLocation(modelInfo)
            
            let data : [String: String] = ["user_location_id":String(id),"longitude":String(modelInfo.longitude), "latitude":String(modelInfo.latitude), "start_date":modelInfo.startDate, "start_time":modelInfo.startTime,"weekday":String(modelInfo.weekday), "duration":"0", "speed":String(modelInfo.speed), "name1":modelInfo.name1!, "name2":modelInfo.name2!, "name3":modelInfo.name3!, "name4":modelInfo.name4!, "name5":modelInfo.name5!, "category1":modelInfo.category1!, "category2":modelInfo.category2!, "category3":modelInfo.category3!, "category4":modelInfo.category4!, "category5":modelInfo.category5!, "user_id":String(user_id) ]
            
            net.postLocationData(data: data){
                (status_code) in
                if (status_code != nil) {
                    print(status_code!)
                }
            }
            
        })
        myLocationManager.delegate = self
        
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    }
    
    // 當用戶進入一個 region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        makeNotification(String: "You enter \(region.identifier) 🥕")
        enterTime = Date()
        enterRegion(region: region)
    }
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        // makeNotification(String: "didStartMonitoringFor")
        // print(region)
        print("region:\(region)")
    }
    
    // 當用戶退出一個 region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        makeNotification(String: "You exit \(region.identifier) 🥕")
        exitTime = Date()
        exitRegion(region: region)
    }
    
    //    func startMonitorRegion(){
    //        //print(CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self))
    //        //if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
    //        if DBManager.getInstance().getMyPlaces() != nil{
    //            myPlaces = DBManager.getInstance().getMyPlaces()
    //            for i in 0...myPlaces.count-1{
    //                let title = "\(myPlaces[i].placeId!)"
    //                let coordinate = CLLocationCoordinate2DMake(myPlaces[i].placeLatitude, myPlaces[i].placeLongitude)
    //                let regionRadius = 100.0
    //                let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,longitude: coordinate.longitude), radius: regionRadius, identifier: title)
    //                myLocationManager.startMonitoring(for: region)
    //            }
    //        }
    //        // }
    //    }
    
    func enterRegion(region: CLRegion){
        var placeEntering = DBManager.getInstance().getPlace(Int: Int32(region.identifier)!)
        var category2 = "entering myPlace"
        
        if region.identifier.contains("c"){
            var id = region.identifier
            id.remove(at: id.startIndex)
            placeEntering = DBManager.getInstance().getCommonPlace(Int: Int32(id)!)
            category2 = "entering commonPlace"
        }
        
        let latitude = placeEntering!.placeLatitude
        let longitude = placeEntering!.placeLongitude
        let startDate = self.showDate.string(from: enterTime)
        let startTime = self.showTime.string(from: enterTime)
        let weekday = Calendar.current.component(.weekday, from: enterTime)
        let name1 = placeEntering!.placeName
        let name2 = "\(placeEntering!.placeId!)"
        let name3 = ""
        let name4 = ""
        let name5 = ""
        let category1 = placeEntering!.placeCategory
        let category3 = ""
        let category4 = ""
        let category5 = ""
        
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        
        let modelInfo = LocationModel(locationId: 0, longitude: longitude, latitude: latitude, startDate: startDate, startTime: startTime, weekday: Int32(weekday), duration: 0, name1: name1, name2: name2, name3: name3, name4: name4, name5: name5, category1: category1, category2: category2, category3: category3, category4: category4, category5: category5, speed: myLocationManager.location!.speed)
        
        let id = DBManager.getInstance().saveLocation(modelInfo)
        
        let data : [String: String] = ["user_location_id":String(id),"longitude":String(modelInfo.longitude), "latitude":String(modelInfo.latitude), "start_date":modelInfo.startDate, "start_time":modelInfo.startTime,"weekday":String(modelInfo.weekday), "duration":"0", "speed":String(modelInfo.speed), "name1":modelInfo.name1!, "name2":modelInfo.name2!, "name3":modelInfo.name3!, "name4":modelInfo.name4!, "name5":modelInfo.name5!, "category1":modelInfo.category1!, "category2":modelInfo.category2!, "category3":modelInfo.category3!, "category4":modelInfo.category4!, "category5":modelInfo.category5!, "user_id":String(user_id) ]
        
        net.postLocationData(data: data){
            (status_code) in
            if (status_code != nil) {
                print(status_code!)
            }
        }
        
    }
    
    func exitRegion(region: CLRegion){
        var placeExiting = DBManager.getInstance().getPlace(Int: Int32(region.identifier)!)
        var category2 = "exiting myPlace"
        
        if region.identifier.contains("c"){
            var id = region.identifier
            id.remove(at: id.startIndex)
            placeExiting = DBManager.getInstance().getCommonPlace(Int: Int32(id)!)
            category2 = "exiting commonPlace"
        }
        
        let latitude = placeExiting!.placeLatitude
        let longitude = placeExiting!.placeLongitude
        let startDate = self.showDate.string(from: exitTime)
        let startTime = self.showTime.string(from: exitTime)
        let weekday = Calendar.current.component(.weekday, from: exitTime)
        let name1 = placeExiting!.placeName
        let name2 = "\(placeExiting!.placeId!)"
        let name3 = ""
        let name4 = ""
        let name5 = ""
        let category1 = placeExiting!.placeCategory
        let category3 = ""
        let category4 = ""
        let category5 = ""
        
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        
        let modelInfo = LocationModel(locationId: 0, longitude: longitude, latitude: latitude, startDate: startDate, startTime: startTime, weekday: Int32(weekday), duration: 0, name1: name1, name2: name2, name3: name3, name4: name4, name5: name5, category1: category1, category2: category2, category3: category3, category4: category4, category5: category5, speed: myLocationManager.location!.speed)
        
        let id = DBManager.getInstance().saveLocation(modelInfo)
        
        let data : [String: String] = ["user_location_id":String(id),"longitude":String(modelInfo.longitude), "latitude":String(modelInfo.latitude), "start_date":modelInfo.startDate, "start_time":modelInfo.startTime,"weekday":String(modelInfo.weekday), "duration":"0", "speed":String(modelInfo.speed), "name1":modelInfo.name1!, "name2":modelInfo.name2!, "name3":modelInfo.name3!, "name4":modelInfo.name4!, "name5":modelInfo.name5!, "category1":modelInfo.category1!, "category2":modelInfo.category2!, "category3":modelInfo.category3!, "category4":modelInfo.category4!, "category5":modelInfo.category5!, "user_id":String(user_id) ]
        
        net.postLocationData(data: data){
            (status_code) in
            if (status_code != nil) {
                print(status_code!)
            }
        }
        
    }
    
    func makeNotification(String: String){
        let no = UNMutableNotificationContent()
        no.title = "Motitor Region Notification"
        no.body = String
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Monitor Region Notification", content: no, trigger: trigger)
        UNUserNotificationCenter.current().add(request,withCompletionHandler: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("在前景收到通知...")
        completionHandler([.alert,.sound,.badge])
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("fail to monitor region:\(region)")
    }
    
}
