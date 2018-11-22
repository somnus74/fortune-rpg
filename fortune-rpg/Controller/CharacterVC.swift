//
//  CharacterVC.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 5/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import UIKit

class CharacterVC: UIViewController {
    
    // outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var valLbl: UILabel!
    @IBOutlet weak var valTxt: UITextField!
    @IBOutlet weak var ivalTxt: UITextField!
    @IBOutlet weak var dvalLbl: UILabel!
    @IBOutlet weak var ivalStepper: UIStepper!
    @IBOutlet weak var editingView: UIView!
    @IBOutlet weak var selPicker: UIPickerView!
    @IBOutlet weak var inputViewBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var rollBtnStack: UIStackView!
    
    var newEditView: UIView!
    
    
    let otherPicker = UIPickerView()
    
    var character: Character!
    var curElement: Element!
    var secShowState = [Bool]()
    var selPickerSec: String!
    var pickerSelections = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        valTxt.delegate = self
        ivalTxt.delegate = self
        selPicker.delegate = self
        //selPicker.dataSource = self
        otherPicker.delegate = self
        
        nameLbl.isHidden = true
        valLbl.isHidden = true
        valTxt.isHidden = true
        ivalTxt.isHidden = true
        ivalTxt.addDoneCancelToolbar(onDone: (target: self, action: #selector(txtDoneButton)))
        dvalLbl.isHidden = true
        ivalStepper.isHidden = true
        ivalStepper.isEnabled = false
        selPicker.isHidden = true
        rollBtnStack.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        for _ in System.instance.sectionKeys {
            secShowState.append(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        character.update_all()
        tableView.reloadData()
        title = character.elements["main"]!["name"]!.value
    }

    func setupElemView(_ element: Element) {
        if element.type == .freetext {
            editingView.isHidden = true
            newEditView = EquipEditView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            view.addSubview(newEditView)
            let editHeightC = newEditView.heightAnchor.constraint(equalToConstant: 180)
            editHeightC.isActive = true
            let editBotC = newEditView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1.0 * (tabBarController?.tabBar.frame.size.height ?? 0))
            editBotC.isActive = true
            let editLeftC = newEditView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
            editLeftC.isActive = true
            let editRightC = newEditView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
            editRightC.isActive = true
            return
        } else {
            if newEditView != nil {
                newEditView.isHidden = true
            }
            editingView.isHidden = false
        }
        
        curElement = element
        nameLbl.isHidden = false
        nameLbl.text = element.name
        nameLbl.sizeToFit()

        switch element.type {
        case .derInt:
            valLbl.isHidden = false
            valLbl.text = String(element.dvalue)
            valLbl.sizeToFit()
            valTxt.isHidden = true
            ivalTxt.isHidden = true
            dvalLbl.isHidden = true
            ivalStepper.isHidden = true
        case .derText:
            valLbl.isHidden = false
            valLbl.text = element.value
            editingView.layoutSubviews()
            valLbl.sizeToFit()
            valTxt.isHidden = true
            ivalTxt.isHidden = true
            dvalLbl.isHidden = true
            ivalStepper.isHidden = true
        case .freeInt, .resInt:
            valLbl.isHidden = true
            valTxt.isHidden = true
            ivalTxt.text = String(element.ivalue ?? 99)
            ivalTxt.isHidden = false
            if element.dvalue == nil {
                dvalLbl.text = String("")
            } else {
                dvalLbl.text = String(element.dvalue!)
            }
            dvalLbl.isHidden = false
            ivalStepper.isHidden = false
            ivalStepper.isEnabled = true
            ivalStepper.maximumValue = Double(System.instance.get_max(character, element: element))
            ivalStepper.value = Double(element.ivalue!)
        case .freetext:
            valLbl.isHidden = true
            valTxt.isHidden = false
            valTxt.text = element.value
            ivalTxt.isHidden = true
            dvalLbl.isHidden = true
            ivalStepper.isHidden = true
        case .selText:
            valLbl.isHidden = true
            valTxt.isHidden = false
            valTxt.text = element.value
            ivalTxt.isHidden = true
            dvalLbl.isHidden = true
            ivalStepper.isHidden = true
        case .uninitialised:
            debugPrint("Uninitialised element in character")
        }
        if element.rolls {
            rollBtnStack.isHidden = false
        } else {
            rollBtnStack.isHidden = true
        }
    }
    
    @IBAction func iStepperChanged(_ sender: Any) {
        guard let stepper = sender as? UIStepper else { return }
        
        let ival = Int(stepper.value)
        curElement.ivalue = ival
        System.instance.setDerived(character)
        setupElemView(curElement)
        tableView.reloadData()
        // save character and reload table/s?
        DataService.instance.saveCharacter(character: character) { (success) in
            if success {
                //debugPrint("Wrote character: \(String(describing: self.character.documentId))")
            } else {
                debugPrint("Failed to write character: \(String(describing: self.character.documentId))")
            }
        }
        //ivalTxt.text = String(describing: Int(stepper.value))
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let tabHeight = tabBarController?.tabBar.frame.size.height ?? 0
        let endingFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var keyboardHeight = endingFrame.height
        if keyboardHeight > tabHeight {
            keyboardHeight -= tabHeight
        }

        inputViewBottomLayout.constant = -1 * keyboardHeight
        //editingView.superview?.layoutIfNeeded()
        //editingView.layoutIfNeeded()
    }
    
    func selNewElement(section: String) {
        //debugPrint("starting picker with section: \(section)")
        if section == "equipment" {
            System.instance.add_equip(character)
            tableView.reloadData()
            return
        }
        
        selPickerSec = section
        pickerSelections.removeAll()
        if selPickerSec == "traits" {
            pickerSelections = System.instance.ava_traits(character)
        } else {
            for (key, _) in System.instance.allElements[section]!.sorted(by: { $0.value.order < $1.value.order }) {
                pickerSelections.append(key)
            }
        }
        selPicker.isHidden = false
        selPicker.reloadAllComponents()
    }
    
    @IBAction func rollBtnPress(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        let id = button.titleLabel?.text
        
        var dice = [Int.random(in: 1...10), Int.random(in: 1...10), Int.random(in: 1...10), Int.random(in: 1...10)]
        let alerttitle = "Rolling \(curElement.name)"
        var total = 0
        var message: String!
        var result = 0
        var crit = false
        switch id {
        case "Roll -2":
            total = min(dice[0]+dice[1], dice[0]+dice[2], dice[0]+dice[3], dice[1]+dice[2], dice[1]+dice[3], dice[2]+dice[3])
            result = total + curElement.dvalue!
            message = "[\(dice[0]),\(dice[1]),\(dice[2]),\(dice[3])] dice: \(total). Result: \(result)."
            crit = dice[0]==dice[1] || dice[0]==dice[2] || dice[0]==dice[3] || dice[1]==dice[2] || dice[1]==dice[3] || dice[2]==dice[3]
        case "Roll -1":
            total = dice[0] + dice[1] + dice[2] - dice[0..<3].max()!
            result = total + curElement.dvalue!
            message = "[\(dice[0]),\(dice[1]),\(dice[2])] dice: \(total). Result: \(result)."
            crit = dice[0]==dice[1] || dice[0]==dice[2] || dice[1]==dice[2]
        case "Roll":
            total = dice[0] + dice[1]
            result = total + curElement.dvalue!
            message = "[\(dice[0]),\(dice[1])] dice: \(total). Result: \(result)."
            crit = dice[0]==dice[1]
        case "Roll +1":
            total = dice[0] + dice[1] + dice[2] - dice[0..<3].min()!
            result = total + curElement.dvalue!
            message = "[\(dice[0]),\(dice[1]),\(dice[2])] dice: \(total). Result: \(result)."
            crit = dice[0]==dice[1] || dice[0]==dice[2] || dice[1]==dice[2]
        case "Roll +2":
            total = max(dice[0]+dice[1], dice[0]+dice[2], dice[0]+dice[3], dice[1]+dice[2], dice[1]+dice[3], dice[2]+dice[3])
            result = total + curElement.dvalue!
            message = "[\(dice[0]),\(dice[1]),\(dice[2]),\(dice[3])] dice: \(total). Result: \(result)."
            crit = dice[0]==dice[1] || dice[0]==dice[2] || dice[0]==dice[3] || dice[1]==dice[2] || dice[1]==dice[3] || dice[2]==dice[3]
        default:
            debugPrint("Unknown button: \(String(describing: id))")
            return
        }
        if crit {
            message.append(" Critical result!")
        }
        let alert = UIAlertController(title: alerttitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
}



extension CharacterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return System.instance.allElements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if secShowState[section] {
            return character.elements[System.instance.sectionKeys[section]]!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "abilityCell", for: indexPath) as? AbilityCell else { return UITableViewCell() }
        let element = character.elements[System.instance.sectionKeys[indexPath.section]]!.sorted{ $0.value.order < $1.value.order }[indexPath.row].value
        cell.nameLbl.text = element.name
        
        switch element.type {
        case .derInt:
            cell.valLbl.text = "\(element.dvalue ?? 99)"
        case .derText, .freetext, .selText:
            cell.valLbl.text = element.value
        case .freeInt:
            if System.instance.sectionKeys[indexPath.section] == "careers" {
                cell.valLbl.text = "\(element.ivalue ?? 99)"
            } else if element.name == "Development Points" {
                cell.valLbl.text = "\(element.ivalue ?? 99) spent: \(element.dvalue ?? 99)"
            } else {
                cell.valLbl.text = "\(element.ivalue ?? 99) final: \(element.dvalue ?? 99)"
            }
        case .resInt:
            cell.valLbl.text = "\(element.dvalue ?? 99) current: \(element.ivalue ?? 99)"
        case .uninitialised:
            debugPrint("Uninitialised element: \(element.name)")
        }
        cell.backgroundColor = UIColor(hexColor: "29314c")
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(hexColor: "965929")
        cell.selectedBackgroundView = backgroundView

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = character.elements[System.instance.sectionKeys[indexPath.section]]!.sorted{ $0.value.order < $1.value.order }[indexPath.row].value
        setupElemView(element)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headercell") as! CharacterHeaderCell
        headerCell.backgroundColor = UIColor(hexColor: "010a25")
        headerCell.charvc = self
        headerCell.section = section
        if secShowState[section] {
            headerCell.arrowBtn.setImage(UIImage(named: "uiarrowdown"), for: .normal)
        } else {
            headerCell.arrowBtn.setImage(UIImage(named: "uiarrow"), for: .normal)
        }
        let secname = System.instance.sectionKeys[section]
        if secname == "careers" || secname == "skills" || secname == "traits" || secname == "equipment" {
            headerCell.addBtn.isHidden = false
        } else {
            headerCell.addBtn.isHidden = true
        }
        
        headerCell.headerLbl.text = System.instance.sectionNames[section]
        return headerCell
    }
}



extension CharacterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        inputViewBottomLayout.constant = 0
        editingView.superview?.layoutIfNeeded()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if curElement.type == .freetext {
            curElement.value = valTxt!.text
        } else if curElement.type == .freeInt {
            curElement.ivalue = Int(ivalTxt!.text!)
            System.instance.setDerived(character)
        } else {
            return false
        }
        setupElemView(curElement)
        tableView.reloadData()
        // save character and reload table/s?
        DataService.instance.saveCharacter(character: character) { (success) in
            if success {
                //debugPrint("Wrote character: \(String(describing: self.character.documentId))")
            } else {
                debugPrint("Failed to write character: \(String(describing: self.character.documentId))")
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if curElement.type == .selText {
            //debugPrint("Activating picker from txt")
            selPicker.isHidden = false
            selPicker.reloadAllComponents()

            switch curElement.name {
            case "Background":
                let back_num = System.instance.backgrounds.firstIndex(of: curElement.value)
                selPicker.selectRow(back_num!, inComponent: 0, animated: false)
            default:
                debugPrint("Unknown selText name: \(curElement.name)")
            }
        }
    }
    
    @objc func txtDoneButton() {
        if let intval = Int(ivalTxt!.text!) {
            curElement.ivalue = min(intval, curElement.dvalue)
            setupElemView(curElement)
            tableView.reloadData()
            // save character and reload table/s?
            DataService.instance.saveCharacter(character: character) { (success) in
                if success {
                    //debugPrint("Wrote character: \(String(describing: self.character.documentId))")
                } else {
                    debugPrint("Failed to write character: \(String(describing: self.character.documentId))")
                }
            }
        }
        ivalTxt.resignFirstResponder()
    }
}



extension CharacterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selPickerSec != nil {
            return pickerSelections.count
        }
        if curElement == nil { return 0 }
        if curElement.type != .selText { return 0 }
        switch curElement.name {
        case "Background":
            return System.instance.backgrounds.count
        default:
            debugPrint("Unknown selText name: \(curElement.name)")
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if let section = selPickerSec {
            if character.elements[section]![pickerSelections[row]] == nil {
                return NSAttributedString(string: System.instance.allElements[section]![pickerSelections[row]]!.name, attributes: [.foregroundColor: UIColor.black])
            } else {
                return NSAttributedString(string: System.instance.allElements[section]![pickerSelections[row]]!.name, attributes: [.foregroundColor: UIColor.red])
            }
        }
        if curElement == nil { return nil }
        switch curElement.name {
        case "Background":
            return NSAttributedString(string: System.instance.backgrounds[row])
        default:
            debugPrint("Unknown selText name: \(curElement.name)")
        }
        return nil

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let section = selPickerSec {
            if character.elements[section]![pickerSelections[row]] == nil {
                character.elements[section]![pickerSelections[row]] = System.instance.allElements[section]![pickerSelections[row]]
            } else {
                character.elements[section]!.removeValue(forKey: pickerSelections[row])
            }
            System.instance.setDerived(character)
            tableView.reloadData()
        } else {
            switch curElement.name {
            case "Background":
                let new_bg = System.instance.backgrounds[row]
                character.elements["main"]!["background"]!.value = new_bg
                System.instance.changeBackground(character)
                setupElemView(curElement)
                tableView.reloadData()
            default:
                debugPrint("Unknown selText name: \(curElement.name)")
            }
        }
        // save character and reload table/s?
        System.instance.setDerived(character)
        DataService.instance.saveCharacter(character: character) { (success) in
            if success {
                    //debugPrint("Wrote character: \(String(describing: self.character.documentId))")
            } else {
                debugPrint("Failed to write character: \(String(describing: self.character.documentId))")
            }
        }

        valTxt.resignFirstResponder()
        selPicker.isHidden = true
    }
    
}
