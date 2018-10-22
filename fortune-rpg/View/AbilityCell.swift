//
//  AbilityCell.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 6/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import UIKit

class AbilityCell: UITableViewCell {

    // outlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var valLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
