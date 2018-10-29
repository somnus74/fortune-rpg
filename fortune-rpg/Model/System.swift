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
  
    let sectionKeys = ["main", "attributes", "derived", "careers", "skills", "traits"]
    let sectionNames = ["Main", "Attributes", "Derived Attributes", "Careers", "Skills", "Traits"]

    var allElements: Dictionary<String, Dictionary<String, Element>> = [
        "main": [
            "name" : Element("Name", type: .freetext, order: 1, value: "init name", mandatory: true),
            "player" : Element("Player", type: .derText, order: 2, value: AuthService.instance.userName, mandatory: true),
            "description" : Element("Description", type: .freetext, order: 3, value: "", mandatory: true),
            "level" : Element("Character Level", type: .derInt, order: 4, mandatory: true),
            "background" : Element("Background", type: .selText, order: 6, value: "Apoclast", mandatory: true),
            "devpoints" : Element("Development Points", type: .freeInt, order: 5, ivalue: 60, mandatory: true)
        ],
        "attributes": [
            "might" : Element("Might", type: .freeInt, order: 1, ivalue: 0, mandatory: true, rolls: true),
            "finesse" : Element("Finesse", type: .freeInt, order: 2, ivalue: 0, mandatory: true, rolls: true),
            "intellect" : Element("Intellect", type: .freeInt, order: 3, ivalue: 0, mandatory: true, rolls: true),
            "spirit" : Element("Spirit", type: .freeInt, order: 4, ivalue: 0, mandatory: true, rolls: true)
        ],
        "derived": [
            "fortune" : Element("Fortune", type: .resInt, order: 1, mandatory: true),
            "move": Element("Move", type: .derInt, order: 2, mandatory: true),
            "hit points": Element("Hit points", type: .resInt, order: 3, mandatory: true),
            "actions per round": Element("Actions per round", type: .derInt, order: 4, mandatory: true),
            "initiative": Element("Initiative", type: .derInt, order: 5, mandatory: true, rolls: true),
            "carry": Element("Carry", type: .resInt, order: 6, mandatory: true),
            "resources" : Element("Resources", type: .derInt, order: 7, mandatory: true),
            "might def" : Element("Might Defence", type: .derInt, order: 11, mandatory: true),
            "finesse def" : Element("Finesse Defence", type: .derInt, order: 12, mandatory: true),
            "intellect def":  Element("Intellect Defence", type: .derInt, order: 13, mandatory: true),
            "spirit def": Element("Spirit Defence", type: .derInt, order: 14, mandatory: true),
            "energy": Element("Energy", type: .resInt, order: 21, mandatory: true),
            "powerslots": Element("Power Slots", type: .derInt, order: 22, mandatory: true)
        ],
        "careers": [
            "ascet": Element("Ascetic", type: .freeInt, order: 1, ivalue: 0, mandatory: false),
            "crimi": Element("Criminal", type: .freeInt, order: 2, ivalue: 0, mandatory: false),
            "enter": Element("Entertainer", type: .freeInt, order: 3, ivalue: 0, mandatory: false),
            "heale": Element("Healer", type: .freeInt, order: 4, ivalue: 0, mandatory: false),
            "hunte": Element("Hunter", type: .freeInt, order: 5, ivalue: 0, mandatory: false),
            "marsh": Element("Marshall", type: .freeInt, order: 6, ivalue: 0, mandatory: false),
            "menta": Element("Mentalist", type: .freeInt, order: 7, ivalue: 0, mandatory: false),
            "physi": Element("Physicalist", type: .freeInt, order: 8, ivalue: 0, mandatory: false),
            "rigge": Element("Rigger", type: .freeInt, order: 9, ivalue: 0, mandatory: false),
            "scien": Element("Scientist", type: .freeInt, order: 10, ivalue: 0, mandatory: false),
            "soldi": Element("Soldier", type: .freeInt, order: 11, ivalue: 0, mandatory: false),
            "survi": Element("Survivor", type: .freeInt, order: 12, ivalue: 0, mandatory: false),
            "tamer": Element("Tamer", type: .freeInt, order: 13, ivalue: 0, mandatory: false)
        ],
        "skills": [
            "animals" : Element("Animals", type: .freeInt, order: 1, value: "spirit", ivalue: 0, mandatory: false, rolls: true),
            "athletics" : Element("Athletics", type: .freeInt, order: 2, value: "might", ivalue: 0, mandatory: false, rolls: true),
            "computers" : Element("Computers", type: .freeInt, order: 3, value: "intellect", ivalue: 0, mandatory: false, rolls: true),
            "craft" : Element("Craft", type: .freeInt, order: 4, value: "intellect", ivalue: 0, mandatory: false, rolls: true),
            "dodge" : Element("Dodge", type: .freeInt, order: 5, value: "finesse", ivalue: 0, mandatory: false, rolls: true),
            "dust" : Element("Dust", type: .freeInt, order: 6, value: "spirit", ivalue: 0, mandatory: false, rolls: true),
            "fighting" : Element("Fighting", type: .freeInt, order: 7, value: "might", ivalue: 0, mandatory: false, rolls: true),
            "lore" : Element("Lore", type: .freeInt, order: 8, value: "intellect", ivalue: 0, mandatory: false, rolls: true),
            "medicine" : Element("Medicine", type: .freeInt, order: 9, value: "intellect", ivalue: 0, mandatory: false, rolls: true),
            "perception" : Element("Perception", type: .freeInt, order: 10, value: "spirit", ivalue: 0, mandatory: false, rolls: true),
            "personal" : Element("Personal", type: .freeInt, order: 11, value: "spirit", ivalue: 0, mandatory: false, rolls: true),
            "science" : Element("Science", type: .freeInt, order: 12, value: "intellect", ivalue: 0, mandatory: false, rolls: true),
            "shooting" : Element("Shooting", type: .freeInt, order: 13, value: "finesse", ivalue: 0, mandatory: false, rolls: true),
            "stealth" : Element("Stealth", type: .freeInt, order: 14, value: "finesse", ivalue: 0, mandatory: false, rolls: true),
            "survival" : Element("Survival", type: .freeInt, order: 15, value: "spirit", ivalue: 0, mandatory: false, rolls: true),
            "tech" : Element("Tech", type: .freeInt, order: 16, value: "intellect", ivalue: 0, mandatory: false, rolls: true),
            "vehicles" : Element("Vehicles", type: .freeInt, order: 17, value: "finesse", ivalue: 0, mandatory: false, rolls: true),

        ],
        "traits": [
            "action" : Element("Action", type: .derText, order: 1, value: "+1 APR", ivalue: 4, mandatory: false),
            "ambidextrous" : Element("Ambidextrous", type: .derText, order: 2, value: "You have no penalty for using your off-hand", ivalue: 4, mandatory: false),
            "languages": Element("Languages", type: .derText, order: 3, value: "Learn an additional language", ivalue: 2, mandatory: false),
            "luck": Element("Luck", type: .derText, order: 4, value: "+1 base Fortune", ivalue: 4, mandatory: false),
            "extreme luck": Element("Extreme Luck", type: .derText, order: 5, value: "+1 base Fortune", ivalue: 4, mandatory: false, req: "level4"),
            "movement": Element("Movement", type: .derText, order: 6, value: "+1 Move", ivalue: 2, mandatory: false),
            "mule": Element("Mule", type: .derText, order: 7, value: "+2 carry", ivalue: 2, mandatory: false),
            "quick": Element("Quick", type: .derText, order: 8, value: "+1d10 on initiative rolls", ivalue: 4, mandatory: false),
            "tough": Element("Tough", type: .derText, order: 9, value: "+1d10 on survival rolls", ivalue: 4, mandatory: false),
            "wealth": Element("Wealth", type: .derText, order: 10, value: "+2 Resources, can be taken multiple times", ivalue: 2, mandatory: false),

            "som": Element("Stillness of Mind", type: .derText, order: 201, value: "Take an action to immediately remove a mental effect - fear, charm, etc. Or spend a fortune to remove it instantly", ivalue: 2, mandatory: false, req: "ascet2"),
            "flykick": Element("Flying Kick", type: .derText, order: 202, value: "Kick attack which takes 2 actions, automatically gains a bonus effect", ivalue: 2, mandatory: false, req: "ascet2"),
            "actionasc": Element("Action (Ascetic)", type: .derText, order: 203, value: "+1 Action per round", ivalue: 2, mandatory: false, req: "ascet3"),
            "withstand": Element("Withstand", type: .derText, order: 204, value: "When your Might defence is attacked, you can instead take an action to make a defence roll using double your Might", ivalue: 2, mandatory: false, req: "ascet4"),
            "sturdy": Element("Sturdy", type: .derText, order: 205, value: "+5 Maximum Hit Points", ivalue: 2, mandatory: false, req: "ascet5"),
            "featsos": Element("Feats of Strength", type: .derText, order: 206, value: "Extra d10 on brute might rolls, such as moving or lifting large objects or bending bars", ivalue: 2, mandatory: false, req: "ascet6"),
            "deadlyhands": Element("Deadly Hands", type: .derText, order: 207, value: "When using unarmed attacks, any dice that rolls a 10 gain a bonus result", ivalue: 2, mandatory: false, req: "ascet7"),
            "cunning": Element("Cunning", type: .derText, order: 301, value: "Each round, if you are not surprised, and if your first action is to move or hide it does not count against your actions for the round", ivalue: 2, mandatory: false, req: "crimi2"),
            "sneakattack": Element("Sneak Attack", type: .derText, order: 302, value: "When you attack someone who is unaware of you, roll an extra d10", ivalue: 2, mandatory: false, req: "crimi2"),
            "dodge": Element("Dodge", type: .derText, order: 303, value: "+1 to Dodge skill", ivalue: 2, mandatory: false, req: "crimi3"),
            "careful": Element("Careful", type: .derText, order: 304, value: "Extra d10 on rolls to detect traps and pick mechanical locks", ivalue: 2, mandatory: false, req: "crimi4"),
            "movementcr": Element("Movement", type: .derText, order: 305, value: "+1 Movement", ivalue: 2, mandatory: false, req: "crimi5"),
            "dangersense": Element("Danger Sense", type: .derText, order: 306, value: "When there is danger, you may make a perception roll (base target 15) even if you would not normally be able to sense anything", ivalue: 2, mandatory: false, req: "crimi6"),
            "befuddle": Element("Befuddle", type: .derText, order: 307, value: "Extra d10 on Personal rolls when you tell an outrageous lie", ivalue: 2, mandatory: false, req: "crimi7"),
        ]
            
    ]
    
    let backgrounds = ["Apoclast", "Champion", "Companion", "Fallen", "Machine", "Outcast", "Resurrected", "Sleeper", "Transhuman", "Utopan"]
    
    func setDerived(_ character: Character) {
        let sec_main = character.elements["main"]!
        let sec_attr = character.elements["attributes"]!
        let sec_der = character.elements["derived"]!
        let sec_ski = character.elements["skills"]!
        let sec_tra = character.elements["traits"]!
        
        sec_main["level"]!.dvalue = Int(ceil(Double(sec_main["devpoints"]!.ivalue) / 20.0))
        
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
        if sec_der["hit points"]!.ivalue == nil {
            sec_der["hit points"]!.ivalue = sec_der["hit points"]!.dvalue
        }
        sec_der["actions per round"]!.dvalue = 2 + (sec_tra["bac2"]?.name == "+5 HP" ? 5 : 0)
        sec_der["initiative"]!.dvalue = sec_attr["finesse"]!.dvalue + sec_attr["intellect"]!.dvalue
        sec_der["carry"]!.dvalue = (sec_attr["might"]!.dvalue * 2) + 5
        if sec_der["carry"]!.ivalue == nil {
            sec_der["carry"]!.ivalue = sec_der["carry"]!.dvalue
        }
        sec_der["resources"]!.dvalue = 6 + (sec_tra["bac3"]?.name == "Resources" ? 2 : 0)
        sec_der["might def"]!.dvalue = sec_attr["might"]!.dvalue + 8 + (sec_tra["bac1"]?.name == "+1 All defences" ? 1 : 0)
        sec_der["finesse def"]!.dvalue = sec_attr["finesse"]!.dvalue + 8 + (sec_tra["bac1"]?.name == "+1 All defences" ? 1 : 0)
        sec_der["intellect def"]!.dvalue = sec_attr["intellect"]!.dvalue + 8 + (sec_tra["bac1"]?.name == "+1 All defences" ? 1 : 0)
        sec_der["spirit def"]!.dvalue = sec_attr["spirit"]!.dvalue + 8 + (sec_tra["bac1"]?.name == "+1 All defences" ? 1 : 0)
        sec_der["energy"]!.dvalue = (sec_attr["spirit"]!.dvalue + sec_attr["intellect"]!.dvalue) * 5
        if sec_der["energy"]!.ivalue == nil {
            sec_der["energy"]!.ivalue = sec_der["energy"]!.dvalue
        }
        sec_der["powerslots"]!.dvalue = (sec_attr["intellect"]!.dvalue + 1) / 2

        for (key, value) in sec_ski {
            value.dvalue = value.ivalue
        }
        
        // **** add effect of traits
        
        check_traits(character)
        calc_dp(character)
    }
    
    
    func changeBackground(_ character: Character) {
        for traitkey in ["bac1", "bac2", "bac3"] {
            character.elements["traits"]?.removeValue(forKey: traitkey)
        }
        let background = character.elements["main"]!["background"]!.value!
        switch background {
        case "Apoclast":
            character.elements["traits"]!["bac1"] = Element("+1 Spirit", type: .derText, order: 101, value: "Add +1 to Spirit")
            character.elements["traits"]!["bac2"] = Element("Modified", type: .derText, order: 102, value: "Gain 1 genetic modification")
            character.elements["traits"]!["bac3"] = Element("Commanding Presence", type: .derText, order: 103, value: "extra d10 when using personal on inferiors")
        case "Champion":
            character.elements["traits"]!["bac1"] = Element("+1 Might", type: .derText, order: 101, value: "Add +1 to Might")
            character.elements["traits"]!["bac2"] = Element("+5 HP", type: .derText, order: 102, value: "Add +5 to max HP")
            character.elements["traits"]!["bac3"] = Element("Intimidation", type: .derText, order: 103, value: "Can use a combat skill as Personal")
        case "Companion":
            character.elements["traits"]!["bac1"] = Element("+1 Spirit", type: .derText, order: 101, value: "Add +1 to Spirit")
            character.elements["traits"]!["bac2"] = Element("Sense Emotion", type: .derText, order: 102, value: "Perception vf Spirit Def")
            character.elements["traits"]!["bac3"] = Element("Comfort", type: .derText, order: 103, value: "Roll Personal to remove a mental effect on somone else")
        case "Fallen":
            character.elements["traits"]!["bac1"] = Element("+1 Intellect", type: .derText, order: 101, value: "Add +1 to Intellect")
            character.elements["traits"]!["bac3"] = Element("Resources", type: .derText, order: 102, value: "+2 Resources and can start with High-tech equipment")
            character.elements["traits"]!["bac2"] = Element("Pilot", type: .derText, order: 103, value: "Extra d10 when using space / flying vehicles")
        case "Machine":
            character.elements["traits"]!["bac1"] = Element("Armoured", type: .derText, order: 101, value: "Add +2 to Armour")
            character.elements["traits"]!["bac2"] = Element("Mechanical", type: .derText, order: 102, value: "Immune to poison, does not breathe")
            character.elements["traits"]!["bac3"] = Element("Upgraded", type: .derText, order: 103, value: "Gain 1 bionic modification")
        case "Outcast":
            character.elements["traits"]!["bac1"] = Element("+1 Finesse", type: .derText, order: 101, value: "Add +1 to Finesse")
            character.elements["traits"]!["bac2"] = Element("Stalker", type: .derText, order: 102, value: "Extra d10 to Stealth in wild or abandoned structure areas")
            character.elements["traits"]!["bac3"] = Element("Adapted", type: .derText, order: 103, value: "+2 Might defence vs poison and radiation")
        case "Resurrected":
            character.elements["traits"]!["bac1"] = Element("+1 Might", type: .derText, order: 101, value: "Add +1 to Might")
            character.elements["traits"]!["bac2"] = Element("Historied", type: .derText, order: 102, value: "Extra d10 when rolling Lore about ancient knowledge")
            character.elements["traits"]!["bac3"] = Element("Resources", type: .derText, order: 103, value: "+2 Resources and can start with High-tech equipment")
        case "Sleeper":
            character.elements["traits"]!["bac1"] = Element("+1 Intellect", type: .derText, order: 101, value: "Add +1 to Intellect")
            character.elements["traits"]!["bac2"] = Element("Upgraded", type: .derText, order: 102, value: "Gain 1 bionic modification")
            character.elements["traits"]!["bac3"] = Element("Educated", type: .derText, order: 103, value: "Extra d10 when rolling Lore about structure or systems")
        case "Utopan":
            character.elements["traits"]!["bac1"] = Element("+1 All defences", type: .derText, order: 101, value: "Add +1 to all defences")
            character.elements["traits"]!["bac2"] = Element("Compliant", type: .derText, order: 102, value: "Extra d10 when rolling Personal to deceive")
            character.elements["traits"]!["bac3"] = Element("Blah", type: .derText, order: 103, value: "Insert something here")
        case "Transhuman":
            character.elements["traits"]!["bac1"] = Element("+1 Intellect", type: .derText, order: 101, value: "Add +1 to Intellect")
            character.elements["traits"]!["bac2"] = Element("Modified", type: .derText, order: 102, value: "Gain 1 genetic modification")
            character.elements["traits"]!["bac3"] = Element("Arcane", type: .derText, order: 103, value: "Extra d10 when rolling Lore about Dust")

        default:
            debugPrint("Unknown background: \(background)")
        }
        setDerived(character)
    }
    
    func calc_dp(_ character: Character) {
        var dp = 10     // background and career
        for (_, attr) in character.elements["attributes"]! {
            dp += attr.ivalue * 3
        }
        for (_, skill) in character.elements["skills"]! {
            dp += skill.ivalue
        }
        for (_, trait) in character.elements["traits"]! {
            dp += trait.ivalue ?? 0
        }
        character.elements["main"]!["devpoints"]!.dvalue = dp
    }
    
    func get_max(_ character: Character, element: Element) -> Int {
        switch element.name {
        case "Might", "Finesse", "Intellect", "Spirit":
            return character.elements["main"]!["level"]!.dvalue
        case "Hit points":
            return character.elements["derived"]!["hit points"]!.dvalue
        case "Energy":
            return character.elements["derived"]!["energy"]!.dvalue
        case "Animals", "Athletics", "Computers", "Craft", "Dodge", "Dust", "Fighting", "Lore", "Medicine", "Perception", "Personal", "Science", "Shooting", "Stealth", "Survival", "Tech", "Vehicles":
            return character.elements["attributes"]![element.value]!.dvalue
        case "Ascetic", "Criminal", "Entertainer", "Healer", "Hunter", "Marshall", "Mentalist", "Physicalist", "Rigger", "Scientist", "Soldier", "Survivor", "Tamer":
            // replace this with search through career elements
            var max = character.elements["main"]!["level"]!.dvalue!
            for (_, elem) in character.elements["careers"]! {
                if elem.name != element.name {
                    max -= elem.ivalue!
                }
            }
            return max
        default:
            return 999
        }
    }
    
    func ava_traits(_ character: Character) -> [String] {
        // returns a list of keys in (order)
        var keylist = [String]()
        for (key, elem) in allElements["traits"]!.sorted(by: { $0.value.order < $1.value.order }) {
            if let req = elem.req {
                let reqelem = String(req[..<req.index(req.startIndex, offsetBy: 5)])
                let reqval = Int(req[req.index(req.startIndex, offsetBy: 5)...])
                if reqelem == "clv" && character.elements["main"]!["level"]!.ivalue! >= reqval! {
                    keylist.append(key)
                } else {
                    if character.elements["careers"]![reqelem] != nil {
                        if character.elements["careers"]![reqelem]!.ivalue! >= reqval! {
                            keylist.append(key)
                        }
                    }
                }
            }
            else {
                keylist.append(key)
            }
        }
        return keylist
    }
    
    func check_traits(_ character: Character) {
        // remove any traits that are not qualified for
        for (key, elem) in character.elements["traits"]! {
            if let req = elem.req {
                let reqelem = String(req[..<req.index(req.startIndex, offsetBy: 5)])
                let reqval = Int(req[req.index(req.startIndex, offsetBy: 5)...])
                if reqelem == "clv" && character.elements["main"]!["level"]!.ivalue! < reqval! {
                } else {
                    if character.elements["careers"]![reqelem] == nil {
                        character.elements["traits"]!.removeValue(forKey: key)
                    } else {
                        if character.elements["careers"]![reqelem]!.ivalue! < reqval! {
                            character.elements["traits"]!.removeValue(forKey: key)
                        }
                    }
                }
            }
        }
    }
}





class Element {
    var type: ElemType
    var name: String
    var order: Int!
    var value: String!
    var ivalue: Int!
    var dvalue: Int!
    var mandatory: Bool = false
    var rolls: Bool = false
    var req: String!        // coded requirement string, only for traits atm


    init(_ name: String, type: ElemType, order: Int, value: String! = nil, ivalue: Int! = nil, mandatory: Bool = false, rolls: Bool = false, req: String! = nil) {
        self.type = type
        self.name = name
        self.order = order
        self.value = value
        self.ivalue = ivalue
        self.mandatory = mandatory
        self.rolls = rolls
        self.req = req
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






