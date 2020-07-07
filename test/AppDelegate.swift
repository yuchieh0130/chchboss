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
    var lastSpeed:Double = 55.66
    var lastStartTime:String = ""
    //var currentLocation = CLLocationCoordinate2D()
    //var dateFormatString: String?
    
    var placesClient: GMSPlacesClient!
    var filterList = [String]()
    //    var searching = false
    var collectionArr = [String]()
    
    //DB variables
//    var locationId: Int32 = 0
//    var longitude: Double! = 0
//    var latitude: Double! = 0
//    var startTime: String! = ""
//    var duration: Double = 0
//    var name1: String = ""
//    var name2: String = ""
//    var name3: String = ""
//    var name4: String = ""
//    var name5: String = ""
//    var category1: String = ""
//    var category2: String = ""
//    var category3: String = ""
//    var category4: String = ""
//    var category5: String = ""
//    var speed: Double! = 0
    
    //let networkController = NetworkController
    let net = NetworkController()
    
    var showDateformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
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
        myLocationManager.distanceFilter = 50
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest //kCLLocationAccuracyNearestTenMeters //kCLLocationAccuracyBestForNavigation
        myLocationManager.allowsBackgroundLocationUpdates = true
        myLocationManager.pausesLocationUpdatesAutomatically = false
        myLocationManager.activityType = CLActivityType.fitness

        myLocationManager.requestAlwaysAuthorization()
        myLocationManager.startUpdatingLocation()
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge,.carPlay], completionHandler: (granted, error))
        self.lastStartTime = showDateformatter.string(from: Date())
        return true
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        
        //取得目前的座標位置
        //let c = locations[0] as CLLocation
        print(locations)
        self.currentLocation = locations[0] as CLLocation
        
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
        if myLocationManager.location!.horizontalAccuracy>=0{
            //myLocationManager.stopUpdatingLocation()
            if myLocationManager.location!.speed > 0{
               saveSpeed()
            }else{
               saveInDB()
            }
            //myLocationManager.startUpdatingLocation()
        }
        self.lastSpeed = myLocationManager.location!.speed
        
    }
    
    func saveSpeed(){
//        self.latitude = Double(self.currentLocation.latitude)
//        self.longitude = Double(self.currentLocation.longitude)
//        self.startTime = self.showDateformatter.string(from: Date())
        let latitude = Double(self.currentLocation.coordinate.latitude)
        let longitude = Double(self.currentLocation.coordinate.longitude)
        let startTime = self.showDateformatter.string(from: Date())
        let speed = self.myLocationManager.location!.speed
        
        let modelInfo = LocationModel(locationId: 0, longitude: longitude, latitude: latitude, startTime: startTime, duration: 0, name1: "", name2: "", name3: "", name4: "", name5: "", category1: "", category2: "", category3: "", category4: "", category5: "",speed: speed)
        
        let duration = Date().timeIntervalSince(self.showDateformatter.date(from: self.lastStartTime)!)
        let isSaved = DBManager.getInstance().saveDuration(double: duration)
        DBManager.getInstance().saveLocation(modelInfo)
        self.lastStartTime = startTime
        
    }
    
    func saveInDB(){
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
            
            //DB
//            self.latitude = Double(self.currentLocation.latitude)
//            self.longitude = Double(self.currentLocation.longitude)
//            self.startTime = self.showDateformatter.string(from: Date())
//            self.name1 = self.likelyPlaces[0].name!
//            self.name2 = self.likelyPlaces[1].name!
//            self.name3 = self.likelyPlaces[2].name!
//            self.name4 = self.likelyPlaces[3].name!
//            self.name5 = self.likelyPlaces[4].name!
//            self.category1 = self.likelyPlaces[0].types![0]
//            self.category2 = self.likelyPlaces[1].types![0]
//            self.category3 = self.likelyPlaces[2].types![0]
//            self.category4 = self.likelyPlaces[3].types![0]
//            self.category5 = self.likelyPlaces[4].types![0]
//            self.speed = self.currentSpeed
            
            //  let modelInfo = LocationModel(locationId: self.locationId, longitude: self.longitude!, latitude: self.latitude!, startTime: self.startTime!, duration: 0, name1: self.name1, name2: self.name2, name3: self.name3, name4: self.name4, name5: self.name5, category1:self.category1, category2:self.category2, category3:self.category3, category4:self.category4, category5:self.category5,speed: self.speed)
//            self.duration = Date().timeIntervalSince(self.showDateformatter.date(from: self.lastStartTime)!)
//            let isSaved = DBManager.getInstance().saveDuration(double: self.duration)
//            DBManager.getInstance().saveLocation(modelInfo)
            
            let latitude = Double(self.currentLocation.coordinate.latitude)
            let longitude = Double(self.currentLocation.coordinate.longitude)
            let startTime = self.showDateformatter.string(from: Date())
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
            
            let modelInfo = LocationModel(locationId: 0, longitude: longitude, latitude: latitude, startTime: startTime, duration: 0, name1: name1, name2: name2, name3: name3, name4: name4, name5: name5, category1: category1, category2: category2, category3: category3, category4: category4, category5: category5,speed: speed)
            
            
            let duration = Date().timeIntervalSince(self.showDateformatter.date(from: self.lastStartTime)!)
            let isSaved = DBManager.getInstance().saveDuration(double: duration)
            DBManager.getInstance().saveLocation(modelInfo)
            
            let data : [String: String] = ["location_id":"0", "longitude":String(longitude), "latitude":String(latitude), "start_time":startTime, "duration":String(duration), "speed":String(speed), "name1":name1, "name2":name2, "name3":name3, "name4":name4, "name5":name5, "category1":category1, "category2":category2, "category3":category3, "category4":category4, "category5":category5]
            
//            let data : [String: String] = ["location_id":"0", "longitude":String(self.longitude), "latitude":String(self.latitude), "start_time":self.startTime, "duration":String(self.duration), "speed":String(self.speed), "name1":self.name1, "name2":self.name2, "name3":self.name3, "name4":self.name4, "name5":self.name5, "category1":self.category1, "category2":self.category2, "category3":self.category3, "category4":self.category4, "category5":self.category5]
            
            self.net.postLocationData(data: data){
                (status_code) in
                if (status_code != nil) {
                    print(status_code!)
                }
            }
            
            self.lastStartTime = startTime
            
            //self.myLocationManager.startUpdatingLocation()
            //self.myLocationManager.delegate = nil
            //self.myLocationManager.delegate = self
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

