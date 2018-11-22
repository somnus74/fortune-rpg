//
//  RegisterVC.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 9/11/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTxt: CustomTextField!
    @IBOutlet weak var emailTxt: CustomTextField!
    @IBOutlet weak var passwordTxt: CustomTextField!
    @IBOutlet weak var password2Txt: CustomTextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTxt.delegate = self
        emailTxt.delegate = self
        passwordTxt.delegate = self
        password2Txt.delegate = self
        
        registerBtn.layer.borderWidth = 1
    }
    
    @IBAction func closeBtnPress(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func registerBtnPress(_ sender: Any) {
        if usernameTxt.text == "" {
            let alert = UIAlertController(title: "Username Error", message: "Username not entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)
            return
        }
        if emailTxt.text == "" {
            let alert = UIAlertController(title: "Email Error", message: "Email not entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)
            return
        }
        if passwordTxt.text == "" || password2Txt.text == "" {
            let alert = UIAlertController(title: "Password Error", message: "Password not entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)
            return
        }
        if passwordTxt.text != password2Txt.text {
            let alert = UIAlertController(title: "Password Error", message: "Passwords do not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)
            return
        }

        AuthService.instance.registerUser(username: self.usernameTxt.text!, email: self.emailTxt.text!, password: self.passwordTxt.text!) { (success, regError) in
            if success {
                AuthService.instance.loginUser(email: self.emailTxt.text!, password: self.passwordTxt.text!) { (success, nil) in
                    self.dismiss(animated: false, completion: nil)
                    debugPrint("Successfully registered user \(self.usernameTxt.text!)")
                }
            } else {
                debugPrint(String(describing: regError?.localizedDescription))
                let alert = UIAlertController(title: "Registration Error", message: "Could not register user: \(regError?.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: false, completion: nil)
            }
        }
    }
    

}
