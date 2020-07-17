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
    
    let userDefaults = UserDefaults.standard
    
    
    @IBAction func logInBtn(_ sender: Any) {
        userDefaults.set(emailTextField.text, forKey: "userEmail")
        userDefaults.set(passwordTextField.text, forKey: "userPassword")
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func logInbtn(_ sender: Any) {
        self.performSegue(withIdentifier: "bbbanana", sender: sender)
    }
    
    @IBAction func SignUpBtn(_ sender: Any) {
        //self.present(signUpView, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = userDefaults.value(forKey: "userEmail") as? String
        passwordTextField.text = userDefaults.value(forKey: "userPassword") as? String
        
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

