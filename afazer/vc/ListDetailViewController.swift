
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
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
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
        }
    }
    
    @IBAction func tapCancel(){
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func tapDone(){
        if let checklist = checklistToEdit{
            checklist.name = name.text!
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        }else{
            let checklist = Checklist()
            checklist.name = name.text!
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
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
