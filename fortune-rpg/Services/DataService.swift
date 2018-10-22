//
//  DataService.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 2/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import Foundation
import Firebase

let DB = Firestore.firestore()

class DataService {
    static let instance = DataService()

    public private(set) var REF_USERS = DB.collection("users")
    public private(set) var REF_CHARS = DB.collection("characters")
        
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.document(uid).setData(userData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written for user \(uid)")
            }
        }
    }
    
    func getUserData(forUID uid: String, handler: @escaping (_ userData: Dictionary<String, Any>) -> ()) {
        REF_USERS.document(uid).getDocument { (document, error) in
            guard let userData = document?.data().map(String.init(describing:)) else { return }
            if let error = error {
                debugPrint("Error getting user data: \(error)")
            } else {
                debugPrint("User data: \(userData)")
            }
        }
    }
    
    func getCharactersForUser(handler: @escaping (_ characters: [Character]) -> ()) {
        REF_CHARS.whereField("ownerId", isEqualTo: AuthService.instance.uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                debugPrint("Error getting characters: \(error)")
                handler([Character]())
            } else {
                var characters = [Character]()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let character = Character(documentId: document.documentID, data: document.data())
                    characters.append(character)
                }
                handler(characters)
            }
        }
    }

    func writeCharacter(character: Character, completion: @escaping (_ success: Bool) -> ()) {
        let characterData = character.flatpack()
        var ref: DocumentReference!
        ref = REF_CHARS.addDocument(data: characterData) { error in
            if let error = error {
                debugPrint("Error writing document: \(error)")
                completion(false)
            } else {
                character.documentId = ref!.documentID
                debugPrint("Successfully wrote character: \(ref!.documentID)")
                completion(true)
            }
        }
    }
    
    func deleteCharacter(character: Character, completion: @escaping (_ success: Bool) -> ()) {
        REF_CHARS.document(character.documentId).delete() { err in
            if let err = err {
                debugPrint("Error removing document: \(err)")
                completion(false)
            }
            completion(true)
        }
    }
    
    func saveCharacter(character: Character, completion: @escaping (_ success: Bool) -> ()) {
        let characterData = character.flatpack()
        REF_CHARS.document(character.documentId).updateData(characterData) { error in
            if let error = error {
                debugPrint("Error saving document: \(error)")
                completion(false)
            } else {
                debugPrint("Successfully saved character: \(String(describing: character.documentId))")
                completion(true)
            }
        }
    }
    
}




//To hide this warning and ensure your app does not break, you need to add the following code to your app before calling any other Cloud Firestore methods:
//
//let db = Firestore.firestore()
//let settings = db.settings
//settings.areTimestampsInSnapshotsEnabled = true
//db.settings = settings
//
//With this change, timestamps stored in Cloud Firestore will be read back as Firebase Timestamp objects instead of as system Date objects. So you will also need to update code expecting a Date to instead expect a Timestamp. For example:
//
//// old:
//let date: Date = documentSnapshot.get("created_at") as! Date
//// new:
//let timestamp: Timestamp = documentSnapshot.get("created_at") as! Timestamp
//let date: Date = timestamp.dateValue()
//
//Please audit all existing usages of Date when you enable the new behavior. In a future release, the behavior will be changed to the new behavior, so if you do not follow these steps, YOUR APP MAY BREAK.
