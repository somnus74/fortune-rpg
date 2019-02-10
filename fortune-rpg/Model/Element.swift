//
//  Element.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 11/1/19.
//  Copyright © 2019 Xenophile Games. All rights reserved.
//

import Foundation

class Element {
    var name: String
    var mandatory: Bool = false
    
    
    init(_ name: String, order: Int, value: String! = nil, ivalue: Int! = nil, mandatory: Bool = false, rolls: Bool = false, req: String! = nil) {
        self.name = name
        self.order = order
        self.value = value
        self.ivalue = ivalue
        self.mandatory = mandatory
        self.rolls = rolls
        self.req = req
    }
    
    init(data: Dictionary<String, Any>) {
        name = "Uninitialised name"
        for(key, val) in data {
            switch key {
            // put proper error handling in here?
            case "name":
                name = val as! String
            case "order":
                order = val as? Int
            case "value":
                value = val as? String
            case "ivalue":
                ivalue = val as? Int
            case "mandatory":
                mandatory = val as! Bool
            case "rolls":
                rolls = val as! Bool
            case "req":
                req = val as? String
            default:
                debugPrint("Unknown part of element: \(key) : \(val)")
            }
        }
    }
    
    func asDict() -> Dictionary<String, Any?> {
        return [ "type": type.rawValue,
                 "name": name,
                 "order": order,
                 "value": value,
                 "ivalue": ivalue,
                 "mandatory": mandatory,
                 "rolls": rolls,
                 "req": req
        ]
    }
    
    func copy() -> Element {
        return Element(name, type: type, order: order, value: value, ivalue: ivalue, mandatory: mandatory, rolls: rolls)
    }
    
}

class ElemFreeText: Element {
    var value: String
    var head: Bool = false
    
    init(_ name: String, order: Int, value: String! = nil, mandatory: Bool = false, head: Bool = false) {
        super.int
        self.name = name
        self.value = value
        self.mandatory = mandatory
        self.head = head
    }

    

}


var order: Int!
var ivalue: Int!
var dvalue: Int!
var rolls: Bool = false
var req: String!        // coded requirement string, only for traits atm

