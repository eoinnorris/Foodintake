//
//  FoodintakeApp.swift
//  Foodintake
//
//  Created by eoinkortext on 20/08/2023.
//

import SwiftUI

@main
struct FoodintakeApp: App {
    let persistenceController = PersistenceController.shared
    
 
    
    
    func getViewModel() -> CategoriesViewModel {
        let categories = Category.generateSampleCategories()
        return CategoriesViewModel(categories: categories)
    }
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
            TabView {
                    CategoriesView(viewModel: getViewModel())
                    .tabItem {
                        Label("Test", systemImage: "square")
                    }
                    DailyView()
                        .tabItem {
                            Label("Today", systemImage: "calendar.day.timeline.left")
                        }
                    ChartView()
                        .tabItem {
                            Label("Charts", systemImage: "chart.xyaxis.line")
                        }
                    PenaltyForm()
                        .tabItem {
                            Label("Category", systemImage: "rectangle.3.group.fill")
                        }
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
