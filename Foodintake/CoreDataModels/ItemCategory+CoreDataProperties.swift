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

}

extension ItemCategory : Identifiable {

}
