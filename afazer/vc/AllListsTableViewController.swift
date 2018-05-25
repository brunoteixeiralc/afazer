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
        let row0item = Checklist(name: "Lista 1", items: [])
        lists.append(row0item)
        let row1item = Checklist(name: "Lista 2", items: [])
        lists.append(row1item)
        let row2item = Checklist(name: "Lista 3", items: [])
        lists.append(row2item)
        let row3item = Checklist(name: "Lista 4", items: [])
        lists.append(row3item)
        let row4item = Checklist(name: "Lista 5", items: [])
        lists.append(row4item)
        
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.dropDelegate = self

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTheming()
        
        for list in lists {
            let item = ChecklistItem(name: "Item for \(list.name)")
            list.items.append(item)
        }
        
        if lists.count > 0{
            sortList()
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
    
    func sortList(){
        lists.sort { (checklist1, checklist2) -> Bool in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        }
    }
}

extension AllListsTableViewController: UITableViewDragDelegate{
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = lists[indexPath.row]
        let provider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: provider)
        
        return [dragItem]
    }
}

extension AllListsTableViewController: UITableViewDropDelegate{
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        DispatchQueue.main.async { [weak self] in
            tableView.beginUpdates()
            
            coordinator.items.forEach({ (item) in
                guard let sourceIndexPath = item.sourceIndexPath, let `self` = self else {return}
                let row = self.lists.remove(at: sourceIndexPath.row)
                self.lists.insert(row, at: destinationIndexPath.row)
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
        
        sortList()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = lists.index(where: {$0 === checklist}){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                (cell as! AllListsTableViewCell).item = checklist
            }
        }
        
        sortList()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
}

extension AllListsTableViewController: Themed{
    func applyTheme(_ theme: AppTheme) {
       // tableView.backgroundView?.backgroundColor = theme.backgroundColor;
    }
}
