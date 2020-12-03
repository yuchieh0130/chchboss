//
//  rankViewController.swift
//  test
//
//  Created by Andrey C. on 2020/10/8.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class rankViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var rankView: UIView!
    @IBOutlet var exitBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var winnerIcon: UIImageView!
    @IBOutlet var winnerName: UILabel!
    @IBOutlet var emojiAngry: UIButton!
    @IBOutlet var emojiThumb: UIButton!
    @IBOutlet var emojiHeart: UIButton!
    @IBOutlet var gifImgView: UIImageView!
    @IBOutlet var titleBtn: UIButton!
    @IBOutlet var options: [UIButton]!
    
    var animatedImage: UIImage!
    var showCategory = [CategoryModel]()
    var category = CategoryModel(categoryId: 7, categoryName: "default", categoryColor: "Grey", category_image: "default")
    
    var rankList :[rankModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getRank(category: "1")
        
    }
    
    func getRank(category: String){
        net.rank(category: category){ (return_list) in
            if let status_code = return_list?[0],
                let rank = return_list?[1] as? [[AnyObject]]{
                if status_code as! Int == 200{
                    var total = 0.0
                    for i in rank{
                        total += i[3] as! Double
                    }
                    for i in rank{
                        let percent = Int(((i[3] as! Double)/total).rounding(toDecimal: 3)*100)
                        let rankmodel = rankModel(id:i[0] as! Int,name:i[1] as! String,percent: percent)
                        self.rankList.append(rankmodel)
                    }
                    print(self.rankList)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.reloadWinner()
                    }
                }else{
                    print("rank error: \(status_code)")
                }
                
            }else{
                print("rank error")
            }
            
        }
    }
    
    func setupUI(){
        self.tabBarController?.tabBar.isHidden = true
        
        titleBtn.layer.cornerRadius = 10.0
        titleBtn.clipsToBounds = true
        titleBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        winnerIcon.layer.cornerRadius = 0.5*winnerIcon.bounds.size.width
        winnerIcon.layer.borderWidth = 2
        winnerIcon.layer.borderColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.8).cgColor
        winnerIcon.clipsToBounds = true
        
        emojiAngry.layer.cornerRadius = 0.5*emojiAngry.bounds.size.width
        emojiAngry.clipsToBounds = true
        emojiThumb.layer.cornerRadius = 0.5*emojiThumb.bounds.size.width
        emojiThumb.clipsToBounds = true
        emojiHeart.layer.cornerRadius = 0.5*emojiHeart.bounds.size.width
        emojiHeart.clipsToBounds = true
        
        exitBtn.backgroundColor = UIColor(red: 247/255, green: 199/255, blue: 88/255, alpha: 1)
        exitBtn.tintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
        exitBtn.layer.cornerRadius = 10.0
        exitBtn.clipsToBounds = true
        exitBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        exitBtn.addTarget(self, action: #selector(exit), for: .touchUpInside)
        
        showCategory = DBManager.getInstance().getAllCategory()
        titleBtn.setTitle("Ranking - Food 🔽", for: UIControl.State.normal)
        animatedImage = UIImage.animatedImageNamed("\(showCategory[0].categoryName)-", duration: 1)
        gifImgView.image = animatedImage
    }
    
    @IBAction func emojiThumb(_ sender: Any) {
        addEmoji(user_id: String(rankList[0].id), emoji: "liked")
    }
    @IBAction func emojiHeart(_ sender: Any) {
        addEmoji(user_id: String(rankList[0].id), emoji: "heart")
    }
    @IBAction func emojiAngry(_ sender: Any) {
        addEmoji(user_id: String(rankList[0].id), emoji: "mad")
    }
    
    
    @IBAction func startSelect(_ sender: UIButton) {
        for option in options{
            UIView.animate(withDuration: 0.3, animations: {
                option.isHidden = !option.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func optionPressed(_ sender: UIButton) {
        for option in options{
            UIView.animate(withDuration: 0.3, animations: {
                option.isHidden = !option.isHidden
                self.view.layoutIfNeeded()
            })
        }
        self.rankList = []
        getRank(category: "\(sender.tag)")
//        winnerIcon.image = UIImage(named: "Image-2")
//        winnerName.text = "宛先先"
        let categoryName = sender.currentTitle ?? ""
        titleBtn.setTitle("Ranking - \(categoryName) 🔽", for: UIControl.State.normal)
        animatedImage = UIImage.animatedImageNamed("\(showCategory[sender.tag-1].categoryName)-", duration: 1)
        gifImgView.image = animatedImage
    }
    
    func addEmoji(user_id:String,emoji:String){
        net.addEmoji(emoji: emoji,user_id: user_id){ status_code in
            if status_code == 200{
                //新增成功！看要不要跳出可愛小圖案！
            }
        }
    }
    
    @objc func exit(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func reloadWinner(){
        if rankList.count > 0{
            self.winnerName.text = self.rankList[0].name
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
//        case [0,0]:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "rankTableViewCell", for: indexPath) as! rankTableViewCell
//            cell.name.text = "Mo"
//            cell.rank.text = "2"
//            cell.percentage.text = "72%"
//            cell.selectionStyle = .none
//            return cell
//        case [0,1]:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "rankTableViewCell", for: indexPath) as! rankTableViewCell
//            cell.name.text = "CWJ"
//            cell.rank.text = "3"
//            cell.percentage.text = "67%"
//            cell.selectionStyle = .none
//            return cell
//        case [0,2]:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "rankTableViewCell", for: indexPath) as! rankTableViewCell
//            cell.name.text = "Sherry"
//            cell.rank.text = "4"
//            cell.percentage.text = "38%"
//            cell.selectionStyle = .none
//            return cell
//        case [0,3]:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "rankTableViewCell", for: indexPath) as! rankTableViewCell
//            cell.name.text = "Vincent"
//            cell.rank.text = "5"
//            cell.percentage.text = "10%"
//            cell.selectionStyle = .none
//            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "rankTableViewCell", for: indexPath) as! rankTableViewCell
            cell.name.text = rankList[indexPath.row].name
            cell.rank.text = "\(indexPath.row+1)"
            cell.percentage.text = "\(rankList[indexPath.row].percent) %"
            cell.selectionStyle = .none
            return cell
        }
    }
}
