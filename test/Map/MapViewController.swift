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
    
    var myLocationManager :CLLocationManager!
    var myLocation :CLLocation!
    var searchResult = [String]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocationManager = CLLocationManager()
        //        myMapView.delegate = self as MKMapViewDelegate
        
        // 設置委任對象
        myLocationManager.delegate = self
        //
        // 距離篩選器 用來設置移動多遠距離才觸發委任方法更新位置
        // myLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        //
        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.startUpdatingLocation()
        
        
        // Map
        // 設置委任對象
        // myMapView.delegate = self as MKMapViewDelegate
        
        // 地圖樣式
        myMapView.mapType = .standard
        
        // 顯示自身定位位置
        myMapView.showsUserLocation = true
        
        // 允許縮放地圖
        myMapView.isZoomEnabled = true
        
        //
        guard let coordinate = self.myMapView.userLocation.location?.coordinate else{
            return
        }
        myMapView.setCenter(coordinate, animated: true)
        
        let center = coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        myMapView.setRegion(region, animated: true)
        tblView.delegate = self
        
    }
    
    func startLocationManager(){
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.activityType = CLActivityType.fitness
        myLocationManager.distanceFilter = 50
        myLocationManager.startUpdatingLocation()
    }
    
    var searchQuerys = ["store", "shop", "coffee",]
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
        print("\(currentLocation.latitude)")
        print("\(currentLocation.longitude)")
        
        //    取得時間
        let currentTime = Date()
        print(currentTime)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        // 設定時區(台灣)
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        let dateFormatString: String = dateFormatter.string(from: currentTime)
        print("dateFormatString: \(dateFormatString)")
        
        //將map中心點定在目前所在的位置
        //span是地圖zoom in, zoom out的級距
        let _span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005);
        self.myMapView.setRegion(MKCoordinateRegion(center: currentLocation, span: _span), animated: true);
        
        // 加入到畫面中
        self.view.addSubview(myMapView)
        
        
        // 確保didUpdateLocations只呼叫一次
        // manager.delegate = nil
        
        let request = MKLocalSearch.Request()
        
        // 搜尋附近地點的範圍
        request.region = MKCoordinateRegion(center: locations[0].coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
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
                    let distance = CLLocation(latitude: (self.searchResults[i].placemark.coordinate.latitude), longitude: (self.searchResults[i].placemark.coordinate.longitude)).distance(from: CLLocation(latitude: (currentLocation.latitude), longitude: (currentLocation.longitude)))
                    self.locationDic[distance] = locationName
                    i += 1
                }
                
                self.searchAllResults.removeAll()
                self.searchResults.removeAll()
                self.tblView.reloadData()
                
            }
            
        }
        myLocationManager.stopUpdatingLocation()
        
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
}


extension MapViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar : UISearchBar, textDidChange searchText: String){
        //        searchResult = sortedArr.filter({$0.lowercased().contains(searchText.lowercased())})
        searching = true
        locationDic.removeAll()
        if let btnCancel = searchBar.value(forKey: "cancelButton") as? UIButton {
            btnCancel.isEnabled = true
        }
        if searching == true{
            searchQuerys.removeAll()
            searchQuerys.append(searchText)
            startLocationManager()
            print(searchQuerys)
            searching = false
            tblView.reloadData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        sortedArr.removeAll()
        searchQuerys = ["store", "shop", "coffee"]
        startLocationManager()
        tblView.reloadData()
        self.searchBar.endEditing(true)
    }
}

