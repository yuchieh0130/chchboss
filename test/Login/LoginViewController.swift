//
//  LoginViewController.swift
//  test
//
//  Created by HsinJou Hung on 2020/7/2.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var Daily: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    let networkController = NetworkController()
    let signUpView = SignupViewController()
    
    @IBAction func logInBtn(_ sender: Any) {
        UserDefaults.standard.set(emailTextField.text, forKey: "userEmail")
        UserDefaults.standard.set(passwordTextField.text, forKey: "userPassword")
        //performSegue(withIdentifier: "bbbanana", sender: self)

        self.networkController.login(email: emailTextField.text!, password: passwordTextField.text!) {
                (return_list) in
                if let status_code = return_list?[0],
                    let user_id = return_list?[1]{
                        if status_code as! Int == 200 {
                                DispatchQueue.main.async {
                                    UserDefaults.standard.set(user_id, forKey: "user_id")
                                    self.goHomepage()
//                                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                            }
                            
                        }
//      登入錯誤(登入不正常)
                        else {
                            print(status_code)
                            DispatchQueue.main.async {
                                self.warningLabel.isHidden = false
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
        
//        UserDefaults.standard.set(true, forKey: "isLogIn")
        
        
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
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return true
    }
}

