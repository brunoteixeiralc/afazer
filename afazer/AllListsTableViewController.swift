//
//  AllListsTableViewController.swift
//  afazer
//
//  Created by Bruno Lemgruber on 06/11/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit

class AllListsTableViewController: UITableViewController {

    var items: [Checklist]
    
    required init?(coder aDecoder: NSCoder) {
        items = [Checklist]()
        let row0item = Checklist()
        row0item.name = "Lista 1"
        items.append(row0item)
        let row1item = Checklist()
        row1item.name = "Lista 2"
        items.append(row1item)
        let row2item = Checklist()
        row2item.name = "Lista 3"
        items.append(row2item)
        let row3item = Checklist()
        row3item.name = "Lista 4"
        items.append(row3item)
        let row4item = Checklist()
        row4item.name = "Lista 5"
        items.append(row4item)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllList", for: indexPath) as! AllListsTableViewCell
        cell.item = items[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let checklist = items[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destination as! ChecklistTableViewController
            controller.checklist = sender as! Checklist
        }
    }
}
