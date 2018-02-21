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
    var checklist: Checklist!{
        didSet{
          title = checklist.name
        }
    }

    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        let row0item = ChecklistItem(name: "Walk the dog")
        items.append(row0item)
        let row1item = ChecklistItem(name: "Brush my teeth")
        items.append(row1item)
        let row2item = ChecklistItem(name: "Learn iOS development")
        items.append(row2item)
        let row3item = ChecklistItem(name: "Soccer practice")
        items.append(row3item)
        let row4item = ChecklistItem(name: "Eat ice cream")
        items.append(row4item)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
    }
    
    @IBAction func addChecklistItem(_ sender: Any) {
        let newRowIndex = items.count
        let item = ChecklistItem(name: "I am a new row")
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
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as! ChecklistTableViewCell
        cell.item = checklist.items[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let item = checklist.items[indexPath.row]
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
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
}

extension ChecklistTableViewController: UITableViewDragDelegate{
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = items[indexPath.row]
        let provider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: provider)
        
        return [dragItem]
    }
}

extension ChecklistTableViewController: UITableViewDropDelegate{
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        DispatchQueue.main.async { [weak self] in
            tableView.beginUpdates()
            
            coordinator.items.forEach({ (item) in
                guard let sourceIndexPath = item.sourceIndexPath, let `self` = self else {return}
                let row = self.items.remove(at: sourceIndexPath.row)
                self.items.insert(row, at: destinationIndexPath.row)
                tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            })
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: Checklist.self)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

extension ChecklistTableViewController:AddItemViewControllerDelegate{
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, add item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, edit item: ChecklistItem) {
        if let index = checklist.items.index(where: {$0 === item}){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
               (cell as! ChecklistTableViewCell).item = item
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}

