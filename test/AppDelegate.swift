import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    //    let locationManager = CLLocationManager()
    var myLocationManager :CLLocationManager!
    var myLocation :CLLocation!
    var currentSpeed :CLLocationSpeed = CLLocationSpeed()
    var dbSpeed:Double = 55.66
    var currentLocation = CLLocationCoordinate2D()
    //var dateFormatString: String?
    
    var placesClient: GMSPlacesClient!
    var filterList = [String]()
    //    var searching = false
    var collectionArr = [String]()
    
    //DB variables
    var locationId: Int32 = 0
    var longitude: Double! = 0
    var latitude: Double! = 0
    var startTime: String! = ""
    var duration: String = ""
    var name1: String = ""
    var name2: String = ""
    var name3: String = ""
    var name4: String = ""
    var name5: String = ""
    var category1: String = ""
    var category2: String = ""
    var category3: String = ""
    var category4: String = ""
    var category5: String = ""
    var speed: Double! = 0
    
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
        
        myLocationManager = CLLocationManager()
        //        myLocationManager.startMonitoringVisits()
        myLocationManager.distanceFilter = 10
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        myLocationManager.delegate = self
        
        myLocationManager.allowsBackgroundLocationUpdates = true
        myLocationManager.pausesLocationUpdatesAutomatically = false
        myLocationManager.activityType = CLActivityType.fitness

        myLocationManager.requestAlwaysAuthorization()
        myLocationManager.startUpdatingLocation()
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge,.carPlay], completionHandler: (granted, error))
        
        print(CLLocationManager.authorizationStatus().rawValue)
        return true
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        
        //取得目前的座標位置
        let c = locations[0] as CLLocation;
        currentLocation = CLLocationCoordinate2D(latitude: c.coordinate.latitude, longitude: c.coordinate.longitude);
        
        //    取得時間
        //let currentTime = Date()
        //let dateFormatter: DateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        // 設定時區(台灣)
        //dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        //dateFormatString = dateFormatter.string(from: Date())
        
        currentSpeed = myLocationManager.location!.speed
        
        if currentSpeed == -1.0 && currentSpeed != dbSpeed{
            saveInDB()
        }
        self.dbSpeed = currentSpeed
        
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
                print(placeLikelihoods)
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
            self.latitude = Double(self.currentLocation.latitude)
            self.longitude = Double(self.currentLocation.longitude)
            self.startTime = showDateformatter.string(from: Date())
            //self.duration = e.timeIntervalSince(Date())
            self.name1 = self.likelyPlaces[0].name!
            self.name2 = self.likelyPlaces[1].name!
            self.name3 = self.likelyPlaces[2].name!
            self.name4 = self.likelyPlaces[3].name!
            self.name5 = self.likelyPlaces[4].name!
            self.category1 = self.likelyPlaces[0].types![0]
            self.category2 = self.likelyPlaces[1].types![0]
            self.category3 = self.likelyPlaces[2].types![0]
            self.category4 = self.likelyPlaces[3].types![0]
            self.category5 = self.likelyPlaces[4].types![0]
            self.speed = self.currentSpeed
            
            let modelInfo = LocationModel(locationId: self.locationId, longitude: self.longitude!, latitude: self.latitude!, startTime: self.startTime!, duration: self.duration, name1: self.name1, name2: self.name2, name3: self.name3, name4: self.name4, name5: self.name5, category1:self.category1, category2:self.category2, category3:self.category3, category4:self.category4, category5:self.category5,speed: self.speed)
            
            let id = DBManager.getInstance().saveLocation(modelInfo)
            DBManager.getInstance().save
            
            print("save in DB :", isSaved)
            
            self.myLocationManager.startUpdatingLocation()
            self.myLocationManager.delegate = nil
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

