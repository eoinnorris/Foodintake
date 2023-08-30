//
//  MealsDefaults.swift
//  Foodintake
//
//  Created by eoinkortext on 20/08/2023.
//

import Foundation

enum DefaultMealTypeEnum:String, CaseIterable {
    case bread
    case fruit
    case meal
    case snack
    case alcohol
    
    struct Limit {
        static let bread = 2
        static let fruit = 5
        static let meal = 3
        static let snack = 1
        static let alcohol = 0

    }
    
    // add weekend exceptions
    var limit:Int {
        switch self {
        case .bread:
            return Limit.bread
        case .fruit:
            return Limit.fruit
        case .meal:
            return Limit.meal
        case .snack:
            return Limit.snack
        case .alcohol:
            return Limit.alcohol
        }
    }
    
    func isOverLimit(for value:Int) -> Bool {
        value > limit
    }
    
}


