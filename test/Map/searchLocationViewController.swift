//
//  ViewController.swift
//  GooglePlaceAPI
//
//  Created by Aman Aggarwal on 15/03/18.
//  Copyright © 2018 Aman Aggarwal. All rights reserved.
//

import UIKit

class searchLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblPlaces: UITableView!
    var resultsArray:[Dictionary<String, AnyObject>] = Array()
    
    //place db variables
    var id: Int32 = 0
    var placeName: String! = ""
    var placeCategory: String! = ""
    var placeLongtitude: Double! = 0
    var placeLantitude: Double! = 0
    var myPlace: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtSearch.addTarget(self, action: #selector(searchPlaceFromGoogle(_:)), for: .editingChanged)
        tblPlaces.estimatedRowHeight = 44.0
        tblPlaces.dataSource = self
        tblPlaces.delegate = self
    }
    
    //MARK:- UITableViewDataSource and UItableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "slelectMyPlaceCell")
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "placecell")
            if resultsArray.count > 0{
                let place = self.resultsArray[indexPath.row-1]
                cell?.textLabel?.text = "\(place["name"] as! String)"
                cell?.detailTextLabel?.text = "\(place["formatted_address"] as! String)"
            }
        }
//        if let lblPlaceName = cell?.contentView.viewWithTag(102) as? UILabel {
//        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //存addPlace寫在這～～～
        
        //placeName = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.textLabel?.text
        //self.dismiss(animated: true, completion:nil)
        
//        let modelInfo = PlaceModel(placeId: id, placeName: placeName!, placeCategory: placeCategory, placeLongtitude: placeLongtitude, placeLantitude: placeLongtitude, myPlace: myPlace)
//        let isAdded = DBManager.getInstance().addPlace(modelInfo)
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

