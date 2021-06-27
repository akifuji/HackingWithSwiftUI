//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Akifumi Fujita on 2021/06/27.
//

import Foundation

class Favorites: ObservableObject {
    private var resorts: Set<String>
    private let saveKey = "Favorites"
    
    init() {
        if let savedResorts = UserDefaults.standard.stringArray(forKey: saveKey) {
            resorts = Set(savedResorts)
        } else {
            resorts = Set()
        }
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        UserDefaults.standard.set(Array(resorts), forKey: saveKey)
    }
}
