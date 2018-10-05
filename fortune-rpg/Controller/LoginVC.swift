//
//  LoginVC.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 2/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    // outlets
    @IBOutlet weak var usernameTxtField: CustomTextField!
    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var passwordTxtField: CustomTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTxtField.delegate = self
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if validEntry() {
            AuthService.instance.loginUser(userName: usernameTxtField.text!, email: emailTxtField.text!, password: passwordTxtField.text!) { (success, loginError) in
                if success {
                    self.dismiss(animated: false, completion: nil)
                    debugPrint("Successfully logged in user \(self.usernameTxtField.text!)")
                    return
                } else {
                    debugPrint(String(describing: loginError?.localizedDescription))
                }
                
                AuthService.instance.registerUser(username: self.usernameTxtField.text!, email: self.emailTxtField.text!, password: self.passwordTxtField.text!) { (success, regError) in
                    if success {
                        AuthService.instance.loginUser(userName: self.usernameTxtField.text!, email: self.emailTxtField.text!, password: self.passwordTxtField.text!) { (success, nil) in
                            self.dismiss(animated: false, completion: nil)
                            debugPrint("Successfully registered user \(self.usernameTxtField.text!)")
                        }
                    } else {
                        debugPrint(String(describing: regError?.localizedDescription))
                    }
                }

            }
        }
    }
    
    func validEntry() -> Bool {
        if usernameTxtField == nil {return false}
        if emailTxtField == nil {return false}
        if passwordTxtField == nil {return false}
        return true
    }

    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
