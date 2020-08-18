//
//  settingsViewController.swift
//  test
//
//  Created by 王義甫 on 2020/6/29.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class settingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var userIcon: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userID: UILabel!
    @IBOutlet var addPhotoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        userIcon.layer.cornerRadius = userIcon.frame.size.width/2.0
        userIcon.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch  indexPath {
        case [0,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "changeUsernameCell", for: indexPath) as! changeUsernameCell
            return cell
        case [0,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "changePasswordCell", for: indexPath) as! changePasswordCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editMyplaceCell", for: indexPath) as! editMyplaceCell
            return cell
        }
    }
    
    @IBAction func addBtnPress(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Choose Photo Source", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
            }else{
                print("Camera not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Remove Current Photo", style: .default, handler: { (_) in
            if #available(iOS 13.0, *) {
                self.userIcon.image = UIImage(systemName: "person.circle")
            } else {
                self.userIcon.image = nil
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            userIcon.image = image
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            userIcon.image = image
            // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) // 選的那張照片會存到user的相簿裡面
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogIn")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = login
    }
    
    
}
