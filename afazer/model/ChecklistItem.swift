//
//  ChecklistItem.swift
//  afazer
//
//  Created by Bruno Corrêa on 04/11/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit
import UserNotifications
import Foundation

//TODO - melhorar o identifier local notification

final class ChecklistItem:NSObject {
    
    static let listItemTypeId = "br.com.afazer.listItem"
    
    var name :String = ""
    var checked :Bool = false
    var shouldRemind: Bool = false
    var dueDate :Date = Date()
    
    init(name:String, checked:Bool = false, shouldRemind:Bool = false, dueDate:Date = Date()) {
        self.name = name
        self.checked = checked
        self.shouldRemind = shouldRemind
        self.dueDate = dueDate
    }
    
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

extension ChecklistItem: NSItemProviderWriting{
    static var writableTypeIdentifiersForItemProvider: [String]{
        return [listItemTypeId]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil
    }
}

extension ChecklistItem: NSItemProviderReading{
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        switch typeIdentifier {
        case listItemTypeId:
            guard let item = NSKeyedUnarchiver.unarchiveObject(with: data) as? ChecklistItem else {throw EncodingError.invalidData}
            return self.init(name: item.name, checked: item.checked, shouldRemind: item.shouldRemind, dueDate: item.dueDate)
        default:
            throw EncodingError.invalidData
        }
    }
    
    static var readableTypeIdentifiersForItemProvider: [String]{
        return [listItemTypeId]
    }
}
