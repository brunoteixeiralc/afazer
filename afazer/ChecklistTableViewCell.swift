//
//  ChecklistTableViewCell.swift
//  afazer
//
//  Created by Bruno Corrêa on 04/11/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var check: UIImageView!

    var item:ChecklistItem! {
        didSet{
           updateUI()
        }
    }
    
    func updateUI(){
        name.text = item.name
        configureCheckmark(for: item)
    }
    
    func configureCheckmark(for item:ChecklistItem) {
        if item.checked {
            check.image = UIImage(named: "check")
        } else {
            check.image = nil
        }
    }
}
