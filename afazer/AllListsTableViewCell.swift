//
//  AllListsTableViewCell.swift
//  afazer
//
//  Created by Bruno Lemgruber on 06/11/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit

class AllListsTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    var item:Checklist! {
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
         name.text = item.name
    }
}
