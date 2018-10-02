//
//  UIColorExt.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 2/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(hexColor: String) {
        let red = Double(Int(hexColor[hexColor.index(hexColor.startIndex, offsetBy: 0)...hexColor.index(hexColor.startIndex, offsetBy: 1)] , radix: 16)!) / 256.0
        let blue = Double(Int(hexColor[hexColor.index(hexColor.startIndex, offsetBy: 2)...hexColor.index(hexColor.startIndex, offsetBy: 3)] , radix: 16)!) / 256.0
        let green = Double(Int(hexColor[hexColor.index(hexColor.startIndex, offsetBy: 4)...hexColor.index(hexColor.startIndex, offsetBy: 5)] , radix: 16)!) / 256.0

        self.init(red: CGFloat(red), green: CGFloat(blue), blue: CGFloat(green), alpha: 1.0)
    }
}

