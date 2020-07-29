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
    
    let signUpView = SignupViewController()
    
    @IBAction func logInBtn(_ sender: Any) {
        UserDefaults.standard.set(emailTextField.text, forKey: "userEmail")
        UserDefaults.standard.set(passwordTextField.text, forKey: "userPassword")
        emailTextField.text = ""
        passwordTextField.text = ""
        //performSegue(withIdentifier: "bbbanana", sender: self)
        UserDefaults.standard.set(true, forKey: "isLogIn")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! tabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBar
    }
    
    @IBAction func SignUpBtn(_ sender: Any) {
        UserDefaults.standard.set(emailTextField.text, forKey: "userEmail")
        UserDefaults.standard.set(passwordTextField.text, forKey: "userPassword")
        //self.present(signUpView, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

