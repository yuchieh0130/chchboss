//
//  myPlaceViewController.swift
//  test
//
//  Created by 謝宛軒 on 2020/8/12.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class myPlaceViewController: UIViewController{
//    @IBAction func cancelButton(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    //place db variables
    var id: Int32 = 0
    var name: String?
    var placeName: String! = "" //Only Date
    var placeCategory: String! = ""
    var placeLongitude: Double! = 0
    var placeLatitude: Double! = 0
    var myPlace: Bool! = true
    var noAdd = false
    var userLocation = CLLocation()
    
//    let ceo: CLGeocoder = CLGeocoder()
//    let loc: CLLocation = CLLocation(latitude: lat, longitude: lon)
    
    var showAllPlace: [PlaceModel]?
    // var showAllPlace =  DBManager.getInstance().getAllPlace()
    var savePlace : PlaceModel?
    var track: TrackModel = TrackModel(trackId: 0, startDate: "", startTime: "", weekDay: 0, endDate:"" , endTime: "", categoryId: 0, locationId: 0, placeId: nil)
    let net = NetworkController()
    
    @IBOutlet weak var tblView: UITableView!
    //@IBOutlet var popover: UIView!
    //@IBOutlet var txtMyPlaceName: UITextField!
//    @IBAction func AddLocation(_ sender: Any) {
//        self.view.addSubview(popover)
//        popover.center = self.view.center
//        popover.center.y = 300
//        //txtField.text = txtSearch.text
//        popover.layer.borderColor = UIColor.gray.cgColor
//        popover.layer.borderWidth = 1
//        popover.layer.cornerRadius = 10
//        popover.layer.shadowOffset = CGSize(width: 3,height: 3)
//        popover.layer.shadowOpacity = 0.7
//        popover.layer.shadowRadius = 10
//
//    }
//    @IBAction func cancelBtn(_ sender: Any) {
//        self.popover.removeFromSuperview()
//    }
//
//    @IBAction func addBtn(_ sender: Any) {
//        self.view.endEditing(true)
//
//        if txtMyPlaceName.text == nil || txtMyPlaceName.text == ""{
//            alertMessage()
//        }else {
//            let modelInfo = PlaceModel(placeId: id, placeName: txtMyPlaceName.text!, placeCategory: placeCategory, placeLongitude: placeLongitude, placeLatitude: placeLatitude, myPlace: true)
//            _ = DBManager.getInstance().addPlace(modelInfo)
//
//            let data:[String:String] = ["place_id":"0", "place_name":self.placeName, "place_longitude":String(self.placeLongitude), "place_latitude":String(self.placeLatitude)]
//
//            self.net.postSaveplaceData(data: data){
//                (status_code) in
//                if (status_code != nil) {
//                    print(status_code!)
//                }
//            }
//
//            txtMyPlaceName.text = nil
//        }
//
//        if DBManager.getInstance().getMyPlaces() != nil{
//            showAllPlace = DBManager.getInstance().getMyPlaces()
//
//        }else{
//            showAllPlace = [PlaceModel]()
//        }
//
//        self.tblView.reloadData()
//        self.popover.removeFromSuperview()
//
//    }
    
    @objc func addBtn(_ sender: Any){
        performSegue(withIdentifier: "addMyPlace", sender: nil)
    }
    
    override func viewDidLoad() {
        
        let addBtn = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addBtn(_:)))
        navigationItem.rightBarButtonItems = [addBtn]
        
//        if noAdd == true{
//            btnAdd.isHidden = true
//        }
//
        if DBManager.getInstance().getMyPlaces() != nil{
            showAllPlace = DBManager.getInstance().getMyPlaces()
        }else{
            showAllPlace = [PlaceModel]()
        }

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        if self.tblView.tableFooterView == nil {
//            tblView.tableFooterView = UIView(frame: CGRect.zero)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
            case"editMyPlace":
                if let VC = segue.destination as? editMyPlaceViewController{
                VC.myPlace = savePlace
                }
            default :
                print("")
        }
    }
    
    @IBAction func editMyPlaceSegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "editMyPlaceSegueBack"{
            if DBManager.getInstance().getMyPlaces() != nil{
                showAllPlace = DBManager.getInstance().getMyPlaces()
            }else{
                showAllPlace = [PlaceModel]()
            }
            tblView.reloadData()

        }
    }
    
//    func alertMessage(){
//        if txtMyPlaceName.text == nil || txtMyPlaceName.text == ""{
//            let controller = UIAlertController(title: "wrong", message: "need to enter a name", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default){_ in
//                controller.dismiss(animated: true, completion: nil)}
//            controller.addAction(okAction)
//            self.present(controller, animated: true,completion: .none)
//          self.view.addSubview(popover)
//        }
//    }
    
}

extension myPlaceViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showAllPlace!.count
    }
    


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell: UITableViewCell?
//        cell = tableView.dequeueReusableCell(withIdentifier: "myPlaceCell")
        let cellIdentifier = "myPlaceCell"

        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: cellIdentifier)
        }
        
//        var locality: String = ""
//        var subAdministrativeArea: String = ""

        let place = self.showAllPlace![indexPath.row]
//        let longitude = place.placeLongitude
//        let latitude = place.placeLatitude
//        let savedPlaceLocation = CLLocation(latitude: latitude, longitude: longitude)
//
//        userLocation = CLLocation(latitude: placeLatitude, longitude: placeLongitude)
//        let distance = lround(self.userLocation.distance(from: savedPlaceLocation))/1000
//        let locale = Locale(identifier: "zh_TW")
        
//        if #available(iOS 11.0, *) {
//            ceo.reverseGeocodeLocation(savedPlaceLocation, preferredLocale: locale) {
//                (placemarks, error) in
//                if error == nil {
//                    let pm = placemarks! as [CLPlacemark]
//                    if pm.count > 0 {
//                        subAdministrativeArea = placemarks![0].subAdministrativeArea ?? ""
//                        locality = placemarks![0].locality ?? ""
//                    }
//                    cell?.textLabel?.text = place.placeName
//                    cell?.detailTextLabel?.text = "\(distance) km \(subAdministrativeArea) \(locality) "
//                    return
//                } else {
//                    print("error")
//                }
//            }
//        }
        cell?.textLabel?.text = place.placeName
 //       cell?.detailTextLabel?.text = "\(distance) km \(subAdministrativeArea) \(locality) "
//        cell?.detailTextLabel?.isHidden = false
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        let place = self.showAllPlace![indexPath.row]
        savePlace = PlaceModel(placeId: place.placeId, placeName: place.placeName, placeCategory: placeCategory, placeLongitude: place.placeLongitude, placeLatitude: placeLatitude, myPlace: place.myPlace)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "editMyPlace",sender: nil)
    }
    
    
}
