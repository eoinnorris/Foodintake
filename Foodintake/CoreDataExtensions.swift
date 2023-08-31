//
//  CoreDataExtensions.swift
//  Foodintake
//
//  Created by eoinkortext on 31/08/2023.
//

import Foundation

extension MealType {
    
    var capitalisedName:String {
        if let name {
            return name.capitalized
        }
        return ""
    }
    
}
