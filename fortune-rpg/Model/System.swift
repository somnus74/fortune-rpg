//
//  System.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 6/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import Foundation

enum ElemType: String {
    case uninitialised
    case derText
    case freetext
    case selText
    case freeInt
    case derInt
    case resInt     // for resources, dvalue is maximum
}

//typealias adjustmentClosure = (Element, Character) -> Void

class System {
    // class which represents the Fortune system
    static let instance = System()
  
    let sectionKeys = ["main", "attributes", "derived", "skills", "traits"]
    
    var allElements: Dictionary<String, Dictionary<String, Element>> = [
        "main":
            [ "name" : Element("Name", type: .freetext, order: 1, value: "init name", mandatory: true),
              "player" : Element("Player", type: .derText, order: 2, value: AuthService.instance.userName, mandatory: true),
              "description" : Element("Description", type: .freetext, order: 3, value: "", mandatory: true),
              "level" : Element("Character Level", type: .derInt, order: 4, mandatory: true),
              "background" : Element("Background", type: .selText, order: 6, value: "Apoclast", mandatory: true),
              "devpoints" : Element("Development Points", type: .freeInt, order: 5, ivalue: 60, mandatory: true)
              ],
        "attributes":
            [ "might" : Element("Might", type: .freeInt, order: 1, ivalue: 0, mandatory: true),
              "finesse" : Element("Finesse", type: .freeInt, order: 2, ivalue: 0, mandatory: true),
              "intellect" : Element("Intellect", type: .freeInt, order: 3, ivalue: 0, mandatory: true),
              "spirit" : Element("Spirit", type: .freeInt, order: 4, ivalue: 0, mandatory: true)
            ],
        "derived":
            [ "fortune" : Element("Fortune", type: .resInt, order: 1, mandatory: true),
              "move": Element("Move", type: .derInt, order: 2, mandatory: true),
              "hit points": Element("Hit points", type: .resInt, order: 3, mandatory: true),
              "actions per round": Element("Actions per round", type: .derInt, order: 4, mandatory: true),
              "initiative": Element("Initiative", type: .derInt, order: 5, mandatory: true),
              "carry": Element("Carry", type: .resInt, order: 6, mandatory: true),
              "resources" : Element("Resources", type: .derInt, order: 7, mandatory: true),
              "might def" : Element("Might Defence", type: .derInt, order: 11, mandatory: true),
              "finesse def" : Element("Finesse Defence", type: .derInt, order: 12, mandatory: true),
              "intellect def":  Element("Intellect Defence", type: .derInt, order: 13, mandatory: true),
              "spirit def": Element("Spirit Defence", type: .derInt, order: 14, mandatory: true),
              "energy": Element("Energy", type: .resInt, order: 21, mandatory: true),
              "powerslots": Element("Power Slots", type: .derInt, order: 22, mandatory: true)
        ],
        "skills": [
            "animals" : Element("Animals", type: .freeInt, order: 1, ivalue: 0, mandatory: false)
        ],
        "traits": [String: Element]()
    ]
    
    let backgrounds = ["Apoclast", "Champion", "Companion", "Fallen", "Machine", "Outcast", "Resurrected", "Sleeper", "Transhuman", "Utopan"]
    
    func setDerived(_ character: Character) {
        let sec_main = character.elements["main"]!
        let sec_attr = character.elements["attributes"]!
        let sec_der = character.elements["derived"]!
        let sec_tra = character.elements["traits"]!
        
        sec_main["level"]!.dvalue = Int(ceil(Double(sec_main["devpoints"]!.ivalue) / 20.0))
        sec_main["devpoints"]?.dvalue = calc_dp(character)
        
        sec_attr["might"]!.dvalue = sec_attr["might"]!.ivalue + (sec_tra["bac1"]?.name == "+1 Might" ? 1 : 0)
        sec_attr["finesse"]!.dvalue = sec_attr["finesse"]!.ivalue + (sec_tra["bac1"]?.name == "+1 Finesse" ? 1 : 0)
        sec_attr["intellect"]!.dvalue = sec_attr["intellect"]!.ivalue + (sec_tra["bac1"]?.name == "+1 Intellect" ? 1 : 0)
        sec_attr["spirit"]!.dvalue = sec_attr["spirit"]!.ivalue + (sec_tra["bac1"]?.name == "+1 Spirit" ? 1 : 0)
        
        sec_der["fortune"]!.dvalue = 2
        if sec_der["fortune"]!.ivalue == nil {
            sec_der["fortune"]!.ivalue = sec_der["fortune"]!.dvalue
        }
        sec_der["move"]!.dvalue = 5
        sec_der["hit points"]!.dvalue = (sec_attr["might"]!.dvalue + sec_attr["spirit"]!.dvalue) * 5 + 10
        sec_der["actions per round"]!.dvalue = 2 + (sec_tra["bac2"]?.name == "+5 HP" ? 5 : 0)
        sec_der["initiative"]!.dvalue = sec_attr["finesse"]!.dvalue + sec_attr["intellect"]!.dvalue
        sec_der["carry"]!.dvalue = (sec_attr["might"]!.dvalue * 2) + 5
        sec_der["resources"]!.dvalue = 6 + (sec_tra["bac3"]?.name == "Resources" ? 2 : 0)
        sec_der["might def"]!.dvalue = sec_attr["might"]!.dvalue + 8 + (sec_tra["bac1"]?.name == "+1 All defences" ? 1 : 0)
        sec_der["finesse def"]!.dvalue = sec_attr["finesse"]!.dvalue + 8 + (sec_tra["bac1"]?.name == "+1 All defences" ? 1 : 0)
        sec_der["intellect def"]!.dvalue = sec_attr["intellect"]!.dvalue + 8 + (sec_tra["bac1"]?.name == "+1 All defences" ? 1 : 0)
        sec_der["spirit def"]!.dvalue = sec_attr["spirit"]!.dvalue + 8 + (sec_tra["bac1"]?.name == "+1 All defences" ? 1 : 0)
        sec_der["energy"]!.dvalue = (sec_attr["spirit"]!.dvalue + sec_attr["intellect"]!.dvalue) * 5
        sec_der["powerslots"]!.dvalue = (sec_attr["intellect"]!.dvalue + 1) / 2

    }
    
    
    func changeBackground(_ character: Character) {
        for traitkey in ["bac1", "bac2", "bac3"] {
            character.elements["traits"]?.removeValue(forKey: traitkey)
        }
        let background = character.elements["main"]!["background"]!.value!
        switch background {
        case "Apoclast":
            character.elements["traits"]!["bac1"] = Element("+1 Spirit", type: .derText, order: 101, value: "Add +1 to Spirit")
            character.elements["traits"]!["bac2"] = Element("Modified", type: .derText, order: 1011, value: "Gain 1 genetic modification")
            character.elements["traits"]!["bac3"] = Element("Commanding Presence", type: .derText, order: 1011, value: "extra d10 when using personal on inferiors")
        case "Champion":
            character.elements["traits"]!["bac1"] = Element("+1 Might", type: .derText, order: 1011, value: "Add +1 to Might")
            character.elements["traits"]!["bac2"] = Element("+5 HP", type: .derText, order: 1011, value: "Add +5 to max HP")
            character.elements["traits"]!["bac3"] = Element("Intimidation", type: .derText, order: 1011, value: "Can use a combat skill as Personal")
        case "Companion":
            character.elements["traits"]!["bac1"] = Element("+1 Spirit", type: .derText, order: 1011, value: "Add +1 to Spirit")
            character.elements["traits"]!["bac2"] = Element("Sense Emotion", type: .derText, order: 1011, value: "Perception vf Spirit Def")
            character.elements["traits"]!["bac3"] = Element("Comfort", type: .derText, order: 1011, value: "Roll Personal to remove a mental effect on somone else")
        case "Fallen":
            character.elements["traits"]!["bac1"] = Element("+1 Intellect", type: .derText, order: 1011, value: "Add +1 to Intellect")
            character.elements["traits"]!["bac3"] = Element("Resources", type: .derText, order: 1011, value: "+2 Resources and can start with High-tech equipment")
            character.elements["traits"]!["bac2"] = Element("Pilot", type: .derText, order: 1011, value: "Extra d10 when using space / flying vehicles")
        case "Machine":
            character.elements["traits"]!["bac1"] = Element("Armoured", type: .derText, order: 1011, value: "Add +2 to Armour")
            character.elements["traits"]!["bac2"] = Element("Mechanical", type: .derText, order: 1011, value: "Immune to poison, does not breathe")
            character.elements["traits"]!["bac3"] = Element("Upgraded", type: .derText, order: 1011, value: "Gain 1 bionic modification")
        case "Outcast":
            character.elements["traits"]!["bac1"] = Element("+1 Finesse", type: .derText, order: 1011, value: "Add +1 to Finesse")
            character.elements["traits"]!["bac2"] = Element("Stalker", type: .derText, order: 1011, value: "Extra d10 to Stealth in wild or abandoned structure areas")
            character.elements["traits"]!["bac3"] = Element("Adapted", type: .derText, order: 1011, value: "+2 Might defence vs poison and radiation")
        case "Resurrected":
            character.elements["traits"]!["bac1"] = Element("+1 Might", type: .derText, order: 1011, value: "Add +1 to Might")
            character.elements["traits"]!["bac2"] = Element("Historied", type: .derText, order: 1011, value: "Extra d10 when rolling Lore about ancient knowledge")
            character.elements["traits"]!["bac3"] = Element("Resources", type: .derText, order: 1011, value: "+2 Resources and can start with High-tech equipment")
        case "Sleeper":
            character.elements["traits"]!["bac1"] = Element("+1 Intellect", type: .derText, order: 1011, value: "Add +1 to Intellect")
            character.elements["traits"]!["bac2"] = Element("Upgraded", type: .derText, order: 1011, value: "Gain 1 bionic modification")
            character.elements["traits"]!["bac3"] = Element("Educated", type: .derText, order: 1011, value: "Extra d10 when rolling Lore about structure or systems")
        case "Utopan":
            character.elements["traits"]!["bac1"] = Element("+1 All defences", type: .derText, order: 1011, value: "Add +1 to all defences")
            character.elements["traits"]!["bac2"] = Element("Compliant", type: .derText, order: 1011, value: "Extra d10 when rolling Personal to deceive")
            character.elements["traits"]!["bac3"] = Element("Blah", type: .derText, order: 1011, value: "Insert something here")
        case "Transhuman":
            character.elements["traits"]!["bac1"] = Element("+1 Intellect", type: .derText, order: 1011, value: "Add +1 to Intellect")
            character.elements["traits"]!["bac2"] = Element("Modified", type: .derText, order: 1011, value: "Gain 1 genetic modification")
            character.elements["traits"]!["bac3"] = Element("Arcane", type: .derText, order: 1011, value: "Extra d10 when rolling Lore about Dust")

        default:
            debugPrint("Unknown background: \(background)")
        }
        setDerived(character)
    }
    
    func calc_dp(_ character: Character) -> Int {
        var dp = 10     // background and career
        for (_, attr) in character.elements["attributes"]! {
            dp += attr.ivalue * 3
        }
        for (_, _) in character.elements["traits"]! {
            // add in variable cost??
            dp += 2
        }

        return dp
    }
    
    func get_max(_ character: Character, element: Element) -> Int {
        switch element.name {
        case "Might", "Finesse", "Intellect", "Spirit":
            return character.elements["main"]!["level"]!.dvalue
        case "Hit points":
            return character.elements["derived"]!["hit points"]!.dvalue
        case "Energy":
            return character.elements["derived"]!["energy"]!.dvalue
        default:
            return 99
        }
    }
}





class Element {
    var type: ElemType
    var name: String
    var order: Int!
    var value: String!
    var mandatory: Bool = false
    var display: Bool = true
    //var adjustment: adjustmentClosure?

    var ivalue: Int!
    var dvalue: Int!

    init(_ name: String, type: ElemType, order: Int, value: String! = nil, ivalue: Int! = nil, mandatory: Bool = false, display: Bool = true) {
        self.type = type
        self.name = name
        self.order = order
        self.value = value
        self.ivalue = ivalue
        self.mandatory = mandatory
        self.display = display
    }
    
    init(data: Dictionary<String, Any>) {
        type = .uninitialised
        name = "Uninitialised name"
        for(key, val) in data {
            switch key {
                // put proper error handling in here?
            case "type":
                type = ElemType(rawValue: val as! String)!
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
            case "display":
                display = val as! Bool
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
                    "display": display]
    }
    
    func copy() -> Element {
        return Element(name, type: type, order: order, value: value, ivalue: ivalue, mandatory: mandatory, display: display)
    }
    
}






