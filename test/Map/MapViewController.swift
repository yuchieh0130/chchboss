//
//  ViewController.swift
//  searchBar2
//
//  Created by 洪忻柔 on 2020/3/4.
//  Copyright © 2020 洪忻柔. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myMapView: MKMapView!
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
    }
    
    var myLocationManager :CLLocationManager!
    var myLocation :CLLocation!
    var placesClient: GMSPlacesClient!
    var filterList = [String]()
    var searching = false
    var collectionArr = [String]()
    
    //DB variables
    var locationId: Int32 = 0
    var longitude: Double! = 0
    var latitude: Double! = 0
    var startTime: String! = ""
    var endTime: String = ""
    var nearestName: String = ""
    var nearestCategory: String = ""
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    var selectPlaces:[GMSPlace] = []
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    
    var location : LocationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        placesClient = GMSPlacesClient.shared()
        
        myLocationManager = CLLocationManager()
//        myLocationManager.startMonitoringVisits()
        myLocationManager.delegate = self
        
        myLocationManager.allowsBackgroundLocationUpdates = true
        myLocationManager.pausesLocationUpdatesAutomatically = true
        myLocationManager.activityType = CLActivityType.fitness
        
        
        myLocationManager.distanceFilter = 50
        
        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        myLocationManager.startUpdatingLocation()
        
        
        // Map
        myMapView.delegate = self as MKMapViewDelegate
        myMapView.mapType = .standard
        myMapView.isZoomEnabled = true
        setMap(latitude: 25.035915, longitude: 121.563619)
        self.tblView.reloadData()
    }
    
    //    func startLocationManager(){
    //        myLocationManager.delegate = self
    //        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        myLocationManager.activityType = CLActivityType.fitness
    //        myLocationManager.distanceFilter = 50
    //        myLocationManager.startUpdatingLocation()
    //    }
    
    //    // Populate the array with the list of likely places.
    //    func listLikelyPlaces() {
    //      // Clean up from previous sessions.
    //      likelyPlaces.removeAll()
    //
    //      placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
    //        if let error = error {
    //          // TODO: Handle the error.
    //          print("Current Place error: \(error.localizedDescription)")
    //          return
    //        }
    //
    //        // Get likely places and add to the list.
    //        if let likelihoodList = placeLikelihoods {
    //          for likelihood in likelihoodList.likelihoods {
    //            let place = likelihood.place
    //            self.likelyPlaces.append(place)
    //            self.tblView.reloadData()
    //          }
    //        }
    //        print(self.likelyPlaces[1].types![0])
    //        print(type(of: self.likelyPlaces[1].types![0]))
    //      })
    //    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        //取得目前的座標位置
        let c = locations[0] as CLLocation;
        //c.coordinate.latitude 目前緯度
        //c.coordinate.longitude 目前經度
        let currentLocation = CLLocationCoordinate2D(latitude: c.coordinate.latitude, longitude: c.coordinate.longitude);
        
        //    取得時間
        let currentTime = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        // 設定時區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        let dateFormatString: String = dateFormatter.string(from: currentTime)
        
        // 確保didUpdateLocations只呼叫一次
        //        manager.delegate = nil
        likelyPlaces.removeAll()
        self.tblView.reloadData()
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                    self.tblView.reloadData()
                }
            }
            for i in 0...4{
                self.selectPlaces.append(self.likelyPlaces[i])
            }
            print(self.selectPlaces[1].types![0])
            print(type(of: self.selectPlaces[1].types![0]))
            
            //DB
            self.latitude = currentLocation.latitude
            self.longitude = currentLocation.longitude
            self.startTime = dateFormatString
            self.nearestName = self.selectPlaces[1].name!
            self.nearestCategory = self.selectPlaces[0].types![0]
            
            let modelInfo = LocationModel(locationId: self.locationId, longitude: self.longitude!, latitude: self.latitude!, startTime: self.startTime!, endTime: self.endTime, nearestName: self.nearestName, nearestCategory: self.nearestCategory)
            
            let isSaved = DBManager.getInstance().saveLocation(modelInfo)
            print("save in DB :", isSaved)
            
        })
        
        //print(self.likelyPlaces[1].types![0])
        
    }
    
    
    
    
    func setMap(latitude: Double, longitude:Double){
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        pin.title = ""
        
        myMapView.addAnnotation(pin)
        //將map中心點定在目前所在的位置
        //span是地圖zoom in, zoom out的級距
        let _span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001);
        self.myMapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: _span), animated: true);
        self.view.addSubview(myMapView)
        
        //circle
        let circle = MKCircle(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 35)
        self.myMapView.addOverlay(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor(red:52/255, green:152/255, blue:219/255,alpha: 1)
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension MapViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        filterList  = collectionArr.filter { $0.contains(searchBar.text!)}
        if searching{
            return filterList.count
        }else{
            return selectPlaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let collectionItem = selectPlaces[indexPath.row]
        if collectionItem.name !=  nil{
            collectionArr.append(collectionItem.name!)
        }
        if searching{
            cell?.textLabel?.text = String(filterList[indexPath.row])
        }else{
            cell?.textLabel?.text = collectionItem.name
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion:nil)
    }
}


extension MapViewController: UISearchBarDelegate, UITextFieldDelegate{
    
    
    func searchBar(_ searchBar : UISearchBar, textDidChange searchText: String){
        searching = true
        if searchBar.text == ""{
            searching = false
        }
        self.tblView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}


