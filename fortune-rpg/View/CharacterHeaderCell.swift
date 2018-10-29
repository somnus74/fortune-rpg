//
//  CharacterHeaderCell.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 25/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import UIKit

class CharacterHeaderCell: UITableViewCell {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    var charvc: CharacterVC!
    var section: Int!
    
    @IBAction func arrowBtnPress(_ sender: Any) {
        charvc.secShowState[section] = !charvc.secShowState[section]
        charvc.tableView.reloadData()
    }
    
    @IBAction func addBtnPress(_ sender: Any) {
        charvc.selNewElement(section: System.instance.sectionKeys[section])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
