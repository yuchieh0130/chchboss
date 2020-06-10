//
//  editAutoRecordViewController.swift
//  test
//
//  Created by 謝宛軒 on 2020/5/21.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class editAutoRecordViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate{
    
    var track: TrackModel = TrackModel(trackId: 0, date: "", startTime: "", endTime: "", categoryId: 0, locationId: 0, placeId: nil)
    var s = Date()
    var e = Date()
    var category = CategoryModel(categoryId: 9, categoryName: "default", categoryColor: "Grey", category_image: "default")
    var location : LocationModel?
    var latitude: Double?
    var longitude: Double?
    var savePlace : PlaceModel?
    
    
    @IBOutlet var txtDate: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet var tableView: UITableView!
    
    var showDateformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    var showTimeformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    var showDayformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    var showWeekdayformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd EEE"
        formatter.timeZone = TimeZone.ReferenceType.system
        return formatter
    }
    
    override func viewDidLoad() {
        s = showTimeformatter.date(from: track.startTime)!
        e = showTimeformatter.date(from: track.endTime)!
        txtDate.text = "   " + track.date
        category = DBManager.getInstance().getCategory(Int: (track.categoryId))
        location = DBManager.getInstance().getLocation(Int: (track.locationId))
        savePlace = DBManager.getInstance().getPlace(Int: (track.placeId)!)
        if savePlace != nil{
            latitude = savePlace?.placeLatitude
            longitude = savePlace?.placeLongitude
        }else{
            latitude = location?.latitude
            longitude = location?.longitude
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("db讀進來的track\(track)")
        //print("db讀進來的savePlace\(savePlace)")
        let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 17.0)
        mapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        marker.map = mapView
        
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearLocation(_ sender: UIButton){
        savePlace = nil
        tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .none)
    }
    
    @IBAction func editBtn(_ sender: UIButton){
        
        
        let newtrack = TrackModel(trackId: track.trackId!, date: ""+track.date, startTime: showTimeformatter.string(from: s), endTime: showTimeformatter.string(from: e), categoryId: category.categoryId!, locationId: 0, placeId: nil)
        DBManager.getInstance().editTrack(newtrack)
        
        if track.placeId! != 0{   //原本有資料
             
            if savePlace == nil{    //刪掉
                //吃place_id刪掉那欄
                //吃track_id把place_id的欄位改成nil（動track
                let a = DBManager.getInstance().editTrackPlace(id: track.trackId!)
            }else{  //複寫
            //吃place_id蓋掉原本savedplace裡的資料（動place
                let a = DBManager.getInstance().editPlaceData(id: track.placeId!, p: savePlace!)
            }
            
        }else{  //原本沒資料：新增新資料
            let isAdded = DBManager.getInstance().addPlace(savePlace!)
            let id = DBManager.getInstance().getMaxPlace()
            let a = DBManager.getInstance().addTrackPlace(a: id, b: track.trackId!)

        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAutoLocation"{
            if let VC = segue.destination as? mapViewController{
                VC.longitude = longitude
                VC.latitude = latitude
            }
        }
    }
    
    @IBAction func autoLocationSegueBack(segue: UIStoryboardSegue){
        let VC = segue.source as? mapViewController
        savePlace = VC?.savePlace
        tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .none)
    }
    
    @IBAction func categorySegueBack(segue: UIStoryboardSegue){
        let VC = segue.source as? categoryViewController
        let i = VC?.collectionView.indexPathsForSelectedItems
        category = (VC?.showCategory[i![0].row])!
        tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
    }
    
}


extension editAutoRecordViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath{
        case [0,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAutoStartCell", for: indexPath) as! autoStartCell
            cell.txtAutoStart.text = showTimeformatter.string(from: s)
            cell.selectionStyle = .none
            return cell
        case [0,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAutoEndCell", for: indexPath) as! autoEndCell
            cell.txtAutoEnd.text = showTimeformatter.string(from: e)
            cell.selectionStyle = .none
            return cell
        case [0,2]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAutoCategoryCell", for: indexPath) as! autoCategoryCell
            cell.txtAutoCategory.text = category.categoryName
            cell.selectionStyle = .none
            return cell
        case [0,3]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAutoLocationCell", for: indexPath) as! autoLocationCell
            cell.txtLocation.text = savePlace?.placeName
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAutoLocationCell", for: indexPath) as! autoLocationCell
            cell.txtLocation.text = savePlace?.placeName
            cell.selectionStyle = .none
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3{
            performSegue(withIdentifier: "editAutoLocation", sender: self)
        }else if indexPath.row == 2 {
            performSegue(withIdentifier: "editAutoCategory", sender: self)
        }

    }
    
    
    
    
}
