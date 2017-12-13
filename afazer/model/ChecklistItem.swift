//
//  ChecklistItem.swift
//  afazer
//
//  Created by Bruno Corrêa on 04/11/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit
import UserNotifications

//TODO - melhorar o identifier local notification

class ChecklistItem {
    var name = ""
    var checked = false
    var shouldRemind = false
    var dueDate = Date()
    
    deinit {
        removeNotification()
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func scheduleNotification(){
        removeNotification()
        
        if shouldRemind && dueDate > Date(){
            
            let content =  UNMutableNotificationContent()
            content.title = "Lembrete:"
            content.body = name
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month,.day,.hour,.minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(name)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled: \(request)")
            
        }
    }
    
    func removeNotification(){
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["\(name)"])
    }
}
