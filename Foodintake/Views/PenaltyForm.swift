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
                    NavigationLink(category.capitalisedName) {
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
                    NavigationLink(mealType.capitalisedName) {
                        PenaltiesView(mealType: mealType)
                    }
             }
            }
        }
    }
}





struct PenaltyForm_Previews: PreviewProvider {
    
    static var previews: some View {
        PenaltyForm()
    }
}
