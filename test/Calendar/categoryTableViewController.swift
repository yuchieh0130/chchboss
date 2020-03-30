//
//  categoryTableViewController.swift
//  test
//
//  Created by 王義甫 on 2020/3/25.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class categoryTableViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DBManager.getInstance().getCategory() != nil{
            showCategory = DBManager.getInstance().getCategory()
        }else{
            showCategory = [CategoryModel]()
        }
        tableView.reloadData()
    }
     var showCategory = [CategoryModel]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showCategory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell: categoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell", for: indexPath)as! categoryTableViewCell
        cell.categoryName?.text = showCategory[indexPath.row].categoryName
        //set color
        return cell
    }
}
