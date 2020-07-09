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
    
    var modelLoc : LocationModel?
    lazy var nameArray = [String?]()
    lazy var categoryArray = [String?]()
    //var savePlaceArray = [PlaceModel]()
    
    var resultsArray:[Dictionary<String, AnyObject>] = Array()
    
//    var userLocation = CLLocation()
//    var locationDic : [String: Double] = [:]
//    var locationDic_c: [String: String] = [:]
    //根據距離排序完的結果
//    var sortedName = [String]()
//    var sortedDist = [Double]()
//    var sortedCat = [String]()
    
    //track紀錄的位置
    var location_id: Int32 = 0
    var longitude: Double! = 0
    var latitude: Double! = 0
    
    //搜尋結果的variables
    let id: Int32 = 0
    var placeName: String! = ""
    var placeCategory: String = "QQQQQ"
    var placeLongitude: Double! = 0
    var placeLatitude: Double! = 0
    //回傳回track用
    var savePlace : PlaceModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtSearch.addTarget(self, action: #selector(searchPlaceFromGoogle(_:)), for: .editingChanged)
        tblPlaces.estimatedRowHeight = 44.0
        tblPlaces.dataSource = self
        tblPlaces.delegate = self
        txtSearch.delegate = self
        
        txtSearch.placeholder = "Search places..."
        
        modelLoc = DBManager.getInstance().getLocation(Int: location_id)
        latitude = modelLoc?.latitude
        longitude = modelLoc?.longitude
        nameArray = [modelLoc!.name1,modelLoc!.name2!,modelLoc!.name3!,modelLoc!.name4!,modelLoc?.name5!]
        categoryArray = [modelLoc?.category1,modelLoc?.category2,modelLoc?.category3,modelLoc?.category4,modelLoc?.category5]
//        savePlaceArray = DBManager.getInstance().getNotMyPlace()!
//        savePlaceArray.filter({
//            let c = CLLocation(latitude: $0.placeLatitude, longitude: $0.placeLongitude)
//            let distance = c.distance(from: c)
//            return distance<=100
//        })
        mapView.delegate = self

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 17.0)
        mapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        marker.map = mapView
        let circle = GMSCircle(position: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), radius: 50)
        circle.strokeColor = UIColor.red
        circle.map = mapView

    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMyPlace"{
            if let VC = segue.destination as? myPlaceController{
                VC.placeLongitude = longitude
                VC.placeLatitude = latitude
            }
        }
    }
    
//    func isWithin100meters(savePlaceArray:[PlaceModel])->[PlaceModel?]{
//        //self.userLocation = CLLocation(latitude: latitude!, longitude: longitude!)
//        let savePlaceArray = DBManager.getInstance().getNotMyPlace()!
//        savePlaceArray.filter({
//            let c = CLLocation(latitude: $0.placeLatitude, longitude: $0.placeLongitude)
//            let distance = c.distance(from: c)
//            return distance<=100
//        })
//        return savePlaceArray
//    }
    
    
    //MARK:- UITableViewDataSource and UItableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if txtSearch.text!.isEmpty{
//            return nameArray.count+1
//        }else{
//            return sortedName.count+2
//            //return sortedName.count+2+savePlaceArray.count
//        }
        if txtSearch.text!.isEmpty{
            return resultsArray.count+1
        }else{
            return resultsArray.count+2
            //return sortedName.count+2+savePlaceArray.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier:"slelectMyPlaceCell")
        }else if resultsArray.count != 0 && indexPath.row == resultsArray.count+1{
            cell = tableView.dequeueReusableCell(withIdentifier:"addPlaceCell")
            cell?.textLabel?.text = " name place \" \(txtSearch.text!) \" "
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "placeCell")
            if txtSearch.text!.isEmpty{
                let place = nameArray[indexPath.row-1]
                cell?.textLabel?.text = place
                cell?.detailTextLabel?.isHidden = true
            }else{
                cell?.textLabel?.text = "\(resultsArray[indexPath.row-1]["name"]!)"
                cell?.detailTextLabel?.isHidden = false
                let distance = resultsArray[indexPath.row-1]["distance"]! as! NSNumber
                cell?.detailTextLabel?.text = "\(Int(distance))m"
            }
        }
//        }else if sortedName.count != 0 && indexPath.row == sortedName.count+1{
//            cell = tableView.dequeueReusableCell(withIdentifier:"addPlaceCell")
//            cell?.textLabel?.text = " name place \" \(txtSearch.text!) \" "
//        }else{
//            cell = tableView.dequeueReusableCell(withIdentifier: "placeCell")
//            if txtSearch.text!.isEmpty{
//                let place = nameArray[indexPath.row-1]
//                cell?.textLabel?.text = place
//                cell?.detailTextLabel?.isHidden = true
//            }else{
//                if sortedName.count > 0 && sortedDist.count > 0{
//                    let place = self.sortedName[indexPath.row-1]
//                    cell?.textLabel?.text = "\(place)"
//                    let eachDistance = sortedDist[indexPath.row-1]
//                    cell?.detailTextLabel?.isHidden = false
//                    cell?.detailTextLabel?.text = "\(Int(eachDistance)) m"
//                }
//                //  cell?.textLabel?.text = "\(place["name"] as! String)"
//                //  cell?.detailTextLabel?.text = "\(place["formatted_address"] as! String)"
//            }
//        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.row == 0{
           //選擇MyPlcae頁面
        }else if resultsArray.count != 0 && indexPath.row == resultsArray.count+1{
            //自己命名 （要自動變成myPlace嗎？？？）
            placeName = txtSearch.text!
            savePlace = PlaceModel(placeId: id, placeName: placeName!, placeCategory: placeCategory, placeLongitude: longitude, placeLatitude: latitude, myPlace: false)
        }else{
            
            if txtSearch.text!.isEmpty{
                //選擇附近五個地點
            }else{
                //選擇搜尋結果，把搜尋結果回傳plcaeModel
                var cat = [String]()
                cat = (resultsArray[indexPath.row-1]["types"] as? [String])!
                placeCategory = cat[0]
                var location = [String:[String:Any]]()
                location["location"] = resultsArray[indexPath.row-1]["geometry"]!["location"] as? [String:Any]
                placeName = resultsArray[indexPath.row-1]["name"] as? String
                placeLongitude = location["location"]!["lng"] as? Double
                placeLatitude = location["location"]!["lat"] as? Double
                savePlace = PlaceModel(placeId: id, placeName: placeName!, placeCategory: placeCategory, placeLongitude: placeLongitude, placeLatitude: placeLatitude, myPlace: false)
            }
        }
        return indexPath
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
           }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row != 0 && txtSearch.text!.isEmpty{
//            savePlace = PlaceModel(placeId: placeId, placeName: exampleArray[indexPath.row - 1]!, placeCategory: categoryArray[indexPath.row - 1]!, placeLongitude: modelLoc!.longitude, placeLatitude: modelLoc!.latitude, myPlace: false)
//            let modelPlace = PlaceModel(placeId: placeId, placeName: exampleArray[indexPath.row - 1]!, placeCategory: categoryArray[indexPath.row - 1]!, placeLongitude: modelLoc!.longitude, placeLatitude: modelLoc!.latitude, myPlace: false)
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
//                                self.sortedName.removeAll()
//                                self.locationDic.removeAll()
//                                self.sortedDist.removeAll()
//                                self.sortedCat.removeAll()
                                
                                for dct in results {
                                    self.resultsArray.append(dct)
                                    let lat = (dct["geometry"]!["location"]!! as AnyObject).allValues![0] as! Double
                                    let long = (dct["geometry"]!["location"]!! as AnyObject).allValues![1] as! Double
                                    let placeLocation = CLLocation(latitude: lat, longitude: long)
                                    let userLocation = CLLocation(latitude: self.modelLoc!.latitude, longitude: self.modelLoc!.longitude)
                                    let dist = userLocation.distance(from: placeLocation)
                                    self.resultsArray[self.resultsArray.count-1]["distance"] = dist as AnyObject
//                                    var c = [String]()
//                                    c = dct["types"] as! [String]
//                                    let cat = c[0]
//                                    let lat = (dct["geometry"]!["location"]!! as AnyObject).allValues![0] as! Double
//                                    let long = (dct["geometry"]!["location"]!! as AnyObject).allValues![1] as! Double
//                                    let placeLocation = CLLocation(latitude: lat, longitude: long)
//                                    self.userLocation = CLLocation(latitude: self.modelLoc!.latitude, longitude: self.modelLoc!.longitude)
//                                    let dist = self.userLocation.distance(from: placeLocation)
//
//
//                                    self.locationDic[dct["name"] as! String] = dist
//                                    self.locationDic_c[dct["name"] as! String] = cat

                                }
                                
                                
                                self.resultsArray = self.resultsArray.sorted{ first , second in
//                                    let f = first["geometry"]!["location"]!! as! [String : Double]
//                                    let s = second["geometry"]!["location"]!! as! [String : Double]
                                    let firstDistance = first["distance"] as! Double
                                    let secondDistance = second["distance"] as! Double
                                    return firstDistance < secondDistance
                                }
                                
//                                let sortedDic = self.locationDic.sorted {$0.1 < $1.1}
//                                for each in sortedDic{
//                                    self.sortedName.append(each.key)
//                                    self.sortedDist.append(each.value)
//                                }
//
//                                for i in self.sortedName{
//                                    self.sortedCat.append(self.locationDic_c[i]!)
//                                }
                                
                                
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



