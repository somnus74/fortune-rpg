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
    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var passwordTxtField: CustomTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        
        loginBtn.layer.borderWidth = 1
        registerBtn.layer.borderWidth = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AuthService.instance.loggedIn {
            dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if validEntry() {
            AuthService.instance.loginUser(email: emailTxtField.text!, password: passwordTxtField.text!) { (success, loginError) in
                if success {
                    self.dismiss(animated: false, completion: nil)
                    debugPrint("Successfully logged in user \(self.emailTxtField.text!)")
                    return
                } else {
                    debugPrint(String(describing: loginError?.localizedDescription))
                    let alert = UIAlertController(title: "Login Error", message: "Could not log in user \(self.emailTxtField.text!)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: false, completion: nil)

                }
            }
        } else {
            let alert = UIAlertController(title: "Entry Error", message: "Email or Password not entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)

        }
    }
    
    @IBAction func registerBtnPress(_ sender: Any) {
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
        self.present(registerVC!, animated: false, completion: nil)

    }
    
    
    func validEntry() -> Bool {
        if emailTxtField == nil || emailTxtField.text == "" {return false}
        if passwordTxtField == nil || passwordTxtField.text == "" {return false}
        return true
    }

    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
