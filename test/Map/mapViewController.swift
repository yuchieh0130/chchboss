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
//    @IBOutlet var popover: UIView!
//    @IBAction func AddLocation(_ sender: Any) {
//        self.view.addSubview(popover)
//        popover.center = self.view.center
//        popover.center.y = 200
//        txtField.text = txtSearch.text
//        popover.layer.borderColor = UIColor.gray.cgColor
//        popover.layer.borderWidth = 1
//        popover.layer.cornerRadius = 20
//        popover.layer.shadowOffset = CGSize(width: 5,height: 5)
//        popover.layer.shadowOpacity = 0.7
//        popover.layer.shadowRadius = 20
//
//    }
//    
    
    //place db variables
    var id: Int32 = 0
    var name: String?
    var placeName: String! = "" //Only Date
    var placeCategory: String! = ""
    var placeLongtitude: Double! = 0
    var placeLantitude: Double! = 0
    var myPlace: Bool! = false
    
    let userLocation = CLLocation(latitude: 25.034012, longitude: 121.564461)
    var locationDic : [String: Double] = [:]
    var sortedArr = [String]()
    var sortedDist = [Double]()
    
//    @IBOutlet weak var txtField: UITextField!

//    @IBAction func addToMyPlace(_ sender: UISwitch) {
//        if sender.isOn == true {
//            myPlace = true
//        }else{
//            myPlace = false
//        }
//    }
//
//    @IBAction func addBtn(_ sender: Any) {
//        self.popover.removeFromSuperview()
//
//        if name == nil || name == ""{
//            // alertMessage()
//        }else {
//
//            name = txtField.text
//
//            let modelInfo = PlaceModel(placeId: id, placeName: name!, placeCategory: placeCategory, placeLongtitude: placeLongtitude, placeLantitude: placeLongtitude, myPlace: myPlace)
//            let isAdded = DBManager.getInstance().addPlace(modelInfo)
//            // makeNotification(action: "add")
//        }
//
//    }
//
//    @IBAction func cancelBtn(_ sender: Any) {
//        self.popover.removeFromSuperview()
//    }
    
    @IBAction func cancel(_ sender: Any){
        self.dismiss(animated: false, completion: nil)
    }

    
    var resultsArray:[Dictionary<String, AnyObject>] = Array()
    let exampleArray = ["banana","apple","guava", "grape","pear"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtSearch.addTarget(self, action: #selector(searchPlaceFromGoogle(_:)), for: .editingChanged)
        tblPlaces.estimatedRowHeight = 44.0
        tblPlaces.dataSource = self
        tblPlaces.delegate = self
        
        txtSearch.placeholder = "Search places..."
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.034012, longitude: 121.564461, zoom: 15.0)
        mapView.camera = camera

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 25.034012, longitude: 121.564461)
        marker.map = mapView
               
        mapView.delegate = self
        
    }
    
    //MARK:- UITableViewDataSource and UItableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if txtSearch.text!.isEmpty{
            return exampleArray.count+1
        }else{
        return sortedArr.count+1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell?
        
        if indexPath.row == 0{ cell = tableView.dequeueReusableCell(withIdentifier:"slelectMyPlaceCell")}else{
            cell = tableView.dequeueReusableCell(withIdentifier: "placeCell")
            if txtSearch.text!.isEmpty{
                let place = exampleArray[indexPath.row-1]
                cell?.textLabel?.text = place
                cell?.detailTextLabel?.isHidden = true
            }else{
                
                if sortedArr.count > 0 && sortedDist.count > 0{
                    let place = self.sortedArr[indexPath.row-1]
                    cell?.textLabel?.text = "\(place)"
                    let eachDistance = sortedDist[indexPath.row-1]
                    cell?.detailTextLabel?.isHidden = false
                    cell?.detailTextLabel?.text = "\(Int(eachDistance)) m"
        }
        
    //            cell?.textLabel?.text = "\(place["name"] as! String)"
    //            cell?.detailTextLabel?.text = "\(place["formatted_address"] as! String)"
            }
        }

        return cell!
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

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
                            self.sortedArr.removeAll()
                            self.locationDic.removeAll()
                            self.sortedDist.removeAll()
                            
                            for dct in results {
                                self.resultsArray.append(dct)
                                var lat = (dct["geometry"]!["location"]!! as AnyObject).allValues![0] as! Double
                                var long = (dct["geometry"]!["location"]!! as AnyObject).allValues![1] as! Double
                                let placeLocation = CLLocation(latitude: lat, longitude: long)
                                let dist = self.userLocation.distance(from: placeLocation)

                                print(dct["name"]!, dist)
                                self.locationDic[dct["name"] as! String] = dist
                               
                                
                            }
                            var sortedDic = self.locationDic.sorted { $0.1 < $1.1 }
                            for each in sortedDic{
                                self.sortedArr.append(each.key)
                                self.sortedDist.append(each.value)
                            }
                            
                            print(sortedDic)
                            print(self.sortedArr)
                            print(self.sortedDist)
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
    }
}



