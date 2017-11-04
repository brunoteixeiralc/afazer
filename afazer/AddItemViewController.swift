//
//  AddItemViewController.swift
//  afazer
//
//  Created by Bruno Corrêa on 04/11/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller:AddItemViewController, add item:ChecklistItem)
    func addItemViewController(_ controller:AddItemViewController, edit item:ChecklistItem)
}

class AddItemViewController: UITableViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var done: UIBarButtonItem!
    
    var itemToEdit: ChecklistItem?
    weak var delegate: AddItemViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        done.isEnabled = false
        
        if let item = itemToEdit{
            title = "Editar item"
            name.text = item.text
            done.isEnabled = true
        }
        
        name.delegate = self
        name.becomeFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapCancel(_ sender: Any) {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func tapDone(_ sender: Any) {
        
        if let itemToEdit = itemToEdit{
            itemToEdit.text = name.text!
            delegate?.addItemViewController(self, edit: itemToEdit)
        
        }else{
            let item = ChecklistItem()
            item.text = name.text!
            item.checked = false
            
            delegate?.addItemViewController(self, add: item)
        }
    }
}

extension AddItemViewController: UITextFieldDelegate{
    
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
