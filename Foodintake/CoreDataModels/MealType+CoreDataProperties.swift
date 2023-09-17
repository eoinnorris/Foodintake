//
//  MealType+CoreDataProperties.swift
//  Foodintake
//
//  Created by eoinkortext on 02/09/2023.
//
//

import Foundation
import CoreData

protocol MealTypeType {
    
    // Properties
    var daily: Int16 { get set }
    var max: Int16 { get set }
    var min: Int16 { get set }
    var name: String? { get set }
    var count: Int16 { get set }
    var time: Date? { get set }
    var day: Day? { get set }
}


extension MealType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealType> {
        return NSFetchRequest<MealType>(entityName: "MealType")
    }

    @NSManaged public var daily: Int16
    @NSManaged public var max: Int16
    @NSManaged public var min: Int16
    @NSManaged public var name: String?
    @NSManaged public var count: Int16
    @NSManaged public var time: Date?
    @NSManaged public var day: Day?

}

extension MealType : Identifiable {

}
