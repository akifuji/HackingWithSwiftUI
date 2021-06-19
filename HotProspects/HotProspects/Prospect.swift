//
//  Prospect.swift
//  HotProspects
//
//  Created by Akifumi Fujita on 2021/06/18.
//

import SwiftUI

class Prospects: ObservableObject {
    enum SortType {
        case name, date
    }
    
    @Published fileprivate(set) var people: [Prospect]
    @Published var sortType = SortType.name
    static let saveKey = "SavedData"
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
//    init() {
//        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
//            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
//                self.people = decoded
//                return
//            }
//        }
//        self.people = []
//    }
    
    init() {
        let filename = Prospects.getDocumentsDirectory().appendingPathComponent(Prospects.saveKey)
        do {
            let data = try Data(contentsOf: filename)
            self.people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            self.people = []
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
//    private func save() {
//        if let encoded = try? JSONEncoder().encode(people) {
//            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
//        }
//    }
    
    private func save() {
        let filename = Prospects.getDocumentsDirectory().appendingPathComponent(Prospects.saveKey)
        if let encoded = try? JSONEncoder().encode(people) {
            try? encoded.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func change(_ sortType: SortType) {
        objectWillChange.send()
        self.sortType = sortType
    }
    
    func sorted() -> [Prospect] {
        switch sortType {
        case .name:
            return people.sorted { $0.name < $1.name }
        case .date:
            return people.sorted { $0.date > $1.date }
        }
    }
}

class Prospect: Identifiable, Codable {
    let id = UUID().uuidString
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    var date = Date()
}
