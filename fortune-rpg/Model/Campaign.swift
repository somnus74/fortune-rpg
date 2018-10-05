//
//  Campaign.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 3/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import Foundation

class Campaign {
    var documentId: String!
    
    var owner: String
    var name: String!
    var description: String!
    var characters = [Character]()
    
    init(owner: String) {
        self.owner = owner
    }
    
    
}
