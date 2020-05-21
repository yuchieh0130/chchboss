//
//  editAutoRecordViewController.swift
//  test
//
//  Created by 謝宛軒 on 2020/5/21.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class editAutoRecordViewController: UIViewController{
    
    var track: TrackModel?
    var s = Date()
    var e = Date()
    var category = CategoryModel(categoryId: 9, categoryName: "default", categoryColor: "Grey", category_image: "default")
    var location : LocationModel?
    var savePlaceModel : PlaceModel?
    
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
        s = showTimeformatter.date(from: track!.startTime)!
        e = showTimeformatter.date(from: track!.endTime)!
        category = DBManager.getInstance().getCategory(Int: (track?.categoryId)!)
        location = DBManager.getInstance().getLocation(Int: (track?.locationId)!)
        savePlaceModel = DBManager.getInstance().getPlace(Int: (track?.placeId)!)
        print(track)
        print(location)
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editBtn(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
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
        cell.txtLocation.text = savePlaceModel?.placeName
        cell.selectionStyle = .none
        return cell
    default:
        let cell = tableView.dequeueReusableCell(withIdentifier: "editAutoLocationCell", for: indexPath) as! autoLocationCell
        cell.txtLocation.text = savePlaceModel?.placeName
        cell.selectionStyle = .none
        return cell
        }
    }
    
    
    
    
}
