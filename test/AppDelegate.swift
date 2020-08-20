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
    
    var myPlaces = [PlaceModel]()
    
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
    //var selectPlaces:[GMSPlace] = []
    //var selectedPlace: GMSPlace?
    //var location : LocationModel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if UserDefaults.standard.bool(forKey: "isLogIn"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! tabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabBarController
        }
        
        // Override point for customization after application launch.
        let googleApiKey = "AIzaSyDby_1_EFPvVbDWYx06bwgMwt_Sz3io2xQ"
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
        
        Util.copyDatabase("project.db")
        placesClient = GMSPlacesClient.shared()
    
        myLocationManager.delegate = self
        myLocationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
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
//        myLocationManager.requestAlwaysAuthorization()
        //myLocationManager.startUpdatingLocation()
        myLocationManager.startMonitoringSignificantLocationChanges()
//        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                print("允許")
            } else {
                print("不允許")
            }
        })
        UNUserNotificationCenter.current().delegate = self
        
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if CLLocationManager.authorizationStatus() == .notDetermined{
             myLocationManager.requestAlwaysAuthorization()
            
        }else if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
            DispatchQueue.main.async(){
                let alertController = UIAlertController(title: "定位權限已被關閉或限制", message: "可能影響app紀錄準確度 \n如要變更權限，請至 設定>隱私權>定位服務 開啟永遠允許", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }else{
            startMonitorRegion()
            let user_id = UserDefaults.standard.integer(forKey: "user_id")
                    let last_track_id = UserDefaults.standard.integer(forKey: "last_track_id")
                    let data = ["user_id":String(user_id),"last_track_id":String(last_track_id)]
                    self.net.pushTrackData(data: data){
                                    (return_list) in
                                    if let status_code = return_list?[0],
                                        let data = return_list?[1] as? [[Any]],
                                        let last_track_id = return_list?[2]{
                                        if status_code as! Int == 200{
                                            UserDefaults.standard.set(last_track_id, forKey: "last_track_id")
                                            for i in 0...data.count-1{
                                                print(data)
                                                let modelInfo = TrackModel(trackId: 0, startDate: data[i][2] as! String, startTime: data[i] as! String, weekDay: data[i] as! Int32, endDate: data[i] as! String, endTime: data[i]  as! String, categoryId: data[i] as! Int32, locationId: data[i] as! Int32, placeId: data[i] as? Int32)
                                                print(data[i][2] as! String)
                                                
                                                DBManager.getInstance().addTrack(modelInfo)
                                            }
                                        }
                                        else{
                                            print(status_code)
                                        }
                                    }else{
                                        print("error")
                                        }
                                    }
            }

        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    


extension AppDelegate: CLLocationManagerDelegate, UNUserNotificationCenterDelegate{
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
    
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
            
//            for i in 0...4{
//                self.selectPlaces.append(self.likelyPlaces[i])
//            }
            
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
            
        })
        self.myLocationManager.delegate = self
        
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
        let myLocation = (DBManager.getInstance().getMaxLocation())!
        let data : [String: String] = ["location_id":"0",
                                       "user_location_id": "\(myLocation.locationId!)",
                                       "longitude":String(myLocation.longitude), "latitude":String(myLocation.latitude), "start_date":myLocation.startDate, "start_time":myLocation.startTime,"weekday":String(myLocation.weekday), "duration":"0", "speed":String(myLocation.speed), "name1":myLocation.name1!, "name2":myLocation.name2!, "name3":myLocation.name3!, "name4":myLocation.name4!, "name5":myLocation.name5!, "category1":myLocation.category1!, "category2":myLocation.category2!, "category3":myLocation.category3!, "category4":myLocation.category4!, "category5":myLocation.category5!, "user_id":String(user_id)]
                   
        self.net.postLocationData(data: data){
            (status_code) in
            if (status_code != nil) {
                print(status_code!)
            }
        }
        
        self.myLocationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    }
    
    func startMonitorRegion(){
        print(CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self))
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
//
//            let title = "Lorrenzillo's"
//            let coordinate = CLLocationCoordinate2DMake(37.703026, -121.759735)
//            let regionRadius = 300.0
//
//            // 3. 設置 region 的相關屬性
//            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
//                longitude: coordinate.longitude), radius: regionRadius, identifier: title)
//            myLocationManager.startMonitoring(for: region)
            if DBManager.getInstance().getMyPlaces() != nil{
                myPlaces = DBManager.getInstance().getMyPlaces()
                for i in 0...myPlaces.count-1{
                    let title = myPlaces[i].placeName
                    let coordinate = CLLocationCoordinate2DMake(myPlaces[i].placeLatitude, myPlaces[i].placeLongitude)
                    let regionRadius = 200.0
                    let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                        longitude: coordinate.longitude), radius: regionRadius, identifier: title)
                    myLocationManager.startMonitoring(for: region)
                }
            }
        }
    }
    
    // 1. 當用戶進入一個 region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        makeNotification(String: "You enter \(region.identifier)!!!")
    }
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        makeNotification(String: "didStartMonitoringFor")
        print(region)
    }

    // 2. 當用戶退出一個 region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        makeNotification(String: "You exit \(region.identifier)!!!")
    }
    
//    func showAlert(String: String){
//        let controller = UIAlertController(title: "WOW", message: String, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default){_ in
//            controller.dismiss(animated: true, completion: nil)}
//        controller.addAction(okAction)
//        self.window?.rootViewController?.present(controller, animated: true,completion: .none)
//    }
    
    func makeNotification(String: String){
        let no = UNMutableNotificationContent()
            no.title = "Motitor Region Notification"
            no.body = String
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
        let request = UNNotificationRequest(identifier: "Motitor Region Notification", content: no, trigger: trigger)
        UNUserNotificationCenter.current().add(request,withCompletionHandler: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("在前景收到通知...")
        completionHandler([.alert,.sound,.badge])
    }
    
}
