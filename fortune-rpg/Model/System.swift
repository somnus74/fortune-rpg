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
  
    let sectionKeys = ["main", "attributes", "derived", "careers", "skills", "traits", "equipment", "actions"]
    let sectionNames = ["Main", "Attributes", "Derived Attributes", "Careers", "Skills", "Traits", "Equipment", "Actions"]

    var allElements: Dictionary<String, Dictionary<String, Element>> = [
        "main": [
            "name" : Element("Name", type: .freetext, order: 1, value: "init name", mandatory: true),
            "player" : Element("Player", type: .derText, order: 2, value: AuthService.instance.userName, mandatory: true),
            "description" : Element("Description", type: .freetext, order: 4, value: "", mandatory: true),
            "level" : Element("Character Level", type: .derInt, order: 5, mandatory: true),
            "background" : Element("Background", type: .selText, order: 6, value: "Apoclast", mandatory: true),
            "devpoints" : Element("Development Points", type: .freeInt, order: 7, ivalue: 60, mandatory: true)
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
            "apr": Element("Actions per round", type: .derInt, order: 4, mandatory: true),
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

            "fightingas": Element("Fighting", type: .derText, order: 201, value: "+1 to Fighting skill", ivalue: 0, mandatory: false, req: "ascet1"),
            "movementas": Element("Movement", type: .derText, order: 202, value: "+1 to Movement", ivalue: 0, mandatory: false, req: "ascet1"),
            "ruggedas": Element("Rugged", type: .derText, order: 203, value: "Extra d10 on survival in wild or abandoned areas", ivalue: 0, mandatory: false, req: "ascet1"),
            "bracefori": Element("Brace For Impact", type: .derText, order: 204, value: "When in an area of effect, you can make a Survival roll instead of the normal defence roll. You do not have to move", ivalue: 0, mandatory: false, req: "ascet1"),
            "stillness": Element("Stillness of Mind", type: .derText, order: 205, value: "Take an action to immediately remove a mental effect - fear, charm, etc. Or spend a fortune to remove it instantly", ivalue: 2, mandatory: false, req: "ascet2"),
            "flykick": Element("Flying Kick", type: .derText, order: 206, value: "Kick attack which takes 2 actions, automatically gains a bonus effect", ivalue: 2, mandatory: false, req: "ascet2"),
            "actionas": Element("Action (Ascetic)", type: .derText, order: 207, value: "+1 Action per round", ivalue: 2, mandatory: false, req: "ascet3"),
            "withstand": Element("Withstand", type: .derText, order: 208, value: "When your Might defence is attacked, you can instead take an action to make a defence roll using double your Might", ivalue: 2, mandatory: false, req: "ascet4"),
            "sturdyas": Element("Sturdy", type: .derText, order: 209, value: "+5 Maximum Hit Points", ivalue: 2, mandatory: false, req: "ascet5"),
            "featsos": Element("Feats of Strength", type: .derText, order: 210, value: "Extra d10 on brute might rolls, such as moving or lifting large objects or bending bars", ivalue: 2, mandatory: false, req: "ascet6"),
            "deadlyhands": Element("Deadly Hands", type: .derText, order: 211, value: "When using unarmed attacks, any dice that rolls a 10 gain a bonus result", ivalue: 2, mandatory: false, req: "ascet7"),

            "stealthcr": Element("Stealth", type: .derText, order: 301, value: "+1 to Stealth skill", ivalue: 2, mandatory: false, req: "crimi1"),
            "findefcr": Element("Finesse Defence", type: .derText, order: 302, value: "+1 Finesse defence", ivalue: 2, mandatory: false, req: "crimi1"),
            "lockpickingcr": Element("Lockpicking", type: .derText, order: 303, value: "Extra 1d10 on Tech: Lockpicking", ivalue: 2, mandatory: false, req: "crimi1"),
            "quickcr": Element("Quick", type: .derText, order: 304, value: "Extra 1d10 on initiative rolls", ivalue: 2, mandatory: false, req: "crimi1"),
            "cunning": Element("Cunning", type: .derText, order: 305, value: "Each round, if you are not surprised, and if your first action is to move or hide it does not count against your actions for the round", ivalue: 2, mandatory: false, req: "crimi2"),
            "sneakattack": Element("Sneak Attack", type: .derText, order: 306, value: "When you attack someone who is unaware of you, roll an extra d10", ivalue: 2, mandatory: false, req: "crimi2"),
            "dodgecr": Element("Dodge", type: .derText, order: 307, value: "+1 to Dodge skill", ivalue: 2, mandatory: false, req: "crimi3"),
            "careful": Element("Careful", type: .derText, order: 308, value: "Extra d10 on rolls to detect traps and pick mechanical locks", ivalue: 2, mandatory: false, req: "crimi4"),
            "movementcr": Element("Movement", type: .derText, order: 309, value: "+1 Movement", ivalue: 2, mandatory: false, req: "crimi5"),
            "dangersense": Element("Danger Sense", type: .derText, order: 310, value: "When there is danger, you may make a perception roll (base target 15) even if you would not normally be able to sense anything", ivalue: 2, mandatory: false, req: "crimi6"),
            "befuddle": Element("Befuddle", type: .derText, order: 311, value: "Extra d10 on Personal rolls when you tell an outrageous lie", ivalue: 2, mandatory: false, req: "crimi7"),
            
            "personalen": Element("Personal", type: .derText, order: 401, value: "+1 to Personal skill", ivalue: 2, mandatory: false, req: "enter1"),
            "fortuneen": Element("Fortune", type: .derText, order: 402, value: "Gain 1 maximum Fortune", ivalue: 2, mandatory: false, req: "enter1"),
            "performen": Element("Perform", type: .derText, order: 403, value: "Extra 1d10 on Craft: Performance", ivalue: 2, mandatory: false, req: "enter1"),
            "inspiration": Element("Inspiration", type: .derText, order: 404, value: "Can use your fortune on the rolls of  others as long as they can see and hear you", ivalue: 2, mandatory: false, req: "enter1"),
            "distract": Element("Distract", type: .derText, order: 405, value: "Take an action to distract someone (Personal vs Spirit defence). If successful they take no action for a round and cannot make other perception checks. Cannot be used if the target is in combat.", ivalue: 2, mandatory: false, req: "enter2"),
            "captivating": Element("Captivating", type: .derText, order: 406, value: "Extra d10 on rolls to perform (Craft or Personal)", ivalue: 2, mandatory: false, req: "enter2"),
            "loreen": Element("Lore", type: .derText, order: 407, value: "+1 to Lore skill", ivalue: 2, mandatory: false, req: "enter3"),
            "adjuvant": Element("Adjuvant", type: .derText, order: 408, value: "When you use inspiration, you may spend an extra fortune to give them an extra d10 on the roll", ivalue: 2, mandatory: false, req: "enter4"),
            "fortuneen2": Element("Fortune 2", type: .derText, order: 409, value: "Gain 1 maximum Fortune", ivalue: 2, mandatory: false, req: "enter5"),
            "sitawareness": Element("Situational Awareness", type: .derText, order: 410, value: "When you are talking to the opposition and combat breaks out, you may take an action before anything else happens", ivalue: 2, mandatory: false, req: "enter6"),
            "wardancer": Element("War Dancer", type: .derText, order: 411, value: "You can use distract in combat, it affects all enemies who are adjacent to you", ivalue: 2, mandatory: false, req: "enter7"),
            
            "medicinehe": Element("Medicine", type: .derText, order: 501, value: "+1 to Medicine skill", ivalue: 2, mandatory: false, req: "heale1"),
            "resourceshe": Element("Resource", type: .derText, order: 502, value: "+2 Resources", ivalue: 2, mandatory: false, req: "heale1"),
            "biologisthe": Element("Biologist", type: .derText, order: 503, value: "Extra d10 on Science: Biology", ivalue: 2, mandatory: false, req: "heale1"),
            "imphealing": Element("Improved Healing", type: .derText, order: 504, value: "Whenever you use a healing item, add your Intellect to the Hit Points recovered", ivalue: 2, mandatory: false, req: "heale1"),
            "laylow": Element("Lay Low", type: .derText, order: 505, value: "If you have not attacked this combat you have +2 defence against ranged attacks", ivalue: 2, mandatory: false, req: "heale2"),
            "emergencycare": Element("Emergency Care", type: .derText, order: 506, value: "Extra d10 on rolls to stabilise or resuscitate", ivalue: 2, mandatory: false, req: "heale2"),
            "techhe": Element("Tech", type: .derText, order: 507, value: "+1 Tech skill", ivalue: 2, mandatory: false, req: "heale3"),
            "quickrevive": Element("Quick Revive", type: .derText, order: 508, value: "You can resuscitate an incapacitated (target 15) or stunned (target 12) person in only one action. This does not heal them and will not prevent them from dying.", ivalue: 2, mandatory: false, req: "heale4"),
            "fortunehe": Element("Fortune", type: .derText, order: 509, value: "+1 Fortune", ivalue: 2, mandatory: false, req: "heale5"),
            "pathologist": Element("Pathologist", type: .derText, order: 510, value: "Extra d10 on science rolls relating to biology", ivalue: 2, mandatory: false, req: "heale6"),
            "vitals": Element("Vitals", type: .derText, order: 511, value: "When you hit with a called shot against a biological opponent you gain an additional bonus result", ivalue: 2, mandatory: false, req: "heale7"),

            "shootinghu": Element("Shooting", type: .derText, order: 601, value: "+1 to Shooting skill", ivalue: 2, mandatory: false, req: "hunte1"),
            "movementhu": Element("Movement", type: .derText, order: 602, value: "+1 to Movement", ivalue: 2, mandatory: false, req: "hunte1"),
            "trackinghu": Element("Tracking", type: .derText, order: 603, value: "Extra d10 on Perception: Tracking", ivalue: 2, mandatory: false, req: "hunte1"),
            "preciseshot": Element("Precise Shot", type: .derText, order: 604, value: "You can make single called shots with a ranged weapon without aiming", ivalue: 2, mandatory: false, req: "hunte1"),
            "favenemy": Element("Favoured Enemy", type: .derText, order: 605, value: "+1 to tracking, attack and knowledge rolls about 1 type of enemy - arthropods, aquatic, humans, mammals, mechanicals, transgenics", ivalue: 2, mandatory: false, req: "hunte2"),
            "trapper": Element("Trapper", type: .derText, order: 606, value: "Extra d10 on rolls to set traps", ivalue: 2, mandatory: false, req: "hunte2"),
            "actionhu": Element("Action", type: .derText, order: 607, value: "+1 Action per round", ivalue: 2, mandatory: false, req: "hunte3"),
            "stalker": Element("Stalker", type: .derText, order: 608, value: "Extra d10 on stealth against animals / enemies with 0 ot 1 INT", ivalue: 2, mandatory: false, req: "hunte4"),
            "sturdyhu": Element("Sturdy", type: .derText, order: 609, value: "+5 maximum Hit Points", ivalue: 2, mandatory: false, req: "hunte5"),
            "specialised": Element("Specialised", type: .derText, order: 610, value: "Your favoured enemy bonus rises to +2", ivalue: 2, mandatory: false, req: "hunte6"),
            
            "fightingma": Element("Fighting", type: .derText, order: 701, value: "+1 Fighting skill", ivalue: 2, mandatory: false, req: "marsh1"),
            "sturdyma": Element("Sturdy", type: .derText, order: 702, value: "+5 maximum Hit Points", ivalue: 2, mandatory: false, req: "marsh1"),
            "readpeople": Element("Read People", type: .derText, order: 703, value: "Extra d10 on Perception: Read people", ivalue: 2, mandatory: false, req: "marsh1"),
            "ianthelaw": Element("I am the Law", type: .derText, order: 704, value: "Personal roll vs SPR defence, on success causes target to do nothing for a round", ivalue: 2, mandatory: false, req: "marsh1"),
            "fulldefence": Element("Full Defence", type: .derText, order: 705, value: "Take an action to focus on defence, your parries have a +2 bonus for the rest of the round", ivalue: 2, mandatory: false, req: "marsh2"),
            "lawyer": Element("Lawyer", type: .derText, order: 706, value: "Extra d10 on Lore: Law", ivalue: 2, mandatory: false, req: "marsh2"),
            "actionma": Element("Action", type: .derText, order: 707, value: "+1 Action per round", ivalue: 2, mandatory: false, req: "marsh3"),
            "bodylang": Element("Body Language", type: .derText, order: 708, value: "Extra d10 on perception rolls to read people", ivalue: 2, mandatory: false, req: "marsh4"),
            "shooting": Element("Shooting", type: .derText, order: 709, value: "+1 to Shooting skill", ivalue: 2, mandatory: false, req: "marsh5"),
            "paintol": Element("Pain Tolerance", type: .derText, order: 710, value: "You can take actions (but not reactions) and move at half speed when you are less than 0 HP", ivalue: 2, mandatory: false, req: "marsh6"),
            "commanding": Element("Commanding", type: .derText, order: 711, value: "When you use I am the Law on someone they have -1d10 to all actions until the end of the turn", ivalue: 2, mandatory: false, req: "marsh7"),
            
            "dustme": Element("Dust", type: .derText, order: 801, value: "+1 to Dust skill", ivalue: 2, mandatory: false, req: "menta1"),
            "powslotme": Element("Power Slot", type: .derText, order: 802, value: "+1 Power slot", ivalue: 2, mandatory: false, req: "menta1"),
            "dustlore": Element("Dust Lore", type: .derText, order: 803, value: "Extra d10 on Lore: Dust", ivalue: 2, mandatory: false, req: "menta1"),
            "sensedust": Element("Sense Dust", type: .derText, order: 804, value: "You notice nearby sources of dust or containers of dust within a range of your Spirit in metres. This does not require a roll, but you can attempt a perception roll to determine more information", ivalue: 2, mandatory: false, req: "menta1"),
            "dustaffme": Element("Dust Affinity", type: .derText, order: 805, value: "Choose a colour - White, Green or Blue dust. You have +2 to use this type of dust, and +2 defence against effects of that colour", ivalue: 2, mandatory: false, req: "menta2"),
            "maname": Element("Mana", type: .derText, order: 806, value: "+5 maximum Energy", ivalue: 2, mandatory: false, req: "menta2"),
            "powslotme2": Element("Power Slot", type: .derText, order: 807, value: "+1 Power Slot", ivalue: 2, mandatory: false, req: "menta3"),
            "extendpower": Element("Extend Power", type: .derText, order: 808, value: "Double the range or duration of a power by expending double the amount of mana", ivalue: 2, mandatory: false, req: "menta4"),
            "loreme": Element("Lore", type: .derText, order: 809, value: "+1 to Lore skill", ivalue: 2, mandatory: false, req: "menta5"),
            "mentaldef": Element("Mental Defence", type: .derText, order: 810, value: "When an attack targets Spirit, action: defend with Meta-discipline + amount of Mana spent (min 1, max INT)", ivalue: 2, mandatory: false, req: "menta6"),
            
            "dustph": Element("Dust", type: .derText, order: 901, value: "+1 to Dust skill", ivalue: 2, mandatory: false, req: "physi1"),
            "manaph": Element("Mana", type: .derText, order: 902, value: "+5 to maximum Energy", ivalue: 2, mandatory: false, req: "physi1"),
            "dustdevices": Element("Dust Devices", type: .derText, order: 903, value: "Extra d10 on Tech: Dust devices", ivalue: 2, mandatory: false, req: "physi1"),
            "increasepower": Element("Increase Power", type: .derText, order: 904, value: "Spend an extra 2 mana to increase the damage done by a power by your Intellect", ivalue: 2, mandatory: false, req: "physi1"),
            "dustaffph": Element("Dust Affinity", type: .derText, order: 905, value: "Choose a colour - Red, Yellow or Black dust. You have +2 to use this type of dust, and +2 defence against effects of that colour", ivalue: 2, mandatory: false, req: "physi2"),
            "powslotph": Element("Power Slot", type: .derText, order: 906, value: "+1 Power Slot", ivalue: 2, mandatory: false, req: "physi2"),
            "manaph2": Element("Mana", type: .derText, order: 907, value: "+5 maximum Energy", ivalue: 2, mandatory: false, req: "physi3"),
            "humanbatt": Element("Human Battery", type: .derText, order: 908, value: "You can recharge a dust device by expending 2 Mana per unit of dust required", ivalue: 2, mandatory: false, req: "physi4"),
            "techph": Element("Tech", type: .derText, order: 909, value: "+1 to Tech skill", ivalue: 2, mandatory: false, req: "physi5"),
            "physicaldef": Element("Physical Defence", type: .derText, order: 910, value: "When targeted by a physical attack, action: defend with Meta-discipline + amount of Mana spent (min 1, max INT)", ivalue: 2, mandatory: false, req: "physi6"),
            
            "vehiclesri": Element("Vehicles", type: .derText, order: 1001, value: "+1 to Vehicles skill", ivalue: 2, mandatory: false, req: "rigge1"),
            "sturdyri": Element("Sturdy", type: .derText, order: 1002, value: "+5 to maximum Hit Points", ivalue: 2, mandatory: false, req: "rigge1"),
            "repair": Element("Repair", type: .derText, order: 1003, value: "Extra d10 on Craft: Repair", ivalue: 2, mandatory: false, req: "rigge1"),
            "ride": Element("Ride", type: .derText, order: 1004, value: "Gain 4 resource points to use on vehicles only", ivalue: 2, mandatory: false, req: "rigge1"),
            "detectwe": Element("Detect Weakness", type: .derText, order: 1005, value: "You are able to judge the weak points of an object or enemy, determining which parts are vulnerable or may be used to easily cause damage. Requires an action and clear observation of the target", ivalue: 2, mandatory: false, req: "rigge2"),
            "vehicleex": Element("Vehicle Expert", type: .derText, order: 1006, value: "Roll an extra d10 on Lore related to vehicles", ivalue: 2, mandatory: false, req: "rigge2"),
            "techri": Element("Tech", type: .derText, order: 1007, value: "+1 to Tech skill", ivalue: 2, mandatory: false, req: "rigge3"),
            "turndam": Element("Turn Damage", type: .derText, order: 1008, value: "When your vehicle is hit, make a defence roll using Vehicles. If you are successful the vehicle's armour is doubled for the purposes of this attack", ivalue: 2, mandatory: false, req: "rigge4"),
            "actionri": Element("Action", type: .derText, order: 1009, value: "+1 Action per round", ivalue: 2, mandatory: false, req: "rigge5"),
            "damagearm": Element("Damage Armour", type: .derText, order: 1010, value: "Make a called shot to damage a target's armour - reduce armour in the part targeted by penetrating damage instead of applying damage normally", ivalue: 2, mandatory: false, req: "rigge6"),
            "targetwe": Element("Target Weakness", type: .derText, order: 1011, value: "You can immediately identify the most lightly armoured location of a vehicle or other large target. You penalties to hit this location are reduced by 2", ivalue: 2, mandatory: false, req: "rigge7"),
            
            "sciencesc": Element("Science", type: .derText, order: 1101, value: "+1 to Science skill", ivalue: 2, mandatory: false, req: "scien1"),
            "sprdefsc": Element("Spirit Defence", type: .derText, order: 1102, value: "+2 to Spirit Defence", ivalue: 2, mandatory: false, req: "scien1"),
            "academic": Element("Academic", type: .derText, order: 1103, value: "Extra d10 on Lore: Academic", ivalue: 2, mandatory: false, req: "scien1"),
            "research": Element("Research", type: .derText, order: 1104, value: "If you have access to a connected system you can have an extra d10 to any Perception roll to find information", ivalue: 2, mandatory: false, req: "scien1"),
            "speedhack": Element("Speed Hack", type: .derText, order: 1105, value: "You can carry out computer: Hacking or Tech: sabotage tasks in rounds instead of minutes", ivalue: 2, mandatory: false, req: "scien2"),
            "observant": Element("Observant", type: .derText, order: 1106, value: "Extra d10 on perception when you take a task action and have instruments available", ivalue: 2, mandatory: false, req: "scien2"),
            "fortunesc": Element("Fortune", type: .derText, order: 1107, value: "+1 to maximum Fortune", ivalue: 2, mandatory: false, req: "scien3"),
            "overcharge": Element("Overcharge", type: .derText, order: 1108, value: "As a task action, enhance the operation of a mechanical or electrical device. The effects will vary, but will be equivalent to a +2 bonus or +1d6 damage in normal use. The device will require repair after one scene, and if a critical failure is rolled it may be destroyed spectacularly.", ivalue: 2, mandatory: false, req: "scien4"),
            "expert": Element("Expert", type: .derText, order: 1109, value: "Extra d10 on one field of science", ivalue: 2, mandatory: false, req: "scien5"),
            "discerning": Element("Discerning", type: .derText, order: 1110, value: "Make a Science roll to deduce that a person is telling lies, or falsehoods in written material", ivalue: 2, mandatory: false, req: "scien6"),
            
            "shootingso": Element("Shooting", type: .derText, order: 1201, value: "+1 to Shooting skill", ivalue: 2, mandatory: false, req: "soldi1"),
            "sturdyso": Element("Sturdy", type: .derText, order: 1202, value: "+5 maximum Hit Points", ivalue: 2, mandatory: false, req: "soldi1"),
            "combatlore": Element("Combat Lore", type: .derText, order: 1203, value: "Extra d10 on Lore: Combat", ivalue: 2, mandatory: false, req: "soldi1"),
            "ambushso": Element("Ambush", type: .derText, order: 1204, value: "When you start combat without being surprised, gain an extra attack in the first round of combat", ivalue: 2, mandatory: false, req: "soldi1"),
            "shakeitoff": Element("Shake it off", type: .derText, order: 1205, value: "1 action, Spend a fortune to recover 1d10+MGT hit points", ivalue: 2, mandatory: false, req: "soldi2"),
            "sizeup": Element("Size Up", type: .derText, order: 1206, value: "Extra d10 on perception rolls to assess an opponent or tactical situation", ivalue: 2, mandatory: false, req: "soldi2"),
            "actionso": Element("Action", type: .derText, order: 1207, value: "+1 Action per round", ivalue: 2, mandatory: false, req: "soldi3"),
            "intercept": Element("Intercept Strike", type: .derText, order: 1208, value: "When someone adjacent to you is attacked, you may move to be hit by the blow instead by making a dodge roll against the attack value. This takes one action (as a reaction), however you may also use a reaction to parry the attack if possible", ivalue: 2, mandatory: false, req: "soldi4"),
            "quickso": Element("Quick", type: .derText, order: 1209, value: "Extra 1d10 on initiative rolls", ivalue: 2, mandatory: false, req: "soldi5"),
            "vicious": Element("Vicious", type: .derText, order: 1210, value: "If your attack roll has a dice with a 10, gain a bonus result", ivalue: 2, mandatory: false, req: "soldi6"),
            "movementso": Element("Movement", type: .derText, order: 1211, value: "+1 Movement", ivalue: 2, mandatory: false, req: "soldi7"),
            
            "survivalsu": Element("Survival", type: .derText, order: 1301, value: "+1 to Survival skill", ivalue: 2, mandatory: false, req: "survi1"),
            "quicksu": Element("Quick", type: .derText, order: 1302, value: "Extra 1d10 on initiative rolls", ivalue: 2, mandatory: false, req: "survi1"),
            "trapknow": Element("Trap Knowledge", type: .derText, order: 1303, value: "Extra d10 on Perception: Traps and Hazards", ivalue: 2, mandatory: false, req: "survi1"),
            "adrenalboost": Element("Adrenal Boost", type: .derText, order: 1304, value: "On your turn, you can use adrenal boost as a bonus action. While boost is active, you have +2 to strength checks, melee damage and move. You cannot use Mind or Spirit skills while boosted. The boost lasts for 1 minute / 6 rounds or until you are incapacitated. Recharges on long rest.", ivalue: 2, mandatory: false, req: "survi1"),
            "fulldodge": Element("Full Dodge", type: .derText, order: 1305, value: "You devote all your attention to removing yourself from danger. Make a dodge roll and make your normal move, the dodge roll applies as a defence to any attack made against you until the end of the round. This requires 2 actions, and can be used as a reaction", ivalue: 2, mandatory: false, req: "survi2"),
            "scavenger": Element("Scavenger", type: .derText, order: 1306, value: "Roll an extra d10 on Tech rolls related to found junk and scavenging", ivalue: 2, mandatory: false, req: "survi2"),
            "sturdysu": Element("Sturdy", type: .derText, order: 1307, value: "+5 Hit points", ivalue: 2, mandatory: false, req: "survi3"),
            "cautious": Element("Cautious", type: .derText, order: 1308, value: "When you roll dodge against a trap or natural hazard, roll an extra d10", ivalue: 2, mandatory: false, req: "survi4"),
            "actionsu": Element("Action", type: .derText, order: 1309, value: "+1 Action per round", ivalue: 2, mandatory: false, req: "survi5"),
            "avoidance": Element("Avoidance", type: .derText, order: 1310, value: "While you are using adrenal boost you have +2 to FIN defence and Dodge", ivalue: 2, mandatory: false, req: "survi6"),
            
            "animalsta": Element("Animals", type: .derText, order: 1401, value: "+1 to Animals skill", ivalue: 2, mandatory: false, req: "tamer1"),
            "movementta": Element("Movement", type: .derText, order: 1402, value: "+1 to Movement", ivalue: 2, mandatory: false, req: "tamer1"),
            "tracking": Element("Tracking", type: .derText, order: 1403, value: "Extra d10 on Survival: Tracking", ivalue: 2, mandatory: false, req: "tamer1"),
            "animalc": Element("Animal Companion", type: .derText, order: 1404, value: "You have an animal companion, chosen from the following: Cat, Dog, Parrot, Rat", ivalue: 2, mandatory: false, req: "tamer1"),
            "obedience": Element("Obedience", type: .derText, order: 1405, value: "Your animal companion gains +1 to any rolls it makes", ivalue: 2, mandatory: false, req: "tamer2"),
            "vet": Element("Vet", type: .derText, order: 1406, value: "Roll an extra d10 for medicine rolls related to animals", ivalue: 2, mandatory: false, req: "tamer2"),
            "survivalta": Element("Survival", type: .derText, order: 1407, value: "+1 Survival skills", ivalue: 2, mandatory: false, req: "tamer3"),
            "animalc2": Element("Animal Companion 2", type: .derText, order: 1408, value: "Wolf, Bear, Eagle, etc.", ivalue: 2, mandatory: false, req: "tamer4"),
            "sturdyduo": Element("Sturdy Duo", type: .derText, order: 1409, value: "+5 maximum HP for you and your animal companion", ivalue: 2, mandatory: false, req: "tamer5"),
            "teamwork": Element("Teamwork", type: .derText, order: 1410, value: "When you attack a target in melee at the same time as your companion, instead of the companion’s attack you can attack with an extra 1d10", ivalue: 2, mandatory: false, req: "tamer6"),
            "advancedtr": Element("Advanced Training", type: .derText, order: 1411, value: "You can give your animal companion a trait from another class, treat their attack bonus as their level", ivalue: 2, mandatory: false, req: "tamer7"),

        ],
        "equipment": [String: Element](),
        "actions": [String: Element]()
            
    ]
    
    let backgrounds = ["Apoclast", "Champion", "Companion", "Fallen", "Machine", "Outcast", "Resurrected", "Sleeper", "Transhuman", "Utopan"]
    
    func setDerived(_ character: Character) {
        debugPrint("running setDerived on character \(character.documentId ?? "nil")")
        debugPrint("number of traits = \(character.elements["traits"]!.count)")
        let sec_main = character.elements["main"]!
        let sec_attr = character.elements["attributes"]!
        let sec_car = character.elements["careers"]!
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
        sec_der["hit points"]!.dvalue = (sec_attr["might"]!.dvalue + sec_attr["spirit"]!.dvalue) * 5 + 10 + (sec_tra["bac2"]?.name == "+5 HP" ? 5 : 0)
        if sec_der["hit points"]!.ivalue == nil {
            sec_der["hit points"]!.ivalue = sec_der["hit points"]!.dvalue
        }
        sec_der["apr"]!.dvalue = 2
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

        check_traits(character)
        for (ckey, career) in sec_car {
            if career.ivalue > 0 {
                for (tkey, trait) in allElements["traits"]! {
                    if let req = trait.req {
                        let reqelem = String(req[..<req.index(req.startIndex, offsetBy: 5)])
                        let reqval = Int(req[req.index(req.startIndex, offsetBy: 5)...])
                        if (reqelem == ckey) && (reqval == 1) {
                            character.elements["traits"]![tkey] = trait
                        }
                    }
                }
            }
        }
        debugPrint("number of traits = \(character.elements["traits"]!.count)")

        for (_, value) in sec_ski {
            value.dvalue = value.ivalue
        }
        
        // **** add effect of traits
        for (key, trait) in character.elements["traits"]! {
            switch key {
            case "action", "actionas", "actionhu", "actionma", "actionri", "actionso", "actionsu":
                sec_der["apr"]?.dvalue += 1
            case "luck", "extreme luck", "fortuneen", "fortuneen2", "fortunehe", "fortunesc":
                sec_der["fortune"]?.dvalue += 1
            case "movement", "movementas", "movementcr", "movementhu", "movementso":
                sec_der["movement"]?.dvalue += 1
            case "mule":
                sec_der["carry"]?.dvalue += 2
            case "wealth", "resourceshe":
                sec_der["resources"]?.dvalue += 2
            case "sturdyas", "sturdyhu", "sturdyma", "sturdyri", "sturdyso", "sturdysu":
                sec_der["hit points"]?.dvalue += 2
            case "findefcr":
                sec_der["finesse def"]?.dvalue += 1
            case "sprdefsc":
                sec_der["spirit def"]?.dvalue += 2
            case "powslotme", "powslotme2", "powslotph":
                sec_der["powerslots"]?.dvalue += 1
            case "maname", "manaph", "manaph2":
                sec_der["energy"]?.dvalue += 5      // needs to be ivalue?


            default:
                for (_, skill) in sec_ski {
                    if trait.name == skill.name {
                        skill.dvalue += 1
                    }
                }
                // trait has no effect
                _ = 1
            }
        }
        
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
        //setDerived(character)
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
                if reqelem == "level" && character.elements["main"]!["level"]!.dvalue! >= reqval! {
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
                if reqelem == "level" && character.elements["main"]!["level"]!.ivalue! < reqval! {
                    character.elements["traits"]!.removeValue(forKey: key)
                } else {
                    if character.elements["careers"]![reqelem] == nil {
                    } else {
                        if character.elements["careers"]![reqelem]!.ivalue! < reqval! {
                            character.elements["traits"]!.removeValue(forKey: key)
                        }
                    }
                }
            }
        }
    }
    
    func add_equip(_ character: Character) {
        character.equip_num += 1
        let new_equip = Element("", type: .freetext, order: character.equip_num, value: "", ivalue: character.equip_num)
        character.elements["equipment"]!["equip\(character.equip_num)"] = new_equip
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






