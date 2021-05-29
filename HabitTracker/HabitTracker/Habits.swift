//
//  Habits.swift
//  HabitTracker
//
//  Created by Akifumi Fujita on 2021/05/29.
//

import Foundation

class Habits: ObservableObject {
    init() {
        if let items = UserDefaults.standard.data(forKey: "items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Habit].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
    
    @Published var items = [Habit]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "items")
            }
        }
    }
}

struct Habit: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let amount: Int
    
    init(name: String, description: String, amount: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.amount = amount
    }
}
