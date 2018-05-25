//
//  AppTheme.swift
//  Night Mode
//
//  Created by Michael on 01/04/2018.
//  Copyright © 2018 Late Night Swift. All rights reserved.
//

import UIKit

struct AppTheme {
	var statusBarStyle: UIStatusBarStyle
	var barBackgroundColor: UIColor
	var barForegroundColor: UIColor
	//var backgroundColor: UIColor
	var textColor: UIColor
}

extension AppTheme {
	static let light = AppTheme(
		statusBarStyle: .lightContent,
        barBackgroundColor: UIColor(named: "PrimaryColor")!,
		barForegroundColor: .white,
		//backgroundColor: UIColor(white: 0.9, alpha: 1),
		textColor: .lightText
	)

	static let dark = AppTheme(
		statusBarStyle: .lightContent,
		barBackgroundColor: .black,
		barForegroundColor: .black,
		//backgroundColor: UIColor(white: 0.2, alpha: 1),
		textColor: .lightText
	)
}
