//
//  OverView.swift
//  Foodintake
//
//  Created by eoinkortext on 20/08/2023.
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
        return meals.filter { $0.type == type.rawValue }.count
    }
    
    
    private func addMeal(ofType type:MealType) {
        withAnimation {
            let newMeal = Meal(context: viewContext)
            newMeal.time = Date()
            newMeal.type = type.rawValue
            
            do {
                try viewContext.save()
            } catch {
                print("Failed to save newMeal \(newMeal) to context \(viewContext)")
            }
        }
    }
    
    
    func deleteMostRecentMeal(ofType type: String) {
        if let mealToDelete = meals.first(where: { $0.type == type }) {
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
                    Text(mealType.rawValue)
                        .padding(5)
                        .frame(alignment: .leading)
                    
                    Spacer()
                    
                    Button(action: {
                        deleteMostRecentMeal(ofType: self.mealType.rawValue)
                    }) {
                        Image(systemName: "minus.circle.fill")
                    }
                    .disabled(isDecrementDisabled)
                    Text("\(countOfMeals(ofType: self.mealType))")
                        .foregroundColor(counterColor)
                        .padding(.horizontal, 10)
                    Button(action: {
                        addMeal(ofType: self.mealType)
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
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
            let overLimit =  mealType.isOverLimit(for: mealCount)
            if overLimit {
                return .red
            } else {
                return .black
            }
        }
    }
}


struct UILayout {
    static let horizontalTileHeight = 65.0
}


struct ChartView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Chart View")
                .font(.headline)
        }
    }
}


struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Settings View")
                .font(.headline)
        }
    }
}



struct OverView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingPopover = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.time, ascending: false)],
        animation: .default)
    
    private var meals: FetchedResults<Meal>
    
    var body: some View {
        VStack {
            Spacer()
            ForEach(MealType.allCases, id: \.self) { type in
                CounterView(meals: Array(self.meals), mealType:type)
                    .frame(height:UILayout.horizontalTileHeight)
                    .padding([.bottom, .top], 10)
            }
            Spacer()
            Text(lastUpdatedText)
                .padding(.bottom, 8)
        }.popover(isPresented: $showingPopover, content: {
            SettingsView()
        })
        
        .toolbar {
            /// Cancel  button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingPopover = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
    }
    
 
    var lastUpdatedText: String {
        if let date = meals.first?.time {
            return "Last updated: \(date.shortFormattedDate)"
        }
        
        return ""
    }
}

extension OverView {
    
    private func mealsOnDay(_ day:Date, of type: MealType) {
        
    }
    
    private func mealsOnDay(_ day:Date) -> [Meal] {
        return  mealsOnDay(day, fromMeals: Array(self.meals) , forTimeZone: TimeZone.current)
    }
    
    private func mealsOnDay(_ day: Date, fromMeals meals: [Meal]) -> [Meal] {
        mealsOnDay(day, fromMeals: meals, forTimeZone: TimeZone.current)
    }
    
    private func mealsOnDay(_ day: Date, fromMeals meals: [Meal], forTimeZone timeZone: TimeZone) -> [Meal] {
        let calendar = Calendar.current
        
        // Convert target day to local start and end of day
        var components = calendar.dateComponents([.year, .month, .day], from: day)
        guard let startOfDay = calendar.date(from: components) else { return [] }
        
        components.day! += 1
        guard let startOfNextDay = calendar.date(from: components) else { return [] }
        
        return meals.filter { meal in
            // Convert meal's UTC date to target timezone
            let utcTimeZone = TimeZone(secondsFromGMT: 0)!
            
            guard let mealTime = meal.time else { return false }
            let utcDateComponents = calendar.dateComponents(in: utcTimeZone, from: mealTime)
            guard let userTimeZoneDate = calendar.date(from: utcDateComponents) else { return false }
            
            // Adjusting the date with the provided timezone offset
            let adjustedDate = userTimeZoneDate.addingTimeInterval(TimeInterval(timeZone.secondsFromGMT(for: userTimeZoneDate)))
            
            // Check if adjustedDate is within the desired day
            return adjustedDate >= startOfDay && adjustedDate < startOfNextDay
        }
    }
}

