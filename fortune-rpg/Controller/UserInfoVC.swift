//
//  SecondViewController.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 2/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {

    // outlets
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthService.instance.loggedIn {
            userNameLbl.text = AuthService.instance.userName
            emailLbl.text = AuthService.instance.email
        } else {
            debugPrint("Error - user not logged in on userinfo screen")
        }
    }

    @IBAction func logoutBtnWasPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTapped) in
            AuthService.instance.signOut(completion: { (status, error) in
                if status {
                    let authVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                    self.present(authVC!, animated: false, completion: nil)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        logoutPopup.addAction(logoutAction)
        logoutPopup.addAction(cancelAction)
        //logoutPopup.popoverPresentationController!.sourceView = self.view
        //logoutPopup.popoverPresentationController!.sourceRect = CGRect(x: 10, y: 10, width: 0, height: 0)
        
        present(logoutPopup, animated: true, completion: nil)
    }
    

}

