//
//  SignupViewController.swift
//  test
//
//  Created by HsinJou Hung on 2020/7/2.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
//    @IBOutlet weak var cancelLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    //let networkController = NetworkController()
    
    @IBOutlet var signUpBtn: UIButton!
//    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    
//    private let bgImageView: UIImageView = {
//        let tmpImageView = UIImageView()
//        tmpImageView.image = UIImage(named: "loginBackground")
//        tmpImageView.contentMode = .scaleAspectFill
//        return tmpImageView
//    }()
    
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
    let bottomLine3: UIView = {
        let tmpView = UIView()
        tmpView.backgroundColor = .lightGray
        return tmpView
    }()
    let bottomLine4: UIView = {
        let tmpView = UIView()
        tmpView.backgroundColor = .lightGray
        return tmpView
    }()
    
    let cancelView: UIView = {
        let tmpView = UIView()
        return tmpView
    }()
    
    let cancelLabel: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.text = "Already have an account?"
        return tmpLabel
    }()
    
    let cancelBtn: UIButton = {
        let tmpBtn = UIButton()
        tmpBtn.setTitle("Log In", for: .normal)
        tmpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        tmpBtn.titleLabel?.textColor = .darkText
        tmpBtn.setTitleColor(.blue, for: .normal)
        return tmpBtn
    }()
    
    
    @IBAction func signUpBtn(_ sender: Any) {
        userDefaults.set(userNameTextField.text, forKey: "userName")
        userDefaults.set(emailTextField.text, forKey: "userEmail")
        userDefaults.set(passwordTextField.text, forKey: "userPassword")
        
        if userNameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" {
            warningLabel!.text = "Please fill in every field."
            warningLabel.isHidden = false
            
        } else if !(emailTextField.text?.contains("@") ?? false) {
            warningLabel.text = "Incorrect Email format."
            warningLabel!.isHidden = false
        } else if passwordTextField.text != confirmPasswordTextField.text {
            warningLabel!.text = "Confirm your password again."
            warningLabel!.isHidden = false
        } else if passwordTextField.text == confirmPasswordTextField.text {
            
            
            net.register(email:emailTextField.text!, password: passwordTextField.text!, user_name: userNameTextField.text!){
                (return_list) in
                if let status_code = return_list?[0],
                    let user_id = return_list?[1]{
                    if status_code as! Int == 200{
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(user_id, forKey: "user_id")
                            self.userDefaults.set(true, forKey: "isLogIn")
                            self.performSegue(withIdentifier: "aaapple", sender: sender)
                        }
                    }
                        //    登入錯誤(登入不正常)
                    else{
                        print(status_code)
                        DispatchQueue.main.async {
                            self.warningLabel.text = "The Email had been registered."
                            self.warningLabel.isHidden = false
                            return
                        }
                        
                    }
                    //    登入請求沒有送出
                }else{
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
    
//    @IBAction func cancelBtn(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        warningLabel.isHidden = true
        
        signUpBtn.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 128/255, alpha: 0.7)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.height/2
        signUpBtn.clipsToBounds = true
        
//        cancelBtn.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 128/255, alpha: 0.7)
//        cancelBtn.layer.cornerRadius = signUpBtn.frame.height/2
//        cancelBtn.clipsToBounds = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension SignupViewController {
    func setupUI() {
        bgImageView.image = UIImage(named: "loginBackground")
        bgImageView.contentMode = .scaleAspectFill
        
        bgImageView.snp.setLabel("bgImageView")
        bgImageView.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
        
        userNameTextField.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-60)
            make.leading.equalTo(70)
            make.trailing.equalTo(-70)
        }
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(userNameTextField.snp.bottom).offset(40)
            make.leading.equalTo(70)
            make.trailing.equalTo(-70)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(40)
            make.leading.equalTo(70)
            make.trailing.equalTo(-70)
        }
        confirmPasswordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.leading.equalTo(70)
            make.trailing.equalTo(-70)
        }
        
        addTextFieldWithLine(line: bottomLine1, field: userNameTextField)
        addTextFieldWithLine(line: bottomLine2, field: emailTextField)
        addTextFieldWithLine(line: bottomLine3, field: passwordTextField)
        addTextFieldWithLine(line: bottomLine4, field: confirmPasswordTextField)
        
        warningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        signUpBtn.snp.makeConstraints { (make) in
            make.top.equalTo(warningLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(cancelView)
        cancelView.snp.makeConstraints { (make) in
            make.top.equalTo(signUpBtn.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        cancelView.addSubview(cancelLabel)
        cancelView.addSubview(cancelBtn)
        cancelLabel.snp.makeConstraints { (make) in
            make.leading.greaterThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.trailing.bottom.lessThanOrEqualToSuperview()
            make.leading.equalTo(cancelLabel.snp.trailing).offset(5)
            make.top.greaterThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
        
        cancelBtn.addTarget(self, action: #selector(didPressedCancelBtn(sender:)),
                            for: .touchUpInside)
    }
    
    func addTextFieldWithLine(line: UIView, field: UITextField) {
        view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(field.snp.bottom)
            make.height.equalTo(1)
            make.width.equalTo(field.snp.width)
            make.leading.trailing.equalTo(field)
        }
    }
    
    @objc func didPressedCancelBtn(sender: SignupViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

