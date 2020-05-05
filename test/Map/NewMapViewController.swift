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

class NewMapViewController: UIViewController, UITableViewDataSource,CLLocationManagerDelegate, UITableViewDelegate {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblPlaces: UITableView!
    @IBOutlet var popover: UIView!
    @IBAction func AddLocation(_ sender: Any) {
        self.view.addSubview(popover)
        popover.center = self.view.center
        popover.center.y = 200
        txtField.text = txtSearch.text
        popover.layer.borderColor = UIColor.gray.cgColor
        popover.layer.borderWidth = 1
        popover.layer.cornerRadius = 20
        popover.layer.shadowOffset = CGSize(width: 5,height: 5)
        popover.layer.shadowOpacity = 0.7
        popover.layer.shadowRadius = 20

    }
    
    @IBOutlet weak var txtField: UITextField!
    
    @IBAction func CancelBtn(_ sender: Any) {
        self.popover.removeFromSuperview()
    }
    @IBAction func ComfirmBtn(_ sender: Any) {
        self.popover.removeFromSuperview()
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
    }
    
    //MARK:- UITableViewDataSource and UItableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if txtSearch.text!.isEmpty{
            return exampleArray.count
        }else{
        return resultsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "placecell")
        
        if txtSearch.text!.isEmpty{
            let place = exampleArray[indexPath.row]
            cell?.textLabel?.text = place
            cell?.detailTextLabel?.isHidden = true
        }else{

        if resultsArray.count>=0{
        let place = self.resultsArray[indexPath.row]
            cell?.textLabel?.text = "\(place["name"] as! String)"
            cell?.detailTextLabel?.isHidden = false
            cell?.detailTextLabel?.text = "\(place["formatted_address"] as! String)"
        }
        }

        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//        return UITableViewAutomaticDimension
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}


