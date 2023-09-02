//
//  OverView.swift
//  Foodintake
//
//  Created by eoinkortext on 20/08/2023.
//

import SwiftUI
import CoreData




struct UILayout {
    static let horizontalTileHeight = 50.0
    static let dailyButtonSize = 25.0

}

struct WelcomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: false)],
        animation: .none)
    
    private var days: FetchedResults<Day>
    
    
    var body: some View {
        VStack {
            Text("Welcome")
                .font(.largeTitle)
                .padding(10.0)
            Text(today)
                .font(.subheadline)
            Menu("Today") {
                ForEach(days, id: \.id) { day in
                    Text(day.dateOrNow.dayNameAndDate)
                }
            }
        }
    }
    
    var today: String {
        Date.now.dayNameAndDate
    }
}


struct DailyView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingPopover = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MealType.name, ascending: true)],
        animation: .none)
    
    private var mealTypes: FetchedResults<MealType>

    
    var body: some View {
        VStack {
            WelcomeView()
                .padding(.bottom, 10)
            ForEach(mealTypes, id: \.id) { type in
                CounterView(mealType:type)
                    .frame(height:UILayout.horizontalTileHeight)
                    .padding([.bottom, .top], 10)
            }
            Spacer()
            Text(lastUpdatedText)
                .padding(.bottom, 8)
        }.onAppear() {
            saveDefaultMealTypes()
        }
        .popover(isPresented: $showingPopover, content: {
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
        if let date = mealTypes.first?.day?.date {
            return "Last updated: \(date.shortFormattedDate)"
        }
        
        return ""
    }
}

extension DailyView {
    
    func deleteAllMealTypes() {
        // Fetch all MealType objects
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MealType.fetchRequest()
        
        // Create a batch delete request to delete all fetched objects
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            // Execute the delete request on the context
            try viewContext.execute(deleteRequest)
            
            // Save changes after deletion
            try viewContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    private func saveDefaultMealTypes() {
        // Enumerate the DefaultMealTypeEnum
        for mealType in DefaultMealTypeEnum.allCases {
            
            // Check if the meal type already exists
            let fetchRequest: NSFetchRequest<MealType> = MealType.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", mealType.rawValue)
            let existingMealTypes = try? viewContext.fetch(fetchRequest)
            
            if let existingMealType = existingMealTypes?.first {
                if  mealType.rawValue == existingMealType.name {
                    // If the meal type already exists, we skip adding it again
                    continue
                }
            }
            
            // Create a new MealType managed object
            let newMealType = MealType(context: viewContext)
            newMealType.name = mealType.rawValue
            newMealType.max = Int16(mealType.maxLimit)
            newMealType.min =  Int16(mealType.minLimit)

            
//            // Check if the category 'food' already exists
//            let categoryFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
//            categoryFetchRequest.predicate = NSPredicate(format: "name == %@", "food")
//            let existingCategories = try? viewContext.fetch(categoryFetchRequest)
//
//            if let existingCategory = existingCategories?.first {
//                newMealType.category = existingCategory
//            } else {
//                // Create a new Category managed object if it doesn't exist
//                let newCategory = Category(context: viewContext)
//                newCategory.name = "food"
//                newCategory.show = true
//                newMealType.category = newCategory
//            }
            
            // Save the context
            do {
                try viewContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    private func mealsOnDay(_ day:Date) -> [MealType] {
        []
//        return  mealsOnDay(day, fromMeals: Array(self.meals) , forTimeZone: TimeZone.current)
    }
    
    private func mealsOnDay(_ day: Date, fromMeals meals: [MealType]) -> [MealType] {
        mealsOnDay(day, fromMeals: meals, forTimeZone: TimeZone.current)
    }
    
    private func mealsOnDay(_ day: Date, fromMeals meals: [MealType], forTimeZone timeZone: TimeZone) -> [MealType] {
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

