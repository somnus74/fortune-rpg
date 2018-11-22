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
    static let instance = AuthService()
    
    public private(set) var uid: String!
    public private(set) var email: String!
    public private(set) var userName: String!

    init() {
        if let currentId = Auth.auth().currentUser {
            uid = currentId.uid
            email = currentId.email
            userName = currentId.displayName
            debugPrint("Current user: \(String(describing: uid))")
        } else {
            debugPrint("No current user")
        }
    }
    
    var loggedIn: Bool {
        return Auth.auth().currentUser == nil ? false : true
    }
    
    func registerUser(username: String, email: String, password: String, completion: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                completion(false, error)
                debugPrint("User creation error \(String(describing: error))")
                return
            }
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { (error) in
                let userData = ["provider": user.providerID, "email": email, "userName": username] as Dictionary<String, Any>
                DataService.instance.createDBUser(uid: user.uid, userData: userData)
                completion(true, nil)
            })
            
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error == nil {
                guard let dbuser = authResult?.user else {
                    debugPrint("User auth data error")
                    completion(false, error)
                    return
                }
                self.uid = dbuser.uid
                self.email = dbuser.email
                self.userName = dbuser.displayName
                completion(true, nil)
                
            } else {
                completion(false, error)
            }
        }
    }
    
    func signOut(completion: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        do {
            try Auth.auth().signOut()
            uid = nil
            email = nil
            userName = nil
            completion(true, nil)
        } catch {
            debugPrint("Error signing out: \(error)")
            completion(false, error)
        }
    }
}


