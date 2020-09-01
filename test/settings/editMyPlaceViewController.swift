//
//  editMyPlaceViewController.swift
//  test
//
//  Created by 謝宛軒 on 2020/8/11.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class editMyPlaceViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    //@IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var txtRegionRadius: UILabel!
    
    var myPlaceCategory = "Others"
    var myPlaceName = ""
    var id: Int32 = 0
    var myPlaceLongitude: Double! = 0
    var myPlaceLatitude: Double! = 0
    var regionRadius: Double! = 200
    var myPlace: PlaceModel?
    
    var resultsArray:[Dictionary<String, AnyObject>] = Array()
    
    let currentLocation = CLLocationManager()
    //var location = CLLocation()
    let marker = GMSMarker()
    var circle = GMSCircle()
    
    //    var myPlace: Bool! = true
    //    var noAdd = false
    //    var userLocation = CLLocation()
    
    override func viewDidLoad() {
        tbView.translatesAutoresizingMaskIntoConstraints = false
        
        let btnAdd = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addMyPlaceButton(_:)))
        let btnEdit = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editMyPlaceButton(_:)))
        let btnCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(_:)))
        
        self.txtSearch.placeholder = "search place"
        
        if myPlace != nil{
            navigationItem.rightBarButtonItems = [btnEdit]
            navigationItem.leftBarButtonItems = [btnCancel]
            navigationItem.title = "Edit My Place"
            loadData()
        }else{
            navigationItem.rightBarButtonItems = [btnAdd]
            navigationItem.leftBarButtonItems = [btnCancel]
            navigationItem.title = "Add My Place"
            //用simulator的時候就跑這兩行
//            myPlaceLatitude = 24.986
//            myPlaceLongitude = 121.576
            myPlaceLatitude = (currentLocation.location?.coordinate.latitude)!
            myPlaceLongitude = (currentLocation.location?.coordinate.longitude)!
        }
        
    }
    
    @IBAction func cricleZoom(_ sender: UISlider){
        sender.value = roundf(sender.value/50)*50
        regionRadius = Double(sender.value)
        circle.radius = CLLocationDistance(sender.value)
        let update = GMSCameraUpdate.fit(circle.bounds())
        mapView.animate(with: update)
        txtRegionRadius.text = "Region Size: \(Int(sender.value)) m"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.5)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)]
        
        //        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.location?.coordinate.latitude)!, longitude: (currentLocation.location?.coordinate.longitude)!, zoom: 17.0)
        //        myPlaceLatitude = (currentLocation.location?.coordinate.latitude)!
        //        myPlaceLongitude = (currentLocation.location?.coordinate.longitude)!
        
        mapView.delegate = self
        let camera = GMSCameraPosition.camera(withLatitude: myPlaceLatitude, longitude: myPlaceLongitude, zoom: 18)
        mapView.camera = camera
        mapView.animate(to: camera)
        
        marker.position = CLLocationCoordinate2D(latitude: myPlaceLatitude, longitude: myPlaceLongitude)
        circle = GMSCircle(position: marker.position, radius: 200)
        //circle.radius = 200
        circle.position = marker.position
        circle.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
        circle.strokeColor = UIColor.red
        circle.strokeWidth = 2
        marker.map = mapView
        circle.map = mapView
        print(circle)
        
        let update = GMSCameraUpdate.fit(circle.bounds())
        mapView.animate(with: update)

        //        marker.position = CLLocationCoordinate2D(latitude: (currentLocation.location?.coordinate.latitude)!, longitude: (currentLocation.location?.coordinate.longitude)!)
//        circle.position = marker.position
//        circle.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
//        circle.radius = 200
//        circle.strokeColor = UIColor.red
        //circle.map = mapView
        
        if self.tbView.tableFooterView == nil {
            tbView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    //    override func viewDidDisappear(_ animated: Bool) {
    //        currentLocationManager.startUpdatingLocation()
    //    }
    
    func mapView(_ MapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        changePosition(marker: marker, a: coordinate)
        myPlaceLatitude = coordinate.latitude
        myPlaceLongitude = coordinate.longitude
        //location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func changePosition(marker : GMSMarker, a: CLLocationCoordinate2D){
        let cam = GMSCameraPosition.camera(withLatitude: a.latitude, longitude: a.longitude, zoom: mapView.camera.zoom)
        mapView.camera = cam
        marker.position = CLLocationCoordinate2D(latitude: a.latitude, longitude: a.longitude)
        circle.position = marker.position
    }
    
    func loadData(){
        id = myPlace!.placeId!
        myPlaceCategory = myPlace!.placeCategory.capitalized
        myPlaceName = myPlace!.placeName
        myPlaceLongitude = myPlace!.placeLongitude
        myPlaceLatitude = myPlace!.placeLatitude
    }
    
    @IBAction func myPlaceCategorySegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "myPlaceCategorySegueBack"{
            let VC = segue.source as? myPlaceCategoryViewController
            let i = VC?.tableView.indexPathForSelectedRow?.row
            myPlaceCategory = VC?.myPlaceCategorys[i ?? 4] ?? "others"
            tbView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .none)
        }
    }
    
    @objc func addMyPlaceButton(_ sender: UIButton){
        self.view.endEditing(true)
        if myPlaceName == ""{
            alertMessage()
        }else{
            let controller = UIAlertController(title: "Friendly Reminders 🥕", message: "Check whether the marker on the map is in the correct region of your place \"\(self.myPlaceName)\"" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "add", style: .default){_ in
                let modelInfo = PlaceModel(placeId: self.id, placeName: self.myPlaceName, placeCategory: self.myPlaceCategory.lowercased(), placeLongitude: self.myPlaceLongitude, placeLatitude: self.myPlaceLatitude, regionRadius: self.regionRadius, myPlace: true)
                           let id = DBManager.getInstance().addPlace(modelInfo)
                           self.startMonitorRegion(placeId: id)
                controller.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "editMyPlaceSegueBack", sender: self)
            }
            let cancelAction = UIAlertAction(title: "Go Check", style: .default){_ in
            controller.dismiss(animated: true, completion: nil)}
            controller.addAction(cancelAction)
            controller.addAction(okAction)
            self.present(controller, animated: true,completion: .none)
            
//            let modelInfo = PlaceModel(placeId: id, placeName: myPlaceName, placeCategory: myPlaceCategory.lowercased(), placeLongitude: myPlaceLongitude, placeLatitude: myPlaceLatitude, myPlace: true)
//            let id = DBManager.getInstance().addPlace(modelInfo)
//            startMonitorRegion(placeId: id)
            //            let title = myPlaceName
            //            let coordinate = CLLocationCoordinate2DMake(myPlaceLatitude, myPlaceLongitude)
            //            let regionRadius = 200.0
            //            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
            //                longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            //            myLocationManager.startMonitoring(for: region)
        }
    }

    func startMonitorRegion(placeId: Int32){
    //print(CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self))
    if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
        let monitorPlace = DBManager.getInstance().getPlace(Int: placeId)
        let title = "\(monitorPlace!.placeId!)"
        let coordinate = CLLocationCoordinate2DMake(monitorPlace!.placeLatitude, monitorPlace!.placeLongitude)
        let regionRadius = 200.0
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,longitude: coordinate.longitude), radius: regionRadius, identifier: title)
        myLocationManager.startMonitoring(for: region)
        print("startMonitorRegion\(placeId)")
         }
    }
    
    
    @objc func editMyPlaceButton(_ sender: UIButton){
        self.view.endEditing(true)
        if myPlaceName == ""{
            alertMessage()
        }
        let modelInfo = PlaceModel(placeId: id, placeName: myPlaceName, placeCategory: myPlaceCategory.lowercased(), placeLongitude: myPlaceLongitude, placeLatitude: myPlaceLatitude, regionRadius: regionRadius, myPlace: true)
        DBManager.getInstance().editPlace(modelInfo)
        startMonitorRegion(placeId: id)
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "editMyPlaceSegueBack", sender: self)
    }
    
    @objc func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func alertMessage(){
        let controller = UIAlertController(title: "Error", message: "Enter a name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){_ in
            controller.dismiss(animated: true, completion: nil)}
        controller.addAction(okAction)
        self.present(controller, animated: true,completion: .none)
    }
    
}

extension editMyPlaceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if txtSearch.text!.isEmpty{
            return 2
        }else{
            return resultsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !txtSearch.text!.isEmpty{
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell")
            if resultsArray.count != 0{
                cell?.textLabel?.text = "\(resultsArray[indexPath.row]["name"]!)"
                cell?.detailTextLabel?.text = "\(resultsArray[indexPath.row]["formatted_address"] as! String)"
            }
            return cell!
        }else{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier:"myPlaceName",for: indexPath) as! editMyplaceNameCell
                cell.txtName.text = myPlaceName
                cell.selectionStyle = .none
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier:"myPlaceCategory") as! editMyplaceCategoryCell
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                cell.category.text = myPlaceCategory
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if !txtSearch.text!.isEmpty{
            var location = [String:[String:Any]]()
            location["location"] = resultsArray[indexPath.row]["geometry"]!["location"] as? [String:Any]
            myPlaceLatitude = location["location"]!["lat"] as? Double
            myPlaceLongitude = location["location"]!["lng"] as? Double
            changePosition(marker: marker, a: CLLocationCoordinate2DMake(myPlaceLatitude, myPlaceLongitude))
            txtSearch.text = nil
            tbView.reloadData()
        }else{
            if indexPath.row == 1{
                performSegue(withIdentifier: "myPlaceCategory", sender: nil)
            }
        }
    }
    
}

extension editMyPlaceViewController: UITextFieldDelegate,UISearchBarDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        myPlaceName = textField.text!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        searchPlaceFromGoogle(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @objc func searchPlaceFromGoogle(_ textField: UISearchBar) {
        
        if let searchQuery = textField.text {
            var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(searchQuery)&key= AIzaSyDby_1_EFPvVbDWYx06bwgMwt_Sz3io2xQ"
            strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            var urlRequest = URLRequest(url: URL(string: strGoogleApi)!)
            urlRequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, resopnse, error) in
                if error == nil {
                    
                    if let responseData = data {
                        let jsonDict = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        
                        if let dict = jsonDict as? Dictionary<String, AnyObject>{
                            
                            if let results = dict["results"] as? [Dictionary<String, AnyObject>] {
                                //                            print("json == \(results)")
                                self.resultsArray.removeAll()
                                for dct in results {
                                    self.resultsArray.append(dct)
                                }
                                
                                DispatchQueue.main.async {
                                    self.tbView.reloadData()
                                }
                                
                            }
                        }
                        
                    }
                } else {
                    //we have error connection google api
                }
            }
            task.resume()
        }
    }
    
}

extension GMSCircle {
    func bounds () -> GMSCoordinateBounds {
        func locationMinMax(positive : Bool) -> CLLocationCoordinate2D {
            let sign:Double = positive ? 1 : -1
            let dx = sign * self.radius  / 6378000 * (180/M_PI)
            let lat = position.latitude + dx
            let lon = position.longitude + dx / cos(position.latitude * M_PI/180)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }

        return GMSCoordinateBounds(coordinate: locationMinMax(positive: true),
                                   coordinate: locationMinMax(positive: false))
    }
}
