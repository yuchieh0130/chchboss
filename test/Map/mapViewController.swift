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
    
    let userLocation = CLLocation(latitude: 25.034012, longitude: 121.564461)
    var locationDic : [String: Double] = [:]
    var sortedArr = [String]()
    var sortedDist = [Double]()

    
    var resultsArray:[Dictionary<String, AnyObject>] = Array()
    let modelLoc = DBManager.getInstance().getLocation()
    lazy var exampleArray = [modelLoc?.name1,modelLoc?.name2,modelLoc?.name3,modelLoc?.name4,modelLoc?.name5]
    
    
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
        let camera = GMSCameraPosition.camera(withLatitude: 25.034012, longitude: 121.564461, zoom: 15.0)
        mapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 25.034012, longitude: 121.564461)
        marker.map = mapView
        
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK:- UITableViewDataSource and UItableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if txtSearch.text!.isEmpty{
            return exampleArray.count+1
        }else{
            return sortedArr.count+2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier:"slelectMyPlaceCell")
            
        }else if sortedArr.count != 0 && indexPath.row == sortedArr.count+1{
            cell = tableView.dequeueReusableCell(withIdentifier:"addPlaceCell")
            cell?.textLabel?.text = " name place \" \(txtSearch.text!) \" "
        }else{
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
                                    
                                    //                                print(dct["name"]!, dist)
                                    self.locationDic[dct["name"] as! String] = dist
                                    
                                }
                                var sortedDic = self.locationDic.sorted { $0.1 < $1.1 }
                                for each in sortedDic{
                                    self.sortedArr.append(each.key)
                                    self.sortedDist.append(each.value)
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



