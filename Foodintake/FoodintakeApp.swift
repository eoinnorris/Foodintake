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

    var body: some Scene {
        WindowGroup {
            NavigationStack {
            TabView {
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
