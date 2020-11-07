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
    var tag: String?
    var row = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = UIColor.white
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 120, height: 120)
        if DBManager.getInstance().getAllCategory() != nil{
            showCategory = DBManager.getInstance().getAllCategory()
        }else{
            showCategory = [CategoryModel]()
        }
        
        navigationItem.title = "Category"
        let backBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItems = [backBtn]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 199/255, blue: 88/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)]
    }
    
    @objc func back(){
        self.dismiss(animated: true, completion: nil)
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
        let animatedImage = UIImage.animatedImageNamed("\(showCategory[indexPath.row].categoryName)-", duration: 1)
        cell.imageView.image = animatedImage
        //cell.imageView.image = UIImage(named: "\(showCategory[indexPath.row].category_image)")
        cell.circle.backgroundColor = hexStringToUIColor(hex: "\(showCategory[indexPath.row].categoryColor)")
        row = indexPath.row
        return cell
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tag == "analysisToCategory"{
            performSegue(withIdentifier: "categoryToCombineChart", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "categoryToCombineChart"){
            if let vc = segue.destination as? combineChartViewController{
                let indexPath = collectionView.indexPathsForSelectedItems
                vc.hidesBottomBarWhenPushed = true
                vc.name = "\(showCategory[indexPath![0].row].categoryName)"
                vc.color = hexStringToUIColor (hex:"\(showCategory[indexPath![0].row].categoryColor)")
                vc.time = "time"
            }
        }
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
            alpha: CGFloat(0.5)
        )
    }
}
