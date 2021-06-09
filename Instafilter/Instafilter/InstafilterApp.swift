//
//  InstafilterApp.swift
//  Instafilter
//
//  Created by Akifumi Fujita on 2021/06/08.
//

import SwiftUI

@main
struct InstafilterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
