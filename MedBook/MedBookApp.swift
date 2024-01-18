//
//  MedBookApp.swift
//  MedBook
//
//  Created by Arrax on 17/01/24.
//

import SwiftUI

@main
struct MedBookApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
