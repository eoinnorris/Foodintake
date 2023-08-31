//
//  CounterView.swift
//  Foodintake
//
//  Created by eoinkortext on 30/08/2023.
//

import SwiftUI

struct CounterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var meals: [Meal]
    let mealType:MealType
}


// functions
extension CounterView {
    
    // Function to get the count of meals of a specific type
    private func countOfMeals(ofType type: MealType) -> Int {
        return meals.filter { $0.mealType == type }.count
    }
    
    private func addMeal(ofType type:MealType) {
        withAnimation {
            let newMeal = Meal(context: viewContext)
            newMeal.time = Date()
            newMeal.mealType = type
            
            do {
                try viewContext.save()
            } catch {
                print("Failed to save newMeal \(newMeal) to context \(viewContext)")
            }
        }
    }
    
    
    func deleteMostRecentMeal(ofType type: MealType) {
        if let mealToDelete = meals.first(where: { $0.mealType == type }) {
            viewContext.delete(mealToDelete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

extension CounterView {
    
    @ViewBuilder
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 5)
                .fill(Material.thickMaterial)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .shadow(radius: 2.0)
            
            
            VStack {
                // Top section with title, + & - buttons and count
                HStack {
                    Text(mealType.capitalisedName)
                        .padding(5)
                        .frame(alignment: .leading)
                        .font(.title3)
                    
                    Spacer()
                    Button(action: {
                        deleteMostRecentMeal(ofType: self.mealType)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: UILayout.dailyButtonSize, height: UILayout.dailyButtonSize)
                    }
                    .buttonStyle(CounterButtonStyle())
                    .disabled(isDecrementDisabled)
                    Text("\(countOfMeals(ofType: self.mealType))")
                        .font(.title3)
                        .foregroundColor(counterColor)
                        .padding(.horizontal, 10)
                    
                    Button(action: {
                        addMeal(ofType: self.mealType)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: UILayout.dailyButtonSize, height: UILayout.dailyButtonSize)
                    }
                    .buttonStyle(CounterButtonStyle())
                }
                .font(.largeTitle)
                .padding()
            }
        }
        
        var mealCount: Int {
            countOfMeals(ofType: self.mealType)
        }
        
        var isDecrementDisabled:Bool {
            mealCount == 0
        }
        
        
        var counterColor: Color {
            let overLimit =  false
            if overLimit {
                return .red
            } else {
                return .black
            }
        }
    }
}
