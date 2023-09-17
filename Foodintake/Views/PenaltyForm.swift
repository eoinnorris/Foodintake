//
//  PenaltyForm.swift
//  Foodintake
//
//  Created by eoinkortext on 17/09/2023.
//

import SwiftUI

struct PenaltyForm: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ItemCategory.name, ascending: false)],
        animation: .none)
    private var categories: FetchedResults<ItemCategory>
    
    var namedCategories: [ItemCategory] {
        Array(categories.compactMap {$0})
    }
    
    var body: some View {
        NavigationStack{
            Form {
                ForEach(namedCategories, id:\.self) { category in
                    NavigationLink(category.actualName) {
                        PenaltyFoodForm(selectedCategory: category)
                    }
                }
            }
        }
    }
}

struct PenaltyFoodForm: View {
    let selectedCategory:ItemCategory
    
    var body: some View {
        NavigationStack{
            Form {
                ForEach(selectedCategory.uniqueMealTypes) { mealType in
                    NavigationLink(mealType.actualName) {
                        PenaltiesView(mealType: mealType)
                    }
             }
            }
        }
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
    
    var actualName: String {
        name ?? ""
    }
}

extension MealType {
    var actualName: String {
        name ?? ""
    }
}


struct PenaltyForm_Previews: PreviewProvider {
    
    static var previews: some View {
        PenaltyForm()
    }
}
