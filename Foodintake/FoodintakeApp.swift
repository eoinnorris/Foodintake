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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
