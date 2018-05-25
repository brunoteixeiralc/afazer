//
//  ConfTableViewController.swift
//  afazer
//
//  Created by Bruno Corrêa on 24/05/2018.
//  Copyright © 2018 Bruno Lemgruber. All rights reserved.
//

import UIKit

class ConfTableViewController: UITableViewController {

    @IBOutlet weak var dark_mode: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTheming()
    }
    
    @IBAction func stateChanged(switchState: UISwitch) {
        if switchState.isOn{
           themeProvider.nextTheme(isON:true )
        }else{
           themeProvider.nextTheme(isON:false )
        }
    }
}

extension ConfTableViewController: Themed{
    func applyTheme(_ theme: AppTheme) {
        dark_mode.isOn = theme.statusBarStyle == .default
        dark_mode.onTintColor = theme.barBackgroundColor
    }
}
