//
//  LoginViewController.swift
//  test
//
//  Created by HsinJou Hung on 2020/7/2.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import LineSDK

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var Daily: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    //let networkController = NetworkController()
    let signUpView = SignupViewController()
    
    
    @IBOutlet var logInbtn: UIButton!
    @IBOutlet var signUpBtn: UIButton!
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    let bottomLine1: UIView = {
        let tmpView = UIView()
        tmpView.backgroundColor = .lightGray
        return tmpView
    }()
    let bottomLine2: UIView = {
        let tmpView = UIView()
        tmpView.backgroundColor = .lightGray
        return tmpView
    }()
    
    @IBAction func logInBtn(_ sender: Any) {
        UserDefaults.standard.set(emailTextField.text, forKey: "userEmail")
        UserDefaults.standard.set(passwordTextField.text, forKey: "userPassword")
        //performSegue(withIdentifier: "bbbanana", sender: self)
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            warningLabel!.text = "Please fill in every field."
            warningLabel.isHidden = false
            return
        }
        
        net.login(email: emailTextField.text!, password: passwordTextField.text!) {
            (return_list) in
            if let status_code = return_list?[0],
                let user_id = return_list?[1]{
                if status_code as! Int == 200 {
                    DispatchQueue.main.async {
                        self.warningLabel.text = "Loading your data...🥕"
                        self.warningLabel.isHidden = false
                        return
                    }
                    print("login")
                    UserDefaults.standard.set(user_id, forKey: "user_id")
                    let user_id = UserDefaults.standard.integer(forKey: "user_id")
                    print("login in : userId_\(user_id)")
                    let last_track_id = UserDefaults.standard.integer(forKey: "last_track_id")
                    print(last_track_id)
                    let data = ["user_id":String(user_id),"last_track_id":String(last_track_id)]
                    net.pushTrackData(data: data){
                        (return_list) in
                        if let status_code = return_list?[0],
                            let data = return_list?[1] as? [[AnyObject]],
                            let last_track_id = return_list?[2]{
                            if status_code as! Int == 200{
                                UserDefaults.standard.set(last_track_id, forKey: "last_track_id")
                                for i in 0...data.count-1{
                                    print(data[i])
                                    let modelInfo = TrackModel(trackId: 0, startDate: data[i][2] as! String, startTime: data[i][3] as! String, weekDay: (data[i][4] as! NSNumber).int32Value, endDate: data[i][5] as! String, endTime: data[i][6]  as! String, categoryId: (data[i][7] as! NSNumber).int32Value, locationId: 1, placeId: 1)
                                    DBManager.getInstance().addTrack(modelInfo)
                                }
                                DispatchQueue.main.async{
                                    self.goHomepage()
                                }
                            }
                            else{
                                print("pushTrackData\(status_code)")
                                DispatchQueue.main.async{
                                    self.goHomepage()
                                }
                            }
                        }else{
                            print("pushTrackData error")
                            DispatchQueue.main.async{
                                self.goHomepage()
                            }
                        }
                    }
                }
                    //      登入錯誤(登入不正常)
                else {
                    print("login\(status_code)")
                    DispatchQueue.main.async {
                        self.warningLabel.isHidden = false
                        self.warningLabel.text = "Connection Error"
                        return
                    }
                }
            }
                //    登入請求沒有送出
            else {
                DispatchQueue.main.async {
                    self.warningLabel.text = "Connection error"
                    self.warningLabel.isHidden = false
                    print("error")
                    return
                }
            }
        }
        
        //UserDefaults.standard.set(true, forKey: "isLogIn")
        
        
    }
    
    @IBAction func SignUpBtn(_ sender: Any) {
        UserDefaults.standard.set(emailTextField.text, forKey: "userEmail")
        UserDefaults.standard.set(passwordTextField.text, forKey: "userPassword")
        //self.present(signUpView, animated: true, completion: nil)
    }
    
    @IBAction func skipLogin(_ sender: Any) {
        goHomepage()
    }
    
    func goHomepage(){
        UserDefaults.standard.set(true, forKey: "isLogIn")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! tabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBar
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Create Login Button.
        let loginButton = LoginButton()
        loginButton.delegate = self
        
        // Configuration for permissions and presenting.
        loginButton.permissions = [.profile]
        
        var parameters = LoginManager.Parameters()
        parameters.botPromptStyle = .normal
        loginButton.parameters = parameters
        
        loginButton.presentingViewController = self
        
        // Add button to view and layout it.
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerYAnchor.constraint(equalTo: signUpBtn.bottomAnchor, constant: 30).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //        var parameters = LoginManager.Parameters()
        //        parameters.botPromptStyle = .normal
        //        LoginManager.shared.login(permissions: [.profile], parameters: parameters) {
        //            result in
        //            switch result {
        //            case .success(let loginResult):
        //                if let profile = loginResult.userProfile {
        //                    print("User ID: \(profile.userID)")
        //                    print("User Display Name: \(profile.displayName)")
        //                    print("User Icon: \(String(describing: profile.pictureURL))")
        //                }
        //            case .failure(let error):
        //                print(error)
        //            }
        //        }
        
        warningLabel.isHidden = true
        emailTextField.text = UserDefaults.standard.value(forKey: "userEmail") as? String
        passwordTextField.text = UserDefaults.standard.value(forKey: "userPassword") as? String
        
        if UserDefaults.standard.bool(forKey: "isLogIn") == true{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! tabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabBar
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        signUpBtn.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 128/255, alpha: 0.7)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.height/2
        signUpBtn.clipsToBounds = true
        
        logInbtn.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 128/255, alpha: 0.7)
        logInbtn.layer.cornerRadius = signUpBtn.frame.height/2
        logInbtn.clipsToBounds = true
        
        
    }
    
}

extension LoginViewController {
    func setupUI() {
        
        bgImageView.image = UIImage(named: "loginBackground")
        bgImageView.contentMode = .scaleAspectFill
        
        bgImageView.snp.setLabel("bgImageView")
        bgImageView.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(70)
            make.trailing.equalTo(-70)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(40)
            make.leading.equalTo(70)
            make.trailing.equalTo(-70)
        }
        
        warningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        view.addSubview(bottomLine1)
        bottomLine1.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom)
            make.height.equalTo(1)
            make.width.equalTo(emailTextField.snp.width)
            make.leading.trailing.equalTo(emailTextField)
        }
        view.addSubview(bottomLine2)
        bottomLine2.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.height.equalTo(1)
            make.width.equalTo(passwordTextField.snp.width)
            make.leading.trailing.equalTo(passwordTextField)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        textField.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 128/255, alpha: 0.3)
    //    }
    //
    //    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    //        textField.backgroundColor = .white
    //    }
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) {
        //hideIndicator()
        print("Login Succeeded.")
        print(loginResult)
        
        let user_lineid = loginResult.userProfile?.userID
        let user_name = loginResult.userProfile?.displayName
        lineLogin(user_lineid: user_lineid!, user_name: user_name!)
        
    }
    
    func loginButton(_ button: LoginButton, didFailLogin error: LineSDKError) {
        //hideIndicator()
        print("Error: \(error)")
    }
    
    func loginButtonDidStartLogin(_ button: LoginButton) {
        //showIndicator()
        print("Login Started.")
    }
    
    func lineLogin(user_lineid: String, user_name: String){
        net.lineLogin(user_lineid: user_lineid, user_name: user_name) {
            (return_list) in
            if let status_code = return_list?[0],
                let user_id = return_list?[1]{
                if status_code as! Int == 200 {
                    DispatchQueue.main.async {
                        self.warningLabel.text = "Loading your data...🥕"
                        self.warningLabel.isHidden = false
                        return
                    }
                    print("login")
                    UserDefaults.standard.set(user_id, forKey: "user_id")
                    let user_id = UserDefaults.standard.integer(forKey: "user_id")
                    print("login in : userId_\(user_id)")
                    let last_track_id = UserDefaults.standard.integer(forKey: "last_track_id")
                    print(last_track_id)
                    let data = ["user_id":String(user_id),"last_track_id":String(last_track_id)]
                    net.pushTrackData(data: data){
                        (return_list) in
                        if let status_code = return_list?[0],
                            let data = return_list?[1] as? [[AnyObject]],
                            let last_track_id = return_list?[2]{
                            if status_code as! Int == 200{
                                UserDefaults.standard.set(last_track_id, forKey: "last_track_id")
                                for i in 0...data.count-1{
                                    print(data[i])
                                    let modelInfo = TrackModel(trackId: 0, startDate: data[i][2] as! String, startTime: data[i][3] as! String, weekDay: (data[i][4] as! NSNumber).int32Value, endDate: data[i][5] as! String, endTime: data[i][6]  as! String, categoryId: (data[i][7] as! NSNumber).int32Value, locationId: 1, placeId: 1)
                                    DBManager.getInstance().addTrack(modelInfo)
                                }
                                DispatchQueue.main.async{
                                    self.goHomepage()
                                }
                            }
                            else{
                                print("pushTrackData\(status_code)")
                                DispatchQueue.main.async{
                                    self.goHomepage()
                                }
                            }
                        }else{
                            print("pushTrackData error")
                            DispatchQueue.main.async{
                                self.goHomepage()
                            }
                        }
                    }
                }
                    //      登入錯誤(登入不正常)
                else {
                    print("login\(status_code)")
                    DispatchQueue.main.async {
                        self.warningLabel.isHidden = false
                        self.warningLabel.text = "Connection Error"
                        return
                    }
                }
            }
                //    登入請求沒有送出
            else {
                DispatchQueue.main.async {
                    self.warningLabel.text = "Connection error"
                    self.warningLabel.isHidden = false
                    print("error")
                    return
                }
            }
        }
    }
    
}

