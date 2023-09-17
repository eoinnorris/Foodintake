//
//  CounterView.swift
//  Foodintake
//
//  Created by eoinkortext on 30/08/2023.
//

import SwiftUI

struct CounterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var mealType: MealType
    @State private var count:Int = 0
}


// functions
extension CounterView {
    
    private func addMeal(ofType mealType:MealType) {
        withAnimation {
            let now = Date.now
            
            mealType.count =  mealType.count + 1
            mealType.time = now
            
            if mealType.day == nil {
                let day = Day(context: viewContext)
                day.date = now
                day.daysSince1970 = Int32(DateHelper.daysSince1970(from: now, withLocale: Locale.current))
                day.addToMeals(mealType)
            }
            
            count = Int(mealType.count)
            
            do {
                try viewContext.save()
            } catch {
                print("Failed to save newMeal \(mealType) to context \(viewContext)")
            }
        }
    }
    
    
    func deleteMostRecentMeal(ofType mealType: MealType) {
        withAnimation {
            mealType.count =  mealType.count - 1
            count = Int(mealType.count)
            
            do {
                try viewContext.save()
            } catch {
                print("Failed to save newMeal \(mealType) to context \(viewContext)")
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
                    .buttonStyle(CounterButtonStyle(mealType: mealType,
                                                    buttonDirection: .decrement))
                    .disabled(isDecrementDisabled)
                    Text("\(mealType.count)")
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
                    .buttonStyle(CounterButtonStyle(mealType: mealType,
                                                    buttonDirection: .increment))
                }
                .font(.largeTitle)
                .padding()
            }.onAppear {
                count = Int(mealType.count)
            }
        }
        
        var isDecrementDisabled:Bool {
            count == 0
        }
                
        var isOverLimit: Bool {
            return mealType.count > mealType.max
        }
                
        var counterColor: Color {
            if isOverLimit {
                return .red
            } else {
                return .black
            }
        }
    }
}

