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
import SnapKit

class editAutoRecordViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate{
    
    var track: TrackModel?
    var oldTrack = TrackModel(trackId: 0, startDate: "", startTime: "", weekDay: 0, endDate:"" , endTime: "", categoryId: 0, locationId: 0, placeId: 0)
    var newTrack = TrackModel(trackId: 0, startDate: "", startTime: "", weekDay: 0, endDate:"" , endTime: "", categoryId: 0, locationId: 0, placeId: 0)
    var s = Date()
    var e = Date()
    var category = CategoryModel(categoryId: 9, categoryName: "default", categoryColor: "Grey", category_image: "default")
    var location : LocationModel?
    var latitude: Double?
    var longitude: Double?
    var savePlace : PlaceModel?
    
    var tag: String? //which? (startDate,EndDate,editTask)
    var date = Date() //date from DatePopViewController
    //    let net = NetworkController()
    
    @IBOutlet var txtDate: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var gifImgView: UIImageView!
    
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
    
    let timeContainerView: UIView = {
        let tmpView = UIView()
        return tmpView
    }()
    
    let btnFontColor: UIColor = UIColor(red: 77/255, green: 38/255, blue: 0/255, alpha: 1)
    
    let arrowLabel: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.text = "  〉"
        tmpLabel.font = tmpLabel.font.withSize(40.0)
        tmpLabel.textColor = UIColor(red: 77/255, green: 38/255, blue: 0/255, alpha: 1)
        return tmpLabel
    }()
    
    let startTimeBtn: UIButton = {
        let tmpBtn = UIButton()
        tmpBtn.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 128/255, alpha: 0.7)
        tmpBtn.layer.cornerRadius = 10
        tmpBtn.setTitle("00:00", for: .normal)
        tmpBtn.titleLabel?.textAlignment = .center
        tmpBtn.setTitleColor(UIColor(red: 77/255, green: 38/255, blue: 0/255, alpha: 1), for: .normal)
        tmpBtn.addTarget(self, action: #selector(pressedStartTimeBtn), for: .touchUpInside)
        return tmpBtn
    }()
    
    let endTimeBtn: UIButton = {
        let tmpBtn = UIButton()
        tmpBtn.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 128/255, alpha: 0.7)
        tmpBtn.layer.cornerRadius = 10
        tmpBtn.setTitle("00:00", for: .normal)
        tmpBtn.titleLabel?.textAlignment = .center
        tmpBtn.setTitleColor(UIColor(red: 77/255, green: 38/255, blue: 0/255, alpha: 1), for: .normal)
        tmpBtn.addTarget(self, action: #selector(pressedEndTimeBtn), for: .touchUpInside)
        return tmpBtn
    }()
    
    let categoryBtn: UIButton = {
        let tmpBtn = UIButton()
        tmpBtn.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 128/255, alpha: 0.7)
        tmpBtn.layer.cornerRadius = 10
        tmpBtn.setTitle("Category     Shopping", for: .normal)
        tmpBtn.titleLabel?.textAlignment = .center
        tmpBtn.setTitleColor(UIColor(red: 77/255, green: 38/255, blue: 0/255, alpha: 1), for: .normal)
        tmpBtn.addTarget(self, action: #selector(pressedCategoryBtn), for: .touchUpInside)
        return tmpBtn
    }()
    
    let locationBtn: UIButton = {
        let tmpBtn = UIButton()
        tmpBtn.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 128/255, alpha: 0.7)
        tmpBtn.layer.cornerRadius = 10
        tmpBtn.setTitle("Location     Dorm", for: .normal)
        tmpBtn.titleLabel?.textAlignment = .center
        tmpBtn.setTitleColor(UIColor(red: 77/255, green: 38/255, blue: 0/255, alpha: 1), for: .normal)
        tmpBtn.addTarget(self, action: #selector(pressedLocationBtn), for: .touchUpInside)
        return tmpBtn
    }()
    
    @objc func pressedStartTimeBtn(sender: UIButton!) {
        performSegue(withIdentifier: "editAutoStart", sender: self)
    }
    @objc func pressedEndTimeBtn(sender: UIButton!) {
        performSegue(withIdentifier: "editAutoEnd", sender: self)
    }
    @objc func pressedCategoryBtn(sender: UIButton!) {
        performSegue(withIdentifier: "editAutoCategory", sender: self)
    }
    @objc func pressedLocationBtn(sender: UIButton!) {
        performSegue(withIdentifier: "editAutoLocation", sender: self)
    }
    
    override func viewDidLoad() {
        
        setUpBtns()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let btnOK = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(editBtn(_:)))
        let btnDelete = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteBtn(_:)))
        navigationItem.rightBarButtonItems = [btnOK, btnDelete]
        
        oldTrack = track!
        s = showDateformatter.date(from: "\(track!.startDate) \(track!.startTime)")!
        e = showDateformatter.date(from: "\(track!.endDate) \(track!.endTime)")!
        category = DBManager.getInstance().getCategory(Int: (track!.categoryId))
        location = DBManager.getInstance().getLocation(Int: (track!.locationId))
        savePlace = DBManager.getInstance().getPlace(Int: (track!.placeId)!)
        if savePlace != nil{
            latitude = savePlace?.placeLatitude
            longitude = savePlace?.placeLongitude
        }else{
            latitude = location?.latitude
            longitude = location?.longitude
        }
        
        let animatedImage = UIImage.animatedImageNamed("\(category.categoryName)-", duration: 1)
        gifImgView.image = animatedImage
        
    }
    
    //   override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tag = nil
        switch segue.identifier {
        case "editAutoStart":
            if let VC = segue.destination as? DatePopupViewController{
                VC.tag = "editAutoStart"
                VC.showDate = s
            }
        case "editAutoEnd":
            if let VC = segue.destination as? DatePopupViewController{
                VC.tag = "editAutoEnd"
                VC.showDate = e
            }
        case "editAutoLocation":
            if let VC = segue.destination as? mapViewController{
                if savePlace != nil{
                    VC.savePlace = savePlace
                }else{
                    VC.location_id = track!.locationId
                }
            }
        default:
            print("")
        }
        
    }
    
    func setUpBtns() {
        view.addSubview(timeContainerView)
        timeContainerView.addSubview(startTimeBtn)
        timeContainerView.addSubview(endTimeBtn)
        timeContainerView.addSubview(arrowLabel)
        view.addSubview(categoryBtn)
        view.addSubview(locationBtn)
        
        
        timeContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(gifImgView.snp.bottom).offset(50)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.bottom.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }
        arrowLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        startTimeBtn.snp.makeConstraints { (make) in
            make.top.leading.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(120)
        }
        
        endTimeBtn.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.trailing.lessThanOrEqualToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(120)
        }
        
        categoryBtn.snp.makeConstraints { (make) in
            make.top.equalTo(timeContainerView.snp.bottom).offset(50)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.height.equalTo(50)
        }
        locationBtn.snp.makeConstraints { (make) in
            make.top.equalTo(categoryBtn.snp.bottom).offset(30)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.height.equalTo(50)
        }
        
        
    }
    
    func handletime(){
        let interval = e.timeIntervalSince(s)
        if tag == "editAutoStart"{
            s = date
            if dayConstraint(i: "start") == 1 { e = s + interval}
        }else if tag == "editAutoEnd"{
            e = date
            if dayConstraint(i: "end") == 1 { s = e - interval}
        }
    }
    
    func dayConstraint(i:String) -> Int{
        let c1 = s.compare(e)
        let c2 = e.compare(s)
        var c = 0
        switch i {
        case "start":
            if c1 == .orderedDescending {c = 1}
        case "end":
            if c2 == .orderedAscending {c = 1}
        default:
            c = 0
        }
        return c
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    @IBAction func clearLocation(_ sender: UIButton){
        savePlace = nil
        tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .none)
    }
    
    @objc func editBtn(_ sender: UIButton){
        //        newTrack = TrackModel(trackId: track.trackId!, startDate: showDayformatter.string(from: s), startTime: showTimeformatter.string(from: s), weekDay: Int32(Calendar.current.component(.weekday, from: s)),endDate: showDayformatter.string(from: e), endTime: showTimeformatter.string(from: e), categoryId: category.categoryId!, locationId: 0, placeId: nil)
        
        if track!.placeId! != 0{   //原本有資料
            
            if savePlace == nil{//刪掉
                //吃place_id刪掉那欄(不用)
                //吃track_id把place_id的欄位改成nil（動track
                //let a = DBManager.getInstance().deleteTrackPlace(id: track.trackId!)
                newTrack = TrackModel(trackId: track!.trackId!, startDate: showDayformatter.string(from: s), startTime: showTimeformatter.string(from: s), weekDay: Int32(Calendar.current.component(.weekday, from: s)),endDate: showDayformatter.string(from: e), endTime: showTimeformatter.string(from: e), categoryId: category.categoryId!, locationId: track!.locationId , placeId: 0)
            }else{  //複寫
                //savePlace檢查要不要新增新的
                //要：新增完回傳id 寫進track
                //不要：回傳已經存在的savePlacce id寫進track
                let id = DBManager.getInstance().addPlace(savePlace!)
                //                if isAdded{
                //                    let id = DBManager.getInstance().getMaxPlace()
                //                }else{
                //                }
                //let a = DBManager.getInstance().editTrackPlace(a: id, b: track.trackId!)
                newTrack = TrackModel(trackId: track!.trackId!, startDate: showDayformatter.string(from: s), startTime: showTimeformatter.string(from: s), weekDay: Int32(Calendar.current.component(.weekday, from: s)),endDate: showDayformatter.string(from: e), endTime: showTimeformatter.string(from: e), categoryId: category.categoryId!, locationId: track!.locationId , placeId: id)
            }
            
        }else if savePlace != nil {  //原本沒資料：新增新資料
            //if savePlace?.myPlace == false{
            if savePlace?.placeId == 0{
                let id = DBManager.getInstance().addPlace(savePlace!)
                
                newTrack = TrackModel(trackId: track!.trackId!, startDate: showDayformatter.string(from: s), startTime: showTimeformatter.string(from: s), weekDay: Int32(Calendar.current.component(.weekday, from: s)),endDate: showDayformatter.string(from: e), endTime: showTimeformatter.string(from: e), categoryId: category.categoryId!, locationId: 0, placeId: id)
            }else{
                newTrack = TrackModel(trackId: track!.trackId!, startDate: showDayformatter.string(from: s), startTime: showTimeformatter.string(from: s), weekDay: Int32(Calendar.current.component(.weekday, from: s)),endDate: showDayformatter.string(from: e), endTime: showTimeformatter.string(from: e), categoryId: category.categoryId!, locationId: track!.locationId , placeId: savePlace?.placeId!)
                
            }
            //let id = DBManager.getInstance().getMaxPlace()
            //let a = DBManager.getInstance().editTrackPlace(a: id, b: track.trackId!)
            
            //                let data:[String:String] = ["place_id":"0", "place_name":savePlace!.placeName, "place_longitude":String(savePlace!.placeLongitude), "place_latitude":String(savePlace!.placeLatitude)]
            //
            //                self.net.postSaveplaceData(data: data){
            //                    (status_code) in
            //                    if (status_code != nil) {
            //                        print(status_code!)
            //                    }
            //                }
            
            //}else{
            //let a = DBManager.getInstance().editTrackPlace(a: (savePlace?.placeId)!, b: track.trackId!)
            //}
            
        }else{
            newTrack = TrackModel(trackId: track!.trackId!, startDate: showDayformatter.string(from: s), startTime: showTimeformatter.string(from: s), weekDay: Int32(Calendar.current.component(.weekday, from: s)),endDate: showDayformatter.string(from: e), endTime: showTimeformatter.string(from: e), categoryId: category.categoryId!, locationId: track!.locationId , placeId: 0)
            
        }
        
        DBManager.getInstance().editTrack(oldModelInfo: oldTrack,newModelInfo: newTrack)
        performSegue(withIdentifier: "editAutoSegueBack", sender: self)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteBtn(_ sender: UIButton){
        let controller = UIAlertController(title: "WARNING", message: "Are you sure to delete the event", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){_ in
            controller.dismiss(animated: true, completion: nil);
            self.dismiss(animated: true, completion: nil);
            DBManager.getInstance().deleteTrack(Int: self.track!.trackId!)
            self.performSegue(withIdentifier: "editAutoSegueBack", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){_ in controller.dismiss(animated: true, completion: nil)}
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        self.present(controller, animated: true,completion: .none)
    }
    
    @IBAction func TimeSegueBack(segue: UIStoryboardSegue){
        let VC = segue.source as? DatePopupViewController
        date = VC!.datePicker.date
        tag = VC?.tag
        
        if tag == "editAutoStart"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
            tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .none)
        }else if tag == "editAutoEnd"{
            handletime()
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
            tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .none)
        }
    }
    
    @IBAction func autoLocationSegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "autoLocationSegueBack"{
            let VC = segue.source as? mapViewController
            savePlace = VC?.savePlace
            tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .none)
        }
    }
    
    @IBAction func myPlaceSegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "myPlaceSegueBack"{
            let VC = segue.source as? showMyPlaceController
            savePlace = VC?.savePlace
            tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .none)
        }
    }
    
    @IBAction func categorySegueBack(segue: UIStoryboardSegue){
        if segue.identifier == "categorySegueBack"{
            let VC = segue.source as? categoryViewController
            let i = VC?.collectionView.indexPathsForSelectedItems
            category = (VC?.showCategory[i![0].row])!
            tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
        }
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
            cell.txtAutoStart.text = showDateformatter.string(from: s)
            cell.selectionStyle = .none
            return cell
        case [0,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAutoEndCell", for: indexPath) as! autoEndCell
            cell.txtAutoEnd.text = showDateformatter.string(from: e)
            cell.selectionStyle = .none
            return cell
        case [0,2]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAutoCategoryCell", for: indexPath) as! autoCategoryCell
            cell.txtAutoCategory.text = category.categoryName
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        case [0,3]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAutoLocationCell", for: indexPath) as! autoLocationCell
            cell.txtLocation.text = savePlace?.placeName
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
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
            print("aaaaa")
        }else if indexPath.row == 2 {
            performSegue(withIdentifier: "editAutoCategory", sender: self)
        }else if indexPath.row == 1 {
            performSegue(withIdentifier: "editAutoEnd", sender: self)
        }else if indexPath.row == 0 {
            performSegue(withIdentifier: "editAutoStart", sender: self)
        }
        
    }
    
    
    
    
}
