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
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var itemToEdit: ChecklistItem?
    weak var delegate: AddItemViewControllerDelegate?
    var dueDate = Date()
    var datePickerVisible = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        done.isEnabled = false
        
        if let item = itemToEdit{
            title = "Editar item"
            name.text = item.name
            done.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        
        updateDueDate()
        
        name.delegate = self
        name.becomeFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        }else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible{
            return 3
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2{
            return 217
        }else{
           return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        name.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1{
            if !datePickerVisible {
                showDatePicker()
            }else{
                hideDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1{
            return indexPath
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2{
            newIndexPath = IndexPath(row: 0,section: indexPath.section)
        }
        
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    func updateDueDate(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    func showDatePicker(){
        datePickerVisible = true

        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row:2, section:1)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dueDateLabel.textColor = dateCell.textLabel?.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()

        datePicker.setDate(dueDate, animated: true)
    }
    
    func hideDatePicker(){
        if datePickerVisible{
            datePickerVisible = false
        
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row:2, section:1)
            
            if tableView.cellForRow(at: indexPathDateRow) != nil {
                dueDateLabel.textColor = UIColor.black
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    @IBAction func dateChanged(_ datePicker:UIDatePicker){
        dueDate = datePicker.date
        updateDueDate()
    }

    @IBAction func tapCancel(_ sender: Any) {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func tapDone(_ sender: Any) {
        
        if let itemToEdit = itemToEdit{
            itemToEdit.name = name.text!
            itemToEdit.shouldRemind = shouldRemindSwitch.isOn
            itemToEdit.dueDate = dueDate
            
            delegate?.addItemViewController(self, edit: itemToEdit)
        
        }else{
            let item = ChecklistItem()
            item.name = name.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            
            delegate?.addItemViewController(self, add: item)
        }
    }
}

extension AddItemViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
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
