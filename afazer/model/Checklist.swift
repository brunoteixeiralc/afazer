//
//  Checklist.swift
//  afazer
//
//  Created by Bruno Lemgruber on 06/11/2017.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import UIKit
import Foundation

enum EncodingError: Error {
    case invalidData
}

final class Checklist:NSObject {
    
    static let listItemTypeId = "br.com.afazer.listItem"
    
    var name: String = ""
    var iconName: String
    var items = [ChecklistItem]()
    
    init(name:String, iconName:String = "No Icon", items: [ChecklistItem]) {
        self.name = name
        self.iconName = iconName
        self.items = items
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1 }
        return count
    }
}

extension Checklist: NSItemProviderWriting{
    static var writableTypeIdentifiersForItemProvider: [String]{
        return [listItemTypeId]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil
    }
}

extension Checklist: NSItemProviderReading{
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        switch typeIdentifier {
        case listItemTypeId:
            guard let item = NSKeyedUnarchiver.unarchiveObject(with: data) as? Checklist else {throw EncodingError.invalidData}
            return self.init(name: item.name, iconName: item.iconName, items: item.items)
        default:
            throw EncodingError.invalidData
        }
    }
    
    static var readableTypeIdentifiersForItemProvider: [String]{
        return [listItemTypeId]
    }
}
