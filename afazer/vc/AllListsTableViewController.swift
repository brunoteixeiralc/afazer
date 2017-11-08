//
//  AllListsTableViewController.swift
//  afazer
//
//  Created by Bruno Lemgruber on 06/11/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit

class AllListsTableViewController: UITableViewController {

    var lists: [Checklist]
    
    required init?(coder aDecoder: NSCoder) {
        lists = [Checklist]()
        let row0item = Checklist()
        row0item.name = "Lista 1"
        lists.append(row0item)
        let row1item = Checklist()
        row1item.name = "Lista 2"
        lists.append(row1item)
        let row2item = Checklist()
        row2item.name = "Lista 3"
        lists.append(row2item)
        let row3item = Checklist()
        row3item.name = "Lista 4"
        lists.append(row3item)
        let row4item = Checklist()
        row4item.name = "Lista 5"
        lists.append(row4item)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for list in lists {
            let item = ChecklistItem()
            item.name = "Item for \(list.name)"
            list.items.append(item)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllList", for: indexPath) as! AllListsTableViewCell
        cell.item = lists[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let checklist = lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destination as! ChecklistTableViewController
            controller.checklist = sender as! Checklist
        }else if segue.identifier == "AddChecklist"{
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }else if segue.identifier == "EditChecklist"{
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.checklistToEdit = lists[indexPath.row]
            }
        }
    }
}

extension AllListsTableViewController: ListDetailViewControllerDelegate{
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        let newRowIndex = lists.count
        lists.append(checklist)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = lists.index(where: {$0 === checklist}){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                (cell as! AllListsTableViewCell).item = checklist
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}
