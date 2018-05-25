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
    @IBOutlet weak var icon: UIImageView!
    
    var item:Checklist! {
        didSet{
            setUpTheming()
            updateUI()
        }
    }
    
    func updateUI(){
        name.text = item.name
        icon.image = UIImage(named:item.iconName)
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

extension AllListsTableViewCell: Themed{
    func applyTheme(_ theme: AppTheme) {
       self.tintColor = theme.barBackgroundColor
       remain.textColor = theme.barBackgroundColor
    }
}
