//
//  NewMapViewController.swift
//  test
//
//  Created by 洪忻柔 on 2020/4/29.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces


class mapViewController: UIViewController, UITableViewDataSource,CLLocationManagerDelegate, UITableViewDelegate, GMSMapViewDelegate {
    
    @IBOutlet var tblView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblPlaces: UITableView!
    
    
    var resultsArray:[Dictionary<String, AnyObject>] = Array()
    let modelLoc = DBManager.getInstance().getLocation()
    lazy var nameArray = [modelLoc?.name1,modelLoc?.name2,modelLoc?.name3,modelLoc?.name4,modelLoc?.name5]
    lazy var categoryArray = [modelLoc?.category1,modelLoc?.category2,modelLoc?.category3,modelLoc?.category4,modelLoc?.category5]
    
    var userLocation = CLLocation()
    var locationDic : [String: Double] = [:]
    var locationDic_c: [String: String] = [:]
    
    //根據距離排序完的結果
    var sortedName = [String]()
    var sortedDist = [Double]()
    var sortedCat = [String]()
    
    var longitude: Double! = 0
    var lantitude: Double! = 0
    
    var savePlace : PlaceModel?
    
    //DB variables
    let placeId: Int32 = 0
    let placeName: String! = ""
    let placeCategory: String = ""
    let placeLongitude: Double! = 0
    let placeLantitude: Double! = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtSearch.addTarget(self, action: #selector(searchPlaceFromGoogle(_:)), for: .editingChanged)
        tblPlaces.estimatedRowHeight = 44.0
        tblPlaces.dataSource = self
        tblPlaces.delegate = self
        txtSearch.delegate = self
        
        txtSearch.placeholder = "Search places..."
        
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let camera = GMSCameraPosition.camera(withLatitude: lantitude!, longitude: longitude!, zoom: 17.0)
        mapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lantitude!, longitude: longitude!)
        marker.map = mapView
        
//        let camera = GMSCameraPosition.camera(withLatitude: modelLoc!.latitude, longitude: modelLoc!.longitude, zoom: 15.0)
//        mapView.camera = camera
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: modelLoc!.latitude, longitude: modelLoc!.longitude)
//        marker.map = mapView
        
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMyPlace"{
            if let VC = segue.destination as? myPlaceController{
                VC.placeLongitude = placeLongitude
                VC.placeLantitude = placeLantitude
            }
        }
    }
    
    //MARK:- UITableViewDataSource and UItableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if txtSearch.text!.isEmpty{
            return nameArray.count+1
        }else{
            return sortedName.count+2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier:"slelectMyPlaceCell")
            
        }else if sortedName.count != 0 && indexPath.row == sortedName.count+1{
            cell = tableView.dequeueReusableCell(withIdentifier:"addPlaceCell")
            cell?.textLabel?.text = " name place \" \(txtSearch.text!) \" "
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "placeCell")
            if txtSearch.text!.isEmpty{
                let place = nameArray[indexPath.row-1]
                cell?.textLabel?.text = place
                cell?.detailTextLabel?.isHidden = true
            }else{
                if sortedName.count > 0 && sortedDist.count > 0{
                    let place = self.sortedName[indexPath.row-1]
                    cell?.textLabel?.text = "\(place)"
                    let eachDistance = sortedDist[indexPath.row-1]
                    cell?.detailTextLabel?.isHidden = false
                    cell?.detailTextLabel?.text = "\(Int(eachDistance)) m"
                }
                //  cell?.textLabel?.text = "\(place["name"] as! String)"
                //  cell?.detailTextLabel?.text = "\(place["formatted_address"] as! String)"
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row != 0 && txtSearch.text!.isEmpty{
            savePlace = PlaceModel(placeId: placeId, placeName: nameArray[indexPath.row - 1]!, placeCategory: categoryArray[indexPath.row - 1]!, placeLongitude: modelLoc!.longitude, placeLantitude: modelLoc!.latitude, myPlace: false)
        }else if indexPath.row != 0{
            savePlace = PlaceModel(placeId: placeId, placeName: sortedName[indexPath.row - 1], placeCategory: sortedCat[indexPath.row - 1], placeLongitude: modelLoc!.longitude, placeLantitude: modelLoc!.latitude, myPlace: false)
        }
        return indexPath
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
           }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row != 0 && txtSearch.text!.isEmpty{
//            savePlace = PlaceModel(placeId: placeId, placeName: exampleArray[indexPath.row - 1]!, placeCategory: categoryArray[indexPath.row - 1]!, placeLongitude: modelLoc!.longitude, placeLantitude: modelLoc!.latitude, myPlace: false)
//            let modelPlace = PlaceModel(placeId: placeId, placeName: exampleArray[indexPath.row - 1]!, placeCategory: categoryArray[indexPath.row - 1]!, placeLongitude: modelLoc!.longitude, placeLantitude: modelLoc!.latitude, myPlace: false)
            //let placeId = DBManager.getInstance().addPlace(modelPlace)
            //self.dismiss(animated: false, completion: nil)
//            }
//   }
    
    @objc func searchPlaceFromGoogle(_ textField:UITextField) {
        
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
                                self.sortedName.removeAll()
                                self.locationDic.removeAll()
                                self.sortedDist.removeAll()
                                self.sortedCat.removeAll()
                                
                                for dct in results {
                                    self.resultsArray.append(dct)
                                    
                                    var c = [String]()
                                    c = dct["types"] as! [String]
                                    let cat = c[0]
                                    let lat = (dct["geometry"]!["location"]!! as AnyObject).allValues![0] as! Double
                                    let long = (dct["geometry"]!["location"]!! as AnyObject).allValues![1] as! Double
                                    let placeLocation = CLLocation(latitude: lat, longitude: long)
                                    self.userLocation = CLLocation(latitude: self.modelLoc!.latitude, longitude: self.modelLoc!.longitude)
                                    let dist = self.userLocation.distance(from: placeLocation)

                                    
                                    self.locationDic[dct["name"] as! String] = dist
                                    self.locationDic_c[dct["name"] as! String] = cat

                                }
                                let sortedDic = self.locationDic.sorted {$0.1 < $1.1}
                                for each in sortedDic{
                                    self.sortedName.append(each.key)
                                    self.sortedDist.append(each.value)
                                }
                                
                                for i in self.sortedName{
                                    self.sortedCat.append(self.locationDic_c[i]!)
                                }
                                
                                
                                DispatchQueue.main.async {
                                    self.tblPlaces.reloadData()
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
        
        
        //    var CLLocationDistance distance = [secondLocation distanceFromLocation:longitude];
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension mapViewController: UISearchBarDelegate, UITextFieldDelegate{
    
    //
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        self.view.endEditing(true)
    //    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



