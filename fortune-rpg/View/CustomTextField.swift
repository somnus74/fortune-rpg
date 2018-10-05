//
//  CustomTextField.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 2/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func awakeFromNib() {
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexColor: "3A53A5")])
        self.attributedPlaceholder = placeholder
        super.awakeFromNib()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
    }
}
