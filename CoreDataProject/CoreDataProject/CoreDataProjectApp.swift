//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Akifumi Fujita on 2021/06/04.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
