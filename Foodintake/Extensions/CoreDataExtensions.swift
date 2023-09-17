//
//  CoreDataExtensions.swift
//  Foodintake
//
//  Created by eoinkortext on 31/08/2023.
//

import Foundation

extension MealType {
    
    var actualName: String {
        name ?? ""
    }
    
    var capitalisedName:String {
        actualName.capitalized
    }
}

extension ItemCategory {
    
    var uniqueMealTypes: [MealType] {
        var seenNames = Set<String>()
        let types = self.mealTypes
        return types.filter { type in
            if seenNames.contains(type.actualName) {
                return false
            } else {
                seenNames.insert(type.actualName)
                return true
            }
        }.sorted {$0.actualName < $1.actualName}
    }
    
    
    var mealTypes:[MealType] {
        if let mealTypes = self.items?.allObjects as? [MealType] {
            return mealTypes
        }
        return []
    }
    
    var capitalisedName:String {
        actualName.capitalized
    }
    
    var actualName: String {
        name ?? ""
    }
}


extension Day {
    var dateOrNow: Date {
        date ?? Date.now
    }
}


