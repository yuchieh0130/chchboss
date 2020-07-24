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
    
    let userDefaults = UserDefaults.standard
    
    @IBAction func signUpBtn(_ sender: Any) {
        userDefaults.set(userNameTextField.text, forKey: "userName")
        userDefaults.set(emailTextField.text, forKey: "userEmail")
        userDefaults.set(passwordTextField.text, forKey: "userPassword")
//        userNameTextField.text = ""
//        emailTextField.text = ""
//        passwordTextField.text = ""
        
        if userNameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" {
            warningLabel!.text = "Please fill in every field."
            warningLabel.isHidden = false
            
        } else if passwordTextField.text != confirmPasswordTextField.text {
            warningLabel!.text = "Confirm your password again."
            warningLabel!.isHidden = false
        } else if passwordTextField.text == confirmPasswordTextField.text {
//            self.present(tabBarController!, animated:true, completion:nil)
            self.performSegue(withIdentifier: "aaapple", sender: sender)
            userDefaults.set(true, forKey: "isLogIn")
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return true
    }
}
