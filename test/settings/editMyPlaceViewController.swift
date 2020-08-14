//
//  editMyPlaceViewController.swift
//  test
//
//  Created by 謝宛軒 on 2020/8/11.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class editMyPlaceViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    //@IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var tbView: UITableView!
    var myPlaceCategory = "Others"
    var myPlaceName = ""
    var id: Int32 = 0
    var myPlaceLongitude: Double! = 0
    var myPlaceLatitude: Double! = 0
    var myPlace: PlaceModel?
    
    let currentLocation = CLLocationManager()
    //var location = CLLocation()
    let marker = GMSMarker()
    let circle = GMSCircle()
    
//    var myPlace: Bool! = true
//    var noAdd = false
//    var userLocation = CLLocation()
    
    override func viewDidLoad() {
        
        let btnAdd = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addMyPlaceButton(_:)))
        let btnEdit = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(editMyPlaceButton(_:)))
        
        if myPlace != nil{
            navigationItem.rightBarButtonItems = [btnEdit]
            loadData()
        }else{
            navigationItem.rightBarButtonItems = [btnAdd]
            myPlaceLatitude = (currentLocation.location?.coordinate.latitude)!
            myPlaceLongitude = (currentLocation.location?.coordinate.longitude)!
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.location?.coordinate.latitude)!, longitude: (currentLocation.location?.coordinate.longitude)!, zoom: 17.0)
//        myPlaceLatitude = (currentLocation.location?.coordinate.latitude)!
//        myPlaceLongitude = (currentLocation.location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: myPlaceLatitude, longitude: myPlaceLongitude, zoom: 17)
        mapView.camera = camera
        mapView.animate(to: camera)
        mapView.delegate = self
        
//        marker.position = CLLocationCoordinate2D(latitude: (currentLocation.location?.coordinate.latitude)!, longitude: (currentLocation.location?.coordinate.longitude)!)
        marker.position = CLLocationCoordinate2D(latitude: myPlaceLatitude, longitude: myPlaceLongitude)
        marker.map = mapView

        circle.position = marker.position
        circle.radius = 50
        circle.strokeColor = UIColor.red
        circle.map = mapView
        
        if self.tbView.tableFooterView == nil {
            tbView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        currentLocationManager.startUpdatingLocation()
//    }
    
    func mapView(_ MapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        changePosition(marker: marker, a: coordinate)
        myPlaceLatitude = coordinate.latitude
        myPlaceLongitude = coordinate.longitude
        //location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func changePosition(marker : GMSMarker, a: CLLocationCoordinate2D){
        marker.position = CLLocationCoordinate2D(latitude: a.latitude, longitude: a.longitude)
        circle.position = marker.position
        let cam = GMSCameraPosition.camera(withLatitude: a.latitude, longitude: a.longitude, zoom: 17.0)
        mapView.camera = cam
    }
    
    func loadData(){
        id = myPlace!.placeId!
        myPlaceCategory = myPlace!.placeCategory
        myPlaceName = myPlace!.placeName
        myPlaceLongitude = myPlace!.placeLongitude
        myPlaceLatitude = myPlace!.placeLatitude
    }
    
    @IBAction func myPlaceCategorySegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "myPlaceCategorySegueBack"{
            let VC = segue.source as? myPlaceCategoryViewController
            let i = VC?.tableView.indexPathForSelectedRow?.row
            myPlaceCategory = VC?.myPlaceCategorys[i ?? 4] ?? "Others"
            tbView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .none)
        }
    }
    
    @objc func addMyPlaceButton(_ sender: UIButton){
        self.view.endEditing(true)
        if myPlaceName == ""{
            alertMessage()
        }else{
            let modelInfo = PlaceModel(placeId: id, placeName: myPlaceName, placeCategory: myPlaceCategory, placeLongitude: myPlaceLongitude, placeLatitude: myPlaceLatitude, myPlace: true)
            _ = DBManager.getInstance().addPlace(modelInfo)
            self.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "editMyPlaceSegueBack", sender: self)
        }
    }
    
    @objc func editMyPlaceButton(_ sender: UIButton){
        self.view.endEditing(true)
        if myPlaceName == ""{
            alertMessage()
        }
        let modelInfo = PlaceModel(placeId: id, placeName: myPlaceName, placeCategory: myPlaceCategory, placeLongitude: myPlaceLongitude, placeLatitude: myPlaceLatitude, myPlace: true)
        DBManager.getInstance().editPlace(modelInfo)
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "editMyPlaceSegueBack", sender: self)
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func alertMessage(){
            let controller = UIAlertController(title: "wrong", message: "need to enter a name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default){_ in
                controller.dismiss(animated: true, completion: nil)}
            controller.addAction(okAction)
            self.present(controller, animated: true,completion: .none)
    }
    
}

extension editMyPlaceViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier:"myPlaceName",for: indexPath) as! editMyplaceNameCell
            cell.txtName.text = myPlaceName
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"myPlaceCategory") as! editMyplaceCategoryCell
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.category.text = myPlaceCategory
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 1{
            performSegue(withIdentifier: "myPlaceCategory", sender: nil)
        }
    }

}

extension editMyPlaceViewController: UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        myPlaceName = textField.text!
    }
}
