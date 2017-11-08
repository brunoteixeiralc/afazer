//
//  Checklist.swift
//  afazer
//
//  Created by Bruno Lemgruber on 06/11/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit

class Checklist {
    var name = ""
    var items = [ChecklistItem]()
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1 }
        return count
    }
}
