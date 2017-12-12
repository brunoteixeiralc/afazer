//
//  ChecklistItem.swift
//  afazer
//
//  Created by Bruno Corrêa on 04/11/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit

class ChecklistItem {
    var name = ""
    var checked = false
    var shouldRemind = false
    var dueDate = Date()
    
    func toggleChecked() {
        checked = !checked
    }
}
