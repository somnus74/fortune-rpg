//
//  FirstViewController.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 2/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import UIKit

class CharactersVC: UIViewController {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    var characters = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadCharacters()
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem
    }

    @IBAction func addBtnWasPressed(_ sender: Any) {
        let newChar = Character()
        DataService.instance.writeCharacter(character: newChar) { (success) in
            if success {
                self.characters.append(newChar)
                self.tableView.reloadData()
            } else {
                debugPrint("Error creating character")
            }
        }
    }
    
    func loadCharacters() {
        DataService.instance.getCharactersForUser { (returnedCharacters) in
            self.characters = returnedCharacters
            self.tableView.reloadData()
        }
    }
    
    @IBAction func editBtnWasPressed(_ sender: UIButton) {
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: false)
        } else {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "characterShow" {
            if let characterVC = segue.destination as? CharacterVC {
                if let sendC = sender as? Character {
                    characterVC.character = sendC
                } else {
                    debugPrint("Sender error in segue")
                }
            }
        }
    }
    
}

extension CharactersVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharacterCell else { return UITableViewCell() }
        if let name = characters[indexPath.row].elements["main"]!["name"]!.value {
            cell.nameLbl.text = name
        } else {
            cell.nameLbl.text = "New character"
        }
        cell.backgroundColor = UIColor(hexColor: "29314c")
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(hexColor: "965929")
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditing
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            let title = "Delete \(self.characters[indexPath.row].elements["main"]!["name"]!.value ?? "no character name")?"
            let message = "Are you sure you want to delete this character?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancel)
            
            let deleteAc = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                DataService.instance.deleteCharacter(character: self.characters[indexPath.row], completion: { (success) in
                    self.characters.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                })
            })
            ac.addAction(deleteAc)
            
            self.present(ac, animated: false, completion: nil)
        }
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "characterShow", sender: characters[indexPath.row])
    }
}

