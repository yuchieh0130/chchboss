//
//  ViewController.swift
//  GooglePlaceAPI
//
//  Created by Aman Aggarwal on 15/03/18.
//  Copyright © 2018 Aman Aggarwal. All rights reserved.
//

import UIKit

class searchLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,UISearchBarDelegate{
    
    
    //@IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tblPlaces: UITableView!
    var resultsArray:[Dictionary<String, AnyObject>] = Array()
    
    //place db variables
    var id: Int32 = 0
    var placeName: String! = ""
    var placeCategory: String! = ""
    var placeLongitude: Double! = 0
    var placeLatitude: Double! = 0
    var myPlace: Bool! = false
    
    var savePlaceModel:PlaceModel? //傳回addEvent用的
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        txtSearch.addTarget(self, action: #selector(searchPlaceFromGoogle(_:)), for: .editingChanged)
        tblPlaces.estimatedRowHeight = 44.0
        tblPlaces.dataSource = self
        tblPlaces.delegate = self
        
        self.txtSearch.placeholder = "search place"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "onlyShowMyPlace"{
            if let VC = segue.destination as? showMyPlaceController{
                VC.noAdd = true
            }
            
        }
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- UITableViewDataSource and UItableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "selectMyPlaceCell")
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "placecell")
            //            if resultsArray.count > 0{
            let place = self.resultsArray[indexPath.row - 1]
            cell?.textLabel?.text = "\(place["name"] as! String)"
            cell?.detailTextLabel?.text = "\(place["formatted_address"] as! String)"
            //            }
        }
        //        if let lblPlaceName = cell?.contentView.viewWithTag(102) as? UILabel {
        //        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row != 0{
            var cat = [String]()
            cat = (resultsArray[indexPath.row-1]["types"] as? [String])!
            placeCategory = cat[0]
            var location = [String:[String:Any]]()
            location["location"] = resultsArray[indexPath.row-1]["geometry"]!["location"] as? [String:Any]
            placeName = resultsArray[indexPath.row-1]["name"] as? String
            //placeCategory = resultsArray[indexPath.row-1]["types"]![0] as? String
            placeLongitude = location["location"]!["lng"] as? Double
            placeLatitude = location["location"]!["lat"] as? Double
            savePlaceModel = PlaceModel(placeId: id, placeName: placeName!, placeCategory: placeCategory, placeLongitude: placeLongitude, placeLatitude: placeLatitude, regionRadius: 0, myPlace: false)
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at: indexPath, animated: true)
    //        let place = self.resultsArray[indexPath.row]
    //        if let locationGeometry = place["geometry"] as? Dictionary<String, AnyObject> {
    //            if let location = locationGeometry["location"] as? Dictionary<String, AnyObject> {
    //                if let latitude = location["lat"] as? Double {
    //                    if let longitude = location["lng"] as? Double {
    //                        UIApplication.shared.open(URL(string: "https://wwwwwww.google.com/maps/@\(latitude),\(longitude),16z")!, options: [:])
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    
    
    @objc func searchPlaceFromGoogle(_ textField: UISearchBar) {
        
        if let searchQuery = textField.text {
            var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(searchQuery)&key= AIzaSyBTAFGciHct-17-WxKEBZCebj0-6gwMDRY"
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
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        searchPlaceFromGoogle(txtSearch)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

