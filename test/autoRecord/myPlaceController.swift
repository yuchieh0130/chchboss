//
//  myPlaceController.swift
//  test
//
//  Created by 謝宛軒 on 2020/5/7.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class myPlaceController: UIViewController{
    
    //place db variables
    var id: Int32 = 0
    var name: String?
    var placeName: String! = "" //Only Date
    var placeCategory: String! = ""
    var placeLongitude: Double! = 0
    var placeLatitude: Double! = 0
    var myPlace: Bool! = true
    var noAdd = false
    
    var showAllPlace: [PlaceModel]?
    // var showAllPlace =  DBManager.getInstance().getAllPlace()
    var savePlace : PlaceModel?
    
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var popover: UIView!
    @IBOutlet var txtMyPlaceName: UITextField!
    @IBOutlet var btnAdd: UIButton!
    @IBAction func AddLocation(_ sender: Any) {
        self.view.addSubview(popover)
        popover.center = self.view.center
        popover.center.y = 300
        //txtField.text = txtSearch.text
        popover.layer.borderColor = UIColor.gray.cgColor
        popover.layer.borderWidth = 1
        popover.layer.cornerRadius = 20
        popover.layer.shadowOffset = CGSize(width: 5,height: 5)
        popover.layer.shadowOpacity = 0.7
        popover.layer.shadowRadius = 20
        
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.popover.removeFromSuperview()
    }
    
    @IBAction func addBtn(_ sender: Any) {
        self.view.endEditing(true)
        
        if txtMyPlaceName.text == nil || txtMyPlaceName.text == ""{
            alertMessage()
        }else {
            let modelInfo = PlaceModel(placeId: id, placeName: txtMyPlaceName.text!, placeCategory: placeCategory, placeLongitude: placeLongitude, placeLatitude: placeLongitude, myPlace: true)
            let isAdded = DBManager.getInstance().addPlace(modelInfo)
            
            txtMyPlaceName.text = nil
        }
        
        if DBManager.getInstance().getAllPlace() != nil{
            showAllPlace = DBManager.getInstance().getAllPlace()
            
        }else{
            showAllPlace = [PlaceModel]()
        }
        
        self.tblView.reloadData()
        self.popover.removeFromSuperview()
        
    }
    
    override func viewDidLoad() {
        if noAdd == true{
            btnAdd.isHidden = true
        }
        
        if DBManager.getInstance().getAllPlace() != nil{
            showAllPlace = DBManager.getInstance().getAllPlace()
            
        }else{
            showAllPlace = [PlaceModel]()
        }
    }
    
    func alertMessage(){
        if txtMyPlaceName.text == nil || txtMyPlaceName.text == ""{
            let controller = UIAlertController(title: "wrong", message: "need to enter a name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default){_ in
                controller.dismiss(animated: true, completion: nil)}
            controller.addAction(okAction)
            self.present(controller, animated: true,completion: .none)
            self.view.addSubview(popover)
        }
    }
    
}

extension myPlaceController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showAllPlace!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "myPlaceCell")
        
        let place = self.showAllPlace![indexPath.row]
        
        cell?.textLabel?.text = showAllPlace![indexPath.row].placeName
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        let place = self.showAllPlace![indexPath.row]
        savePlace = PlaceModel(placeId: place.placeId, placeName: place.placeName, placeCategory: placeCategory, placeLongitude: place.placeLongitude, placeLatitude: placeLatitude, myPlace: place.myPlace)
    return indexPath
    }
    
    
}
