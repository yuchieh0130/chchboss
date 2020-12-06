//
//  rankViewController.swift
//  test
//
//  Created by Andrey C. on 2020/10/8.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

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
    @IBOutlet weak var crown: UIImageView!
    @IBOutlet weak var optionStackView: UIStackView!
    
    var animatedImage: UIImage!
    var showCategory = [CategoryModel]()
    var category = CategoryModel(categoryId: 7, categoryName: "default", categoryColor: "Grey", category_image: "default")
    
    var rankList :[rankModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraint()
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
//                        print(i[1])
//                        print(i[3])
//                        print(total)
                    }
                    for i in rank{
                        let percent = Int(((i[3] as! Double)/total).rounding(toDecimal: 3)*100)
                        let rankmodel = rankModel(id:i[0] as! Int,name:i[1] as! String,percent: percent)
                        self.rankList.append(rankmodel)
                    }
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
        
        winnerIcon.layer.cornerRadius = 0.5*winnerIcon.bounds.size.height
        winnerIcon.layer.borderWidth = 2
        winnerIcon.layer.borderColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.8).cgColor
        winnerIcon.clipsToBounds = true
        
        //emojiAngry.layer.cornerRadius = 0.5*emojiAngry.bounds.size.height
        emojiAngry.clipsToBounds = true
        //emojiThumb.layer.cornerRadius = 0.5*emojiThumb.bounds.size.height
        emojiThumb.clipsToBounds = true
        //emojiHeart.layer.cornerRadius = 0.5*emojiHeart.bounds.size.height
        emojiHeart.clipsToBounds = true
        
        exitBtn.backgroundColor = UIColor(red: 247/255, green: 199/255, blue: 88/255, alpha: 1)
        exitBtn.tintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
        //exitBtn.layer.cornerRadius = 10.0
        exitBtn.clipsToBounds = true
        exitBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        exitBtn.addTarget(self, action: #selector(exit), for: .touchUpInside)
        
        showCategory = DBManager.getInstance().getAllCategory()
        titleBtn.setTitle("Ranking - Food 🔽", for: UIControl.State.normal)
        animatedImage = UIImage.animatedImageNamed("\(showCategory[0].categoryName)-", duration: 1)
        gifImgView.image = animatedImage
    }
    
    func setUpConstraint(){
        rankView.translatesAutoresizingMaskIntoConstraints = false
        exitBtn.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        winnerIcon.translatesAutoresizingMaskIntoConstraints = false
        winnerName.translatesAutoresizingMaskIntoConstraints = false
        emojiAngry.translatesAutoresizingMaskIntoConstraints = false
        emojiThumb.translatesAutoresizingMaskIntoConstraints = false
        emojiHeart.translatesAutoresizingMaskIntoConstraints = false
        gifImgView.translatesAutoresizingMaskIntoConstraints = false
        titleBtn.translatesAutoresizingMaskIntoConstraints = false
        crown.translatesAutoresizingMaskIntoConstraints = false
         
        rankView.snp.makeConstraints{ (item) in
            item.centerX.equalToSuperview()
            item.centerY.equalToSuperview()
            item.width.equalToSuperview().multipliedBy(0.8)
            item.height.equalToSuperview().multipliedBy(0.85)
        }
        rankView.layer.cornerRadius = 10.0
        
        exitBtn.snp.makeConstraints{ (item) in
            item.width.equalTo(rankView.snp.width)
            item.height.equalTo(rankView.snp.height).dividedBy(15)
            item.centerX.equalToSuperview()
            item.bottom.equalTo(rankView.snp.bottom)
        }
        exitBtn.layer.cornerRadius = 10.0
        
        titleBtn.snp.makeConstraints{ (item) in
            item.top.equalTo(rankView.snp.top)
            item.height.equalTo(rankView.snp.height).dividedBy(14)
            item.width.equalTo(rankView.snp.width)
            item.centerX.equalTo(rankView.snp.centerX)
        }
        titleBtn.layer.cornerRadius = 10.0
        
       
        for option in options{
            option.snp.makeConstraints{ (item) in
                item.width.equalTo(titleBtn.snp.width)
                item.height.equalTo(titleBtn.snp.height).multipliedBy(0.75)
            }
        }
        
        winnerIcon.snp.makeConstraints{ (item) in
            item.width.equalTo(rankView.snp.height).dividedBy(6)
            item.height.equalTo(rankView.snp.height).dividedBy(6)
            item.leading.equalToSuperview().offset(20)
            item.top.equalTo(titleBtn.snp.bottom).offset(40)
        }
        winnerIcon.layer.cornerRadius = winnerIcon.bounds.size.height/2
        
        crown.snp.makeConstraints{ (item) in
            item.width.equalTo(50)
            item.height.equalTo(40)
            item.leading.equalTo(winnerIcon.snp.trailing).offset(20)
            item.bottom.equalTo(winnerIcon.snp.centerY).offset(-20)
        }
        
        winnerName.snp.makeConstraints{ (item) in
            item.bottom.equalTo(crown.snp.bottom)
            item.leading.equalTo(crown.snp.trailing).offset(10)
        }
        
        gifImgView.snp.makeConstraints{ (item) in
            item.size.equalTo(winnerIcon)
            item.centerX.equalTo(crown.snp.trailing).offset(10)
            item.top.equalTo(winnerName.snp.bottom).offset(10)
        }
        
        emojiThumb.snp.makeConstraints{ (item) in
            item.leading.equalToSuperview().offset(20)
            item.size.equalTo(rankView.snp.width).dividedBy(4)
            item.centerY.equalTo(rankView.snp.centerY)
        }
        emojiThumb.layer.cornerRadius = 0.5*emojiThumb.bounds.size.height
        
        emojiHeart.snp.makeConstraints{ (item) in
            item.centerX.equalTo(rankView.snp.centerX)
            item.size.equalTo(rankView.snp.width).dividedBy(4)
            item.top.equalTo(emojiThumb.snp.top)
        }
        emojiHeart.layer.cornerRadius = 0.5*emojiHeart.bounds.size.height
        
        emojiAngry.snp.makeConstraints{ (item) in
            item.trailing.equalTo(rankView.snp.trailing).offset(-20)
            item.size.equalTo(rankView.snp.width).dividedBy(4)
            item.top.equalTo(emojiThumb.snp.top)
        }
        emojiAngry.layer.cornerRadius = 0.5*emojiAngry.bounds.size.height
        
        tableView.snp.makeConstraints{ (item) in
            item.top.equalTo(emojiHeart.snp.bottom).offset(10)
            item.centerX.equalTo(rankView.snp.centerX)
            item.width.equalTo(rankView.snp.width)
            item.height.equalTo(rankView.snp.width).dividedBy(3)
            item.bottom.equalTo(exitBtn.snp.top)
        }
        
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
//        winnerIcon.image = UIImage(named: "user\()")
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
            self.winnerIcon.image = UIImage(named: "user\(self.rankList[0].id)")
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
            cell.percentage.text = "\(rankList[indexPath.row].percent) %" ?? ""
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rankView.bounds.size.height/15
    }
}
