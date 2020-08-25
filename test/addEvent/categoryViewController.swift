//
//  categoryViewController.swift
//  test
//
//  Created by 謝宛軒 on 2020/4/9.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class categoryViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var showCategory = [CategoryModel]()
    
    
    override func viewDidLoad() {
        
    super.viewDidLoad()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = UIColor.white
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        if DBManager.getInstance().getAllCategory() != nil{
                   showCategory = DBManager.getInstance().getAllCategory()
               }else{
                   showCategory = [CategoryModel]()
               }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showCategory.count-1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == showCategory.count{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCategoryCell", for: indexPath) as! addCategoryViewCell
//            return cell
//        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! categoryViewCell
            cell.categoryName?.text = showCategory[indexPath.row].categoryName
            cell.backgroundColor = UIColor.white
            cell.imageView.image = UIImage(named: "\(showCategory[indexPath.row].category_image)")
            cell.circle.backgroundColor = hexStringToUIColor(hex: "\(showCategory[indexPath.row].categoryColor)")
            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(0.7)
        )
    }
}
