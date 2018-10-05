//
//  Character.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 3/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import Foundation

class Character {
    var documentId: String!
    
    var owner: String
    var name: String!
    var campaign: Campaign!
    var level: Int = 0
    
    var attributes = [Attribute]()
    var traits = [Trait]()
    var motivations = [String]()
    var problems = [String]()
    var equipment = [Equipment]()
    
    init() {
        self.owner = AuthService.instance.uid
        self.name = "New Character"
    }
    
    func flatpack() -> Dictionary<String, Any> {
        var packed = Dictionary<String, Any>()
        
        packed["owner"] = owner
        packed["name"] = name
        //packed["campaignId"] = campaign.documentId
        
        
        return packed
    }
    
    convenience init(documentId: String, data: Dictionary<String, Any>) {
        self.init()
        self.documentId = documentId
        for (key, value) in data {
            switch key {
            case "name":
                self.name = valconvert(value, key: key)
            case "campaign":
                // find campaign - campaigns must be loaded first
                print("Campaign Id: \(String(describing: valconvert(value, key: key)))")
            case "owner":
                if self.owner != valconvert(value, key: key) {
                    debugPrint("Character owner not this user!")
                }
            default:
                debugPrint("Unknown key: \(key)")
                
            }
        }
    }
    
    func valconvert(_ value: Any, key: String? = nil) -> String! {
        guard let result = value as? String else {
            debugPrint("Conversion error in: \(String(describing: key)), Value: \(value)")
            return nil
        }
        return result
    }
}


class Attribute {
    var name: String
    var value: Int = 0
    
    init(name: String) {
        self.name = name
    }
    
}


class Trait {
    var name: String

    init(name: String) {
        self.name = name
    }
    
}


class Equipment {
    var name: String
    var load: Int = 0

    init(name: String) {
        self.name = name
    }

}

