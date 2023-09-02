//
//  Day+CoreDataProperties.swift
//  Foodintake
//
//  Created by eoinkortext on 02/09/2023.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: Date?
    @NSManaged public var daysSince1970: Int32
    @NSManaged public var meals: NSSet?

}

// MARK: Generated accessors for meals
extension Day {

    @objc(addMealsObject:)
    @NSManaged public func addToMeals(_ value: MealType)

    @objc(removeMealsObject:)
    @NSManaged public func removeFromMeals(_ value: MealType)

    @objc(addMeals:)
    @NSManaged public func addToMeals(_ values: NSSet)

    @objc(removeMeals:)
    @NSManaged public func removeFromMeals(_ values: NSSet)

}

extension Day : Identifiable {

}
