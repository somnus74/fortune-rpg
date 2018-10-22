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

    let otherPicker = UIPickerView()
    
    var character: Character!
    var curElement: Element!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        valTxt.delegate = self
        selPicker.delegate = self
        //selPicker.dataSource = self
        otherPicker.delegate = self
        
        editingView.bindToKeyboard((tabBarController?.tabBar.frame.size.height)!)
        //tabHeight = tabBarController?.tabBar.frame.size.height
        
        nameLbl.isHidden = true
        valLbl.isHidden = true
        valTxt.isHidden = true
        ivalTxt.isHidden = true
        dvalLbl.isHidden = true
        ivalStepper.isHidden = true
        ivalStepper.isEnabled = false
        selPicker.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        character.update_all()
        tableView.reloadData()
        title = character.elements["main"]!["name"]!.value
    }

    func setupElemView(_ element: Element) {
        curElement = element
        nameLbl.isHidden = false
        nameLbl.text = element.name
        switch element.type {
        case .derInt:
            valLbl.isHidden = false
            valLbl.text = String(element.dvalue)
            valTxt.isHidden = true
            ivalTxt.isHidden = true
            dvalLbl.isHidden = true
            ivalStepper.isHidden = true
        case .derText:
            valLbl.isHidden = false
            valLbl.text = element.value
            valTxt.isHidden = true
            ivalTxt.isHidden = true
            dvalLbl.isHidden = true
            ivalStepper.isHidden = true
        case .freeInt, .resInt:
            valLbl.isHidden = true
            valTxt.isHidden = true
            ivalTxt.text = String(element.ivalue ?? 99)
            ivalTxt.isHidden = false
            dvalLbl.text = String(element.ivalue)
            dvalLbl.isHidden = false
            ivalStepper.isHidden = false
            ivalStepper.isEnabled = true
            ivalStepper.value = Double(element.ivalue)
            ivalStepper.maximumValue = Double(System.instance.get_max(character, element: element))
        case .freetext:
            valLbl.isHidden = true
            valTxt.isHidden = false
            valTxt.text = element.value
            ivalTxt.isHidden = true
            dvalLbl.isHidden = true
            ivalStepper.isHidden = true
        case .selText:
            valLbl.isHidden = false
            valLbl.text = element.value
            valTxt.isHidden = false
            valTxt.text = element.value
            ivalTxt.isHidden = true
            dvalLbl.isHidden = true
            ivalStepper.isHidden = true
        case .uninitialised:
            debugPrint("Uninitialised element in character")
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
        ivalTxt.text = String(describing: Int(stepper.value))
    }
    
    @IBAction func valTxtWasPressed(_ sender: Any) {
        // if seltext, activate picker
    }
}



extension CharacterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return System.instance.allElements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 3
        return character.elements[System.instance.sectionKeys[section]]!.count
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
            cell.valLbl.text = "\(element.ivalue ?? 99) / \(element.dvalue ?? 99)"
        case .resInt:
            cell.valLbl.text = "\(element.dvalue ?? 99) current: \(element.ivalue ?? 99)"
        case .uninitialised:
            debugPrint("Uninitialised element: \(element.name)")
        }
        cell.backgroundColor = UIColor(hexColor: "29314c")
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Character.sectionNames[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = character.elements[System.instance.sectionKeys[indexPath.section]]!.sorted{ $0.value.order < $1.value.order }[indexPath.row].value
        setupElemView(element)
    }
    
}



extension CharacterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = valTxt!.text {
            curElement.value = text
            setupElemView(curElement)
            tableView.reloadData()
            // save character and reload table/s?
            DataService.instance.saveCharacter(character: character) { (success) in
                if success {
                    debugPrint("Wrote character: \(String(describing: self.character.documentId))")
                } else {
                    debugPrint("Failed to write character: \(String(describing: self.character.documentId))")
                }
            }
            return true
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if curElement.type == .selText {
            debugPrint("Activating picker from txt")
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
}



extension CharacterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if curElement == nil { return 0 }
        switch curElement.name {
        case "Background":
            return System.instance.backgrounds.count
        default:
            debugPrint("Unknown selText name: \(curElement.name)")
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if curElement == nil { return nil }
        switch curElement.name {
        case "Background":
            return System.instance.backgrounds[row]
        default:
            debugPrint("Unknown selText name: \(curElement.name)")
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch curElement.name {
        case "Background":
            let new_bg = System.instance.backgrounds[row]
            character.elements["main"]!["background"]!.value = new_bg
            System.instance.changeBackground(character)
            setupElemView(curElement)
            tableView.reloadData()
            // save character and reload table/s?
            DataService.instance.saveCharacter(character: character) { (success) in
                if success {
                    debugPrint("Wrote character: \(String(describing: self.character.documentId))")
                } else {
                    debugPrint("Failed to write character: \(String(describing: self.character.documentId))")
                }
            }
            //valTxt.text = new_bg
        default:
            debugPrint("Unknown selText name: \(curElement.name)")
        }

        valTxt.resignFirstResponder()
        selPicker.isHidden = true
    }
    
}
