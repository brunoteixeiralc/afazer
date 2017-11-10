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
    @IBOutlet weak var remain: UILabel!
    
    var item:Checklist! {
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        name.text = item.name
        let count = item.countUncheckedItems()
        if item.items.count == 0 {
           remain.text = "(Sem nenhum item)."
        } else if count == 0 {
           remain.text = "Tudo completado!"
        } else if count == 1 {
           remain.text = "Ainda falta \(item.countUncheckedItems()) item."
        } else{
           remain.text = "Ainda faltam \(item.countUncheckedItems()) itens."
        }
    }
}
