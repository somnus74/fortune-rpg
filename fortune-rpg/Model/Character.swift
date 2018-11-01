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
    var ownerId: String!
    
    var elements = Dictionary<String, Dictionary<String, Element>>()
    var campaign: Campaign!
    var DP: Int = 0
    var equip_num = 0
    
    init() {
        // deep copy
        for (skey, section) in System.instance.allElements {
            elements[skey] = Dictionary<String, Element>()
            for (key, value) in section {
                if value.mandatory {
                    elements[skey]![key] = value.copy()
                }
            }
        }
        ownerId = AuthService.instance.uid
        elements["main"]!["owner"]?.value = AuthService.instance.userName ?? "userName error"
        elements["main"]!["name"]?.value = "New Character"
        update_all()
    }
    
    func flatpack() -> Dictionary<String, Any> {
        var packed = Dictionary<String, Any>()
        
        //packed["campaignId"] = campaign.documentId
        for (skey, section) in elements {
            var newSection = Dictionary<String, Any>()
            for (key, value) in section {
                newSection[key] = value.asDict()
            }
            packed[skey] = newSection
        }
        packed["ownerId"] = ownerId
        
        return packed
    }
    
    convenience init(documentId: String, data: Dictionary<String, Any>) {
        self.init()
        self.documentId = documentId
        for (key, element) in data {
            switch key {
            case "ownerId":
                guard let testId = element as? String else {
                    debugPrint("OwnerId conversion error in document: \(documentId)")
                    return
                }
                // check owner is self?
                ownerId = testId
            case "campaign":
                // find campaign - campaigns must be loaded first
                guard let testId = element as? String else {
                    debugPrint("CampaignId conversion error in document: \(documentId)")
                    return
                }
                print("Campaign Id: \(testId)")
            default:
                guard let section = element as? Dictionary<String, Any> else {
                    debugPrint("Conversion error in document: \(documentId), section: \(key)")
                    return
                }
                elements[key] = Dictionary<String, Element>()
                for (ekey, element2) in section {
                    guard let elemdata = element2 as? Dictionary<String, Any> else {
                        debugPrint("Conversion error in document: \(documentId), section: \(key), element: \(ekey)")
                        return
                    }
                    self.elements[key]![ekey] = Element(data: elemdata)
                    if ekey == "equipment" {
                        equip_num = max(equip_num, self.elements[key]![ekey]!.ivalue!)
                    }
                }
            }
        }
        update_all()
    }
    
    func update_all() {
        System.instance.changeBackground(self)
        System.instance.setDerived(self)
    }
    
    
}

