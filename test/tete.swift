//
//  tete.swift
//  test
//
//  Created by 謝宛軒 on 2020/6/25.
//  Copyright © 2020 AppleInc. All rights reserved.
//

//import Foundation
//import UIKit
//
//class teteCell: UITableViewCell{
//    @IBOutlet var a : UILabel!
//    @IBOutlet var b : UILabel!
//    @IBOutlet var c : UILabel!
//}
//
//class tete: UIViewController{
//
//    var tete = [LocationModel]()
//
//
//    override func viewDidLoad() {
//        tete = DBManager.getInstance().tete()
//    }
//
//}
//
//extension tete: UITableViewDataSource, UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tete.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "tete", for: indexPath) as! teteCell
//        let l = self.tete[indexPath.row]
//
//        cell.a.text = "id:\(l.locationId!)，時間：\(l.startTime)"
//        cell.b.text = "經度：\(l.longitude)，緯度：\(l.latitude)，速度：\(l.speed)"
//        cell.c.text = "1:\(l.name1 ?? nil)，2:\(l.name2 ?? nil)，3:\(l.name3 ?? nil)，4:\(l.name4 ?? nil)，5:\(l.name5 ?? nil)"
//        return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
//    return indexPath
//    }
//
//
//}
