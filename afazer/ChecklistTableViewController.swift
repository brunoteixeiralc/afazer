//
//  ChecklistTableViewController.swift
//  afazer
//
//  Created by Bruno Corrêa on 04/11/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit

class ChecklistTableViewController: UITableViewController {

    var items: [ChecklistItem]
    var checklist: Checklist!

    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        let row0item = ChecklistItem()
        row0item.name = "Walk the dog"
        row0item.checked = false
        items.append(row0item)
        let row1item = ChecklistItem()
        row1item.name = "Brush my teeth"
        row1item.checked = true
        items.append(row1item)
        let row2item = ChecklistItem()
        row2item.name = "Learn iOS development"
        row2item.checked = true
        items.append(row2item)
        let row3item = ChecklistItem()
        row3item.name = "Soccer practice"
        row3item.checked = false
        items.append(row3item)
        let row4item = ChecklistItem()
        row4item.name = "Eat ice cream"
        row4item.checked = true
        items.append(row4item)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = checklist.name
    }
    
    @IBAction func addChecklistItem(_ sender: Any) {
        let newRowIndex = items.count
        let item = ChecklistItem()
        item.name = "I am a new row"
        item.checked = false
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as! ChecklistTableViewCell
        cell.item = items[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let item = items[indexPath.row]
         item.toggleChecked()
         tableView.reloadData()
        
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
        }else if segue.identifier == "EditItem"{
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
}

extension ChecklistTableViewController:AddItemViewControllerDelegate{
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, add item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, edit item: ChecklistItem) {
        if let index = items.index(where: {$0 === item}){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
               (cell as! ChecklistTableViewCell).item = item
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}

