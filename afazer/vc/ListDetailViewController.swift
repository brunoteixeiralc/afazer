
//
//  ListDetailViewController.swift
//  afazer
//
//  Created by Bruno Corrêa on 07/11/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController,didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController,didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var done: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    var iconName = "No Icon"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        name.delegate = self
        name.becomeFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit{
            title = "Editar Checklist"
            name.text = checklist.name
            done.isEnabled = true
            iconName = checklist.iconName
        }
        
        iconImage.image = UIImage(named:iconName)
    }
    
    @IBAction func tapCancel(){
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func tapDone(){
        if let checklist = checklistToEdit{
            checklist.name = name.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        
        }else{
            let checklist = Checklist()
            checklist.name = name.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon"{
            let controller = segue.destination as! IconPickerTableViewController
            controller.delegate = self
        }
    }
}

extension ListDetailViewController: IconPickerTableViewControllerDelegate{
    
    func iconPicker(_ picker: IconPickerTableViewController, didPick iconame: String) {
        self.iconName = iconame
        iconImage.image = UIImage(named:iconName)
        navigationController?.popViewController(animated: true)
    }
}

extension ListDetailViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            done.isEnabled = false
        } else {
            done.isEnabled = true
        }
        return true
    }
}
