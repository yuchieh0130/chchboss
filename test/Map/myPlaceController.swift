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
    var placeLongtitude: Double! = 0
    var placeLantitude: Double! = 0
    var myPlace: Bool! = true
    var noAdd = false
    

    var showAllPlace =  DBManager.getInstance().getAllPlace()
    
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
        self.popover.removeFromSuperview()
        
        if txtMyPlaceName.text == nil || txtMyPlaceName.text == ""{
            alertMessage()
        }else {
            
            let modelInfo = PlaceModel(placeId: id, placeName: txtMyPlaceName.text!, placeCategory: placeCategory, placeLongtitude: placeLongtitude, placeLantitude: placeLongtitude, myPlace: myPlace)
            let isAdded = DBManager.getInstance().addPlace(modelInfo)
        }
    }
    
    override func viewDidLoad() {
        if noAdd == true{
            btnAdd.isHidden = true
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
        cell = tableView.dequeueReusableCell(withIdentifier: "myplacecell")
        
        let place = self.showAllPlace![indexPath.row]
        
        cell?.textLabel?.text = showAllPlace![indexPath.row].placeName
        
        
        return cell!
    }
    
    
}
