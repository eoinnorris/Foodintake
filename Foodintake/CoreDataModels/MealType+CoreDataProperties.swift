//
//  MealType+CoreDataProperties.swift
//  Foodintake
//
//  Created by eoinkortext on 17/09/2023.
//
//

import Foundation
import CoreData


extension MealType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealType> {
        return NSFetchRequest<MealType>(entityName: "MealType")
    }

    @NSManaged public var count: Int16
    @NSManaged public var daily: Int16
    @NSManaged public var max: Int16
    @NSManaged public var min: Int16
    @NSManaged public var name: String?
    @NSManaged public var time: Date?
    @NSManaged public var day: Day?
    @NSManaged public var category: ItemCategory?

}

extension MealType : Identifiable {

}
