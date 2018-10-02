//
//  LoginVC.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 2/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    // outlets
    @IBOutlet weak var usernameTxtField: CustomTextField!
    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var passwordTxtField: CustomTextField!
    @IBOutlet weak var loginView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.bindToKeyboard()
    }
    
    @IBAction func loginButton(_ sender: Any) {
    }
    

}
