//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Akifumi Fujita on 2021/06/06.
//

import SwiftUI

@main
struct FriendFaceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
