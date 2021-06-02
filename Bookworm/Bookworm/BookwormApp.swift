//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Akifumi Fujita on 2021/06/01.
//

import SwiftUI

@main
struct BookwormApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
