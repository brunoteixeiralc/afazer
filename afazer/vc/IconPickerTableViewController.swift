//
//  IconPickerTableViewController.swift
//  afazer
//
//  Created by Bruno Corrêa on 04/12/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit

protocol IconPickerTableViewControllerDelegate: class {
    func iconPicker(_ picker: IconPickerTableViewController, didPick iconame:String)
}

class IconPickerTableViewController: UITableViewController {

    weak var delegate:IconPickerTableViewControllerDelegate?
    
    let icons = [ "No Icon", "Appointments", "Birthdays", "Chores",
                  "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        let iconName =  icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named:iconName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate{
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }

}
