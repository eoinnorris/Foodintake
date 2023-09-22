//
//  TestForm.swift
//  Foodintake
//
//  Created by eoinkortext on 22/09/2023.
//

import SwiftUI

// MARK: - Data Models

struct Category {
    let name: String
    var unit: [Unit]
    
    static func generateSampleCategories() -> [Category] {
        var categories: [Category] = []
        for i in 1...10 {
            let unitCount = Int.random(in: 2...10)
            let units = (1...unitCount).map { Unit(name: "Unit \($0)", isOn: Bool.random()) }
            let category = Category(name: "Category \(i)", unit: units)
            categories.append(category)
        }
        return categories
    }
}

struct Unit {
    let name: String
    var isOn: Bool
}

// MARK: - View Model

class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category]
    
    init(categories: [Category]) {
        self.categories = categories
    }
    
    func toggle(unitName: String, in categoryName: String) {
        // 1. Find the category index
        if let categoryIndex = categories.firstIndex(where: { $0.name == categoryName }) {
            // 2. Make a mutable copy of the found category
            var updatedCategory = categories[categoryIndex]
            
            // 3. Find the unit index
            if let unitIndex = updatedCategory.unit.firstIndex(where: { $0.name == unitName }) {
                // 4. Create a new Unit with toggled isOn
                let existingUnit = updatedCategory.unit[unitIndex]
                let updatedUnit = Unit(name: existingUnit.name, isOn: !existingUnit.isOn)
                
                // 5. Assign the new Unit back to the category's units array
                updatedCategory.unit[unitIndex] = updatedUnit
                
                // 6. Assign the updated category back to the main categories array
                categories[categoryIndex] = updatedCategory
            }
        }
    }
}

// MARK: - View

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(configuration.isOn ? Color.accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.medium)
            }
        }
        .buttonStyle(.plain)
    }
}

struct CategoriesView: View {
    @ObservedObject var viewModel: CategoriesViewModel
    
    var body: some View {
        Form {
            ForEach(viewModel.categories, id: \.name) { category in
                Section(header: Text(category.name)) {
                    ForEach(category.unit, id: \.name) { unit in
                        Toggle(isOn: Binding(
                            get: { unit.isOn },
                            set: { _ in viewModel.toggle(unitName: unit.name, in: category.name) }
                        )) {
                            Text(unit.name)
                        }            .toggleStyle(CheckToggleStyle())

                    }
                }
            }
        }
    }
}

// MARK: - Preview & Test

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCategory = Category(name: "Sample Category", unit: [Unit(name: "Unit 1", isOn: true), Unit(name: "Unit 2", isOn: false)])
        let viewModel = CategoriesViewModel(categories: [sampleCategory])
        CategoriesView(viewModel: viewModel)
    }
}
