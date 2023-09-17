//
//  ItemCategory+CoreDataProperties.swift
//  Foodintake
//
//  Created by eoinkortext on 17/09/2023.
//
//

import Foundation
import CoreData


extension ItemCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemCategory> {
        return NSFetchRequest<ItemCategory>(entityName: "ItemCategory")
    }

    @NSManaged public var name: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension ItemCategory {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: MealType)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: MealType)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension ItemCategory : Identifiable {

}
