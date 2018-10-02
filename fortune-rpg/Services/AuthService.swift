//
//  AuthService.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 2/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import Foundation
import Firebase


class AuthService {
    static let instance = DataService()
    
    var loggedIn: Bool {
        return Auth.auth().currentUser == nil ? false : true
    }
    
    func registerUser(email: String, password: String, completion: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                completion(false, error)
                return
            }
            let userData = ["provider": user.providerID] as Dictionary<String, Any>
            
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            completion(true, nil)
        }
    }
    
}


