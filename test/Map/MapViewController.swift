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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myMapView: MKMapView!
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
    }
    
    var myLocationManager :CLLocationManager!
    var myLocation :CLLocation!
    var searchResult = [String]()
    var searching = false
    
    //DB variables
    var locationId: Int32 = 0
    var longitude: Double! = 0
    var latitude: Double! = 0
    var startTime: String! = ""
    var endTime: String = ""
    var nearestName: String = ""
    var nearestCategory: String = ""
    
    var location : LocationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocationManager = CLLocationManager()
        
        // 設置委任對象
        myLocationManager.delegate = self
        
        
        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.startUpdatingLocation()
        
        
        // Map
        // 設置委任對象
        myMapView.delegate = self as MKMapViewDelegate
        
        // 地圖樣式
        myMapView.mapType = .standard
        
        
        // 允許縮放地圖
        myMapView.isZoomEnabled = true
        setMap(latitude: 25.035915, longitude: 121.563619)
  
    }
    
    func startLocationManager(){
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.activityType = CLActivityType.fitness
        myLocationManager.distanceFilter = 50
        myLocationManager.startUpdatingLocation()
    }
    
    var searchQuerys = ["store", "shop", "coffee", "restaurant", "hospital", "bank" ,"library","museum","park", "hotel", "school", "police"]
    var searchResults = [MKMapItem]()
    var searchAllResults = [MKMapItem]()
    var location_arr = [String]()
    var sortedArr = [String]()
    var locationDic = [Double: String]()
   
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
        manager.delegate = nil
        
        searchLocation(latitude: 25.035915, longitude: 121.563619)
        myLocationManager.stopUpdatingLocation()
        
        
        //DB
        latitude = currentLocation.latitude
        longitude = currentLocation.longitude
        startTime = dateFormatString
        
        let modelInfo = LocationModel(locationId: locationId, longitude: longitude!, latitude: latitude!, startTime: startTime!, endTime: endTime, nearestName: nearestName, nearestCategory: nearestCategory)
        
        let isSaved = DBManager.getInstance().saveLocation(modelInfo)
        print(isSaved)
        
        
        
    }
    
    
    func searchLocation(latitude: Double, longitude:Double ){
        
        let request = MKLocalSearch.Request()
        
        
        
        request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        for searchQuery in searchQuerys {
            
            // 搜尋附近地點類型的關鍵字(ex. store,hotel,coffee...)，place為所有類型
            request.naturalLanguageQuery = searchQuery
            
            let search = MKLocalSearch(request: request)
            
            // 搜尋附近地點的結果
            search.start { (response, error) in
                guard let searchResponse = response else {
                    return
                }
                
                // 所有關鍵字得到的資料放入searchAllResults
                self.searchAllResults.append(contentsOf: searchResponse.mapItems)
                
                // 再把searchAllResults存入searchResults
                self.searchResults = self.searchAllResults
                
                var i = 0
                while self.searchResults.count > i{
                    let locationName: String? = self.searchResults[i].name
                    self.location_arr.append(locationName!)
                    let distance = CLLocation(latitude: (self.searchResults[i].placemark.coordinate.latitude), longitude: (self.searchResults[i].placemark.coordinate.longitude)).distance(from: CLLocation(latitude: (25.035915), longitude: (121.563619)))
                    if distance <= 1000{
                        self.locationDic[distance] = locationName
                    }
                    i += 1
                    
                }
                self.searchAllResults.removeAll()
                self.searchResults.removeAll()
                self.tblView.reloadData()
                
            }
            
            
        }
        print(self.location_arr)
        self.location_arr.removeAll()
        
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
        //sort by distance
        var sortedLocation = locationDic.sorted { firstDictionary, secondDictionary in
            return firstDictionary.0 < secondDictionary.0 // 由小到大排序
        }
        sortedArr.removeAll()
        for each in sortedLocation{
            sortedArr.append(each.value+"  "+String(Int(each.key))+"m")
        }
        sortedLocation.removeAll()
        if searching{
            return searchResult.count
        }else{
            return sortedArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching{
            cell?.textLabel?.text = String(searchResult[indexPath.row])
        }else{
            cell?.textLabel?.text = String(sortedArr[indexPath.row])
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion:nil)
    }
}


extension MapViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar : UISearchBar, textDidChange searchText: String){
        
        searching = true
        locationDic.removeAll()
        if let btnCancel = searchBar.value(forKey: "cancelButton") as? UIButton {
            btnCancel.isEnabled = true
        }
        if searching == true{
            searchQuerys.removeAll()
            searchQuerys.append(searchText)
            searchLocation(latitude: 25.035915, longitude: 121.563619)
            print(searchQuerys)
            searching = false
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        sortedArr.removeAll()
        searchQuerys = ["store", "shop", "coffee", "restaurant", "hospital", "bank" ,"library","museum","park", "hotel", "school", "police"]
        tblView.reloadData()
        searchLocation(latitude: 25.035915, longitude: 121.563619)
        self.searchBar.endEditing(true)
    }
}



