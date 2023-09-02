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
            populateDaysFromNow()
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
    
    private func daysMapping(_ days:[Day]) -> [Int:Day] {
        var result = [Int:Day]()
        for day in days {
            result[Int(day.daysSince1970)] = day
        }
        
        return result
    }
    
    
    private func middayOfDaySince1970(days: Int, locale: Locale) -> Date? {
        let secondsSince1970 = TimeInterval(days * 86400)  // 86400 seconds in a day
        let date = Date(timeIntervalSince1970: secondsSince1970)
        
        var calendar = Calendar.current
        calendar.locale = locale
        
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = 12
        
        return calendar.date(from: components)
    }


    
    private func populateDaysFromNow() {
        populateDaysPerWeek(from: Date.now)
    }
    
    
    private func populateDaysPerWeek(from date:Date) {
        let now = Date.now
        let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
        if let existingDays = try? viewContext.fetch(fetchRequest) {
            let dayMapping = daysMapping(existingDays)
            let epochDay = DateHelper.daysSince1970(from: now, withLocale: Locale.current)
            let nextWeek = epochDay + 7
            
            for nextDay in epochDay...nextWeek {
                if dayMapping[nextDay] == nil {
                    if let date = middayOfDaySince1970(days: nextDay, locale: Locale.current) {
                        saveDefaultMealTypes(for:date)
                    }
                }
            }
        }
    }
    
    private func saveDefaultMealTypes(for date:Date) {
        // Enumerate the DefaultMealTypeEnum
        for mealType in DefaultMealTypeEnum.allCases {
            
            let day = Day(context: viewContext)
            day.date = date
            day.daysSince1970 = Int32(DateHelper.daysSince1970(from: date, withLocale: Locale.current))
            
            // Create a new MealType managed object
            let newMealType = MealType(context: viewContext)
            newMealType.name = mealType.rawValue
            newMealType.max = Int16(mealType.maxLimit)
            newMealType.min =  Int16(mealType.minLimit)
                        
            
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

