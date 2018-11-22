//
//  EquipEditView.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 19/11/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import UIKit

class ElemEditView: UIView {
    // Test for editing view
    var element: Element!
    var nameLbl: UILabel!
    var valLbl: UILabel!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.init(hexColor: "535A78")
        let viewHeightC = heightAnchor.constraint(equalToConstant: 180)
        viewHeightC.isActive = true

        switch(element.type) {
        case .derInt:
            setupDerInt()
        default:
            debugPrint("ElemEditView: element type not known")
        }
        
        nameLbl = UILabel()
        
        nameLbl.textColor = UIColor.white
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.font = UIFont(name: "Futura-Medium", size: 14.0)
        //nameLbl.numberOfLines = 3
        //nameLbl.sizeToFit()
        //nameLbl.minimumScaleFactor = 0.7
        addSubview(nameLbl)
        let nameTopC = nameLbl.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        nameTopC.isActive = true
        let nameLeftC = nameLbl.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        nameLeftC.isActive = true
        let nameWidthC = nameLbl.widthAnchor.constraint(equalToConstant: 100)
        nameWidthC.isActive = true
        nameLbl.text = "Name Unset"
        
        valLbl = UILabel()
        valLbl.translatesAutoresizingMaskIntoConstraints = false
        valLbl.font = UIFont(name: "Futura-Medium", size: 14.0)
        addSubview(valLbl)
        let valTopC = valLbl.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        valTopC.isActive = true
        let valLeftC = valLbl.leftAnchor.constraint(equalTo: nameLbl.rightAnchor, constant: 8)
        valLeftC.isActive = true
        let valRightC = valLbl.rightAnchor.constraint(equalTo: rightAnchor, constant: 8)
        valRightC.isActive = true
        valLbl.text = "Value Unset"
        
        
    }
    
    func setupDerInt() {
        
    }
    
}
