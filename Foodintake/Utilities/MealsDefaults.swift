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
    
    struct MinLimit {
        static let bread = 0
        static let fruit = 0
        static let meal = 2
        static let snack = 0
        static let alcohol = 0

    }
    
    struct MaxLimit {
        static let bread = 10
        static let fruit = 10
        static let meal = 5
        static let snack = 10
        static let alcohol = 20
        
    }
    
    // add weekend exceptions
    var minLimit:Int {
        switch self {
        case .bread:
            return MinLimit.bread
        case .fruit:
            return MinLimit.fruit
        case .meal:
            return MinLimit.meal
        case .snack:
            return MinLimit.snack
        case .alcohol:
            return MinLimit.alcohol
        }
    }
    
    var maxLimit:Int {
        switch self {
        case .bread:
            return MaxLimit.bread
        case .fruit:
            return MaxLimit.fruit
        case .meal:
            return MaxLimit.meal
        case .snack:
            return MaxLimit.snack
        case .alcohol:
            return MaxLimit.alcohol
        }
    }
}


