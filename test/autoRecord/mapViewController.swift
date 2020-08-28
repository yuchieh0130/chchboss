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
    //@IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tblPlaces: UITableView!
    
    var modelLoc : LocationModel?
    lazy var nameArray = [String?]()
    lazy var categoryArray = [String?]()
    var savePlaceArray = [PlaceModel]()
    
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
    var userLocation = CLLocation()
    
    //搜尋結果的variables
    let id: Int32 = 0
    var placeName: String! = ""
    var placeCategory: String = "QQQQQ"
    var placeLongitude: Double! = 0
    var placeLatitude: Double! = 0
    //判斷原本有沒有選過place跟回傳回track用
    var savePlace : PlaceModel?
    
    let marker = GMSMarker()
    let circle = GMSCircle()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tblView.translatesAutoresizingMaskIntoConstraints = false
        //mapView.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view, typically from a nib.
//        txtSearch.addTarget(self, action: #selector(searchPlaceFromGoogle(_:)), for: .editingChanged)
        tblPlaces.estimatedRowHeight = 44.0
        tblPlaces.dataSource = self
        tblPlaces.delegate = self
        //txtSearch.delegate = self
        self.txtSearch.placeholder = "Search places..."
        
        savePlaceArray = DBManager.getInstance().getNotMyPlaces()
        
        if savePlace != nil{
            latitude = savePlace?.placeLatitude
            longitude = savePlace?.placeLongitude
            userLocation = CLLocation(latitude: latitude!, longitude: longitude!)
            
            savePlaceArray = savePlaceArray.filter({
                let c = CLLocation(latitude: $0.placeLatitude, longitude: $0.placeLongitude)
                let distance = c.distance(from: userLocation)
                let name = $0.placeName.elementsEqual(savePlace!.placeName)
                return distance <= 250 && name == false
            })
            
        }else{
            modelLoc = DBManager.getInstance().getLocation(Int: location_id)
            latitude = modelLoc?.latitude
            longitude = modelLoc?.longitude
            userLocation = CLLocation(latitude: latitude!, longitude: longitude!)
            nameArray = [modelLoc!.name1,modelLoc!.name2!,modelLoc!.name3!,modelLoc!.name4!,modelLoc?.name5!]
            //            categoryArray = [modelLoc?.category1,modelLoc?.category2,modelLoc?.category3,modelLoc?.category4,modelLoc?.category5]
            savePlaceArray = savePlaceArray.filter({
                let c = CLLocation(latitude: $0.placeLatitude, longitude: $0.placeLongitude)
                let distance = c.distance(from: userLocation)
                return distance <= 250
            })
            if savePlaceArray.count != 0{
                for i in 0...savePlaceArray.count-1{
                    nameArray.filter({
                        let name = savePlaceArray[i].placeName == $0
                        return name == false
                    })
                }
            }
        }
        
        mapView.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 17.0)
        //        let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 17.0)
        mapView.camera = camera
        mapView.animate(to: camera)
        
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        mapView.delegate = self
        marker.map = mapView
        
        circle.position = marker.position
        circle.radius = 50
        circle.strokeColor = UIColor.red
        circle.map = mapView
        
        if self.tblPlaces.tableFooterView == nil {
            tblPlaces.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
//    func mapView(_ MapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
//        print("lat = " + "\(coordinate.latitude)" + " long = " +  "\(coordinate.longitude)")
//        changePosition(marker: marker, a: coordinate)
//    }
//    
//    func changePosition(marker : GMSMarker, a: CLLocationCoordinate2D){
//        marker.position = CLLocationCoordinate2D(latitude: a.latitude, longitude: a.longitude)
//        circle.position = marker.position
//        let cam = GMSCameraPosition.camera(withLatitude: a.latitude, longitude: a.longitude, zoom: 17.0)
//        mapView.camera = cam
//    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMyPlace"{
            if let VC = segue.destination as? showMyPlaceController{
                VC.placeLongitude = longitude
                VC.placeLatitude = latitude
            }
        }
    }
    
    
    //MARK:- UITableViewDataSource and UItableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if txtSearch.text!.isEmpty{
            return nameArray.count+savePlaceArray.count+1
        }else{
            return resultsArray.count+1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //var cell: UITableViewCell?
        
        if txtSearch.text!.isEmpty{
            
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier:"slelectMyPlaceCell")
                return cell!
            }else if indexPath.row <= nameArray.count{
                let cell = tableView.dequeueReusableCell(withIdentifier: "fivePlaceCell")
                let place = nameArray[indexPath.row-1]
                cell?.textLabel?.text = place
                cell?.detailTextLabel?.text = "(recommend place)"
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell")
                let place = savePlaceArray[indexPath.row-nameArray.count-1].placeName
                cell?.textLabel?.text = place
                cell?.detailTextLabel?.isHidden = false
                let c = CLLocation(latitude: savePlaceArray[indexPath.row-nameArray.count-1].placeLatitude, longitude: savePlaceArray[indexPath.row-nameArray.count-1].placeLongitude)
                let distance = c.distance(from: userLocation) as NSNumber
                if Double(truncating: distance) >= 1000{
                    cell?.detailTextLabel?.text = "\((Double(truncating: distance)/1000).rounding(toDecimal: 1)) km"
                }else{
                    cell?.detailTextLabel?.text = "\(Int(truncating: distance)) m"
                }
                return cell!
            }
        }else{
            if indexPath.row < resultsArray.count{
                let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as! placeCell
                //cell.textLabel?.text = "\(resultsArray[indexPath.row]["name"]!)"
                cell.placeName.text = "\(resultsArray[indexPath.row]["name"]!)"
                cell.address.text = "\(resultsArray[indexPath.row]["formatted_address"] as! String)"
                //cell.detailTextLabel?.isHidden = false
                let distance = resultsArray[indexPath.row]["distance"]! as! NSNumber
                if Double(truncating: distance) >= 1000{
                    cell.distance.text = "\((Double(truncating: distance)/1000).rounding(toDecimal: 1)) km"
                }else{
                    cell.distance.text = "\(Int(truncating: distance)) m"
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier:"addPlaceCell")
                cell?.textLabel?.text = " name this place： \" \(txtSearch.text!) \" "
                return cell!
            }
            
        }
        
//        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        
        
        if txtSearch.text!.isEmpty{
            
            if indexPath.row == 0{
                //選擇MyPlcae頁面
            }else if indexPath.row <= nameArray.count{
                txtSearch.text = nameArray[indexPath.row-1]
                searchPlaceFromGoogle(txtSearch)
            }else{
                savePlace = PlaceModel(placeId: savePlaceArray[indexPath.row-nameArray.count-1].placeId, placeName: savePlaceArray[indexPath.row-nameArray.count-1].placeName, placeCategory: savePlaceArray[indexPath.row-nameArray.count-1].placeCategory, placeLongitude: savePlaceArray[indexPath.row-nameArray.count-1].placeLongitude, placeLatitude: savePlaceArray[indexPath.row-nameArray.count-1].placeLatitude, myPlace: false)
            }
        }else{
            if indexPath.row < resultsArray.count{
                var cat = [String]()
                cat = (resultsArray[indexPath.row]["types"] as? [String])!
                placeCategory = cat[0]
                var location = [String:[String:Any]]()
                location["location"] = resultsArray[indexPath.row]["geometry"]!["location"] as? [String:Any]
                placeName = resultsArray[indexPath.row]["name"] as? String
                placeLongitude = location["location"]!["lng"] as? Double
                placeLatitude = location["location"]!["lat"] as? Double
                savePlace = PlaceModel(placeId: id, placeName: placeName!, placeCategory: placeCategory, placeLongitude: placeLongitude, placeLatitude: placeLatitude, myPlace: false)
            }else{
                savePlace = PlaceModel(placeId: id, placeName: txtSearch.text!, placeCategory: placeCategory, placeLongitude: longitude, placeLatitude: latitude, myPlace: false)
            }
            
        }
        
        //        if indexPath.row == 0{
        //           //選擇MyPlcae頁面
        //        }else if resultsArray.count != 0 && indexPath.row == resultsArray.count+1{
        //            //自己命名 （要自動變成myPlace嗎？？？）
        //            placeName = txtSearch.text!
        //            savePlace = PlaceModel(placeId: id, placeName: placeName!, placeCategory: placeCategory, placeLongitude: longitude, placeLatitude: latitude, myPlace: false)
        //        }else{
        //
        //            if txtSearch.text!.isEmpty{
        //                if indexPath.row <= nameArray.count{
        //                    txtSearch.text = nameArray[indexPath.row-1]
        //                    searchPlaceFromGoogle(txtSearch)
        //
        //                }else{
        //                    savePlace = PlaceModel(placeId: id, placeName: savePlaceArray[indexPath.row-nameArray.count-1].placeName, placeCategory: savePlaceArray[indexPath.row-nameArray.count-1].placeCategory, placeLongitude: savePlaceArray[indexPath.row-nameArray.count-1].placeLongitude, placeLatitude: savePlaceArray[indexPath.row-nameArray.count-1].placeLatitude, myPlace: false)
        //                }
        //
        //
        //                //self.tblPlaces.reloadData()
        //                //選擇附近五個地點or savePlace
        //            }else{
        //                //選擇搜尋結果，把搜尋結果回傳plcaeModel
        //                var cat = [String]()
        //                cat = (resultsArray[indexPath.row-1]["types"] as? [String])!
        //                placeCategory = cat[0]
        //                var location = [String:[String:Any]]()
        //                location["location"] = resultsArray[indexPath.row-1]["geometry"]!["location"] as? [String:Any]
        //                placeName = resultsArray[indexPath.row-1]["name"] as? String
        //                placeLongitude = location["location"]!["lng"] as? Double
        //                placeLatitude = location["location"]!["lat"] as? Double
        //                savePlace = PlaceModel(placeId: id, placeName: placeName!, placeCategory: placeCategory, placeLongitude: placeLongitude, placeLatitude: placeLatitude, myPlace: false)
        //            }
        //        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "showMyPlace", sender: nil)
        }
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        if indexPath.row != 0 && txtSearch.text!.isEmpty{
    //            savePlace = PlaceModel(placeId: placeId, placeName: exampleArray[indexPath.row - 1]!, placeCategory: categoryArray[indexPath.row - 1]!, placeLongitude: modelLoc!.longitude, placeLatitude: modelLoc!.latitude, myPlace: false)
    //            let modelPlace = PlaceModel(placeId: placeId, placeName: exampleArray[indexPath.row - 1]!, placeCategory: categoryArray[indexPath.row - 1]!, placeLongitude: modelLoc!.longitude, placeLatitude: modelLoc!.latitude, myPlace: false)
    //let placeId = DBManager.getInstance().addPlace(modelPlace)
    //self.dismiss(animated: false, completion: nil)
    //            }
    //   }
    
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
                                //                                self.sortedName.removeAll()
                                //                                self.locationDic.removeAll()
                                //                                self.sortedDist.removeAll()
                                //                                self.sortedCat.removeAll()
                                
                                for dct in results {
                                    self.resultsArray.append(dct)
                                    let lat = (dct["geometry"]!["location"]!! as AnyObject).allValues![0] as! Double
                                    let long = (dct["geometry"]!["location"]!! as AnyObject).allValues![1] as! Double
                                    let placeLocation = CLLocation(latitude: lat, longitude: long)
                                    //                                    let userLocation = CLLocation(latitude: self.modelLoc!.latitude, longitude: self.modelLoc!.longitude)
                                    let dist = self.userLocation.distance(from: placeLocation)
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        searchPlaceFromGoogle(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    //
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        self.view.endEditing(true)
    //    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension Double {
    func rounding(toDecimal decimal: Int) -> Double {
        let numberOfDigits = pow(10.0, Double(decimal))
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
    }
}



