//
//  myPlaceCategoryViewController.swift
//  test
//
//  Created by 謝宛軒 on 2020/8/12.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class myPlaceCategoryViewController: UIViewController{
    
    
    let myPlaceCategorys = ["Home","School","Work Place","Dorm","Others"]
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
extension myPlaceCategoryViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myPlaceCategory", for: indexPath)
        cell.textLabel?.text = myPlaceCategorys[indexPath.row]
        return cell
    }
    
}
