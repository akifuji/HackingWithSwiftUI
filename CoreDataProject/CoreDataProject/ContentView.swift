//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Akifumi Fujita on 2021/06/04.
//

import SwiftUI
import CoreData

enum Predicate: String, CaseIterable {
    case beginsWith = "BEGINSWITH"
    case contains = "CONTAINS"
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter = "i"
    @State private var predicate = Predicate.contains

    var body: some View {
        NavigationView {
            VStack {
                FilteredList(predicate: predicate, filterKey: "lastName", filterValue: lastNameFilter, sortDescriptors: [ NSSortDescriptor(key: "lastName", ascending: true) ]) { (singer: Singer) in
                    Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
                }
                
                Picker("Predict", selection: $predicate) {
                    ForEach(Predicate.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Button("Add Examples") {
                    let taylor = Singer(context: moc)
                    taylor.firstName = "Taylor"
                    taylor.lastName = "Swift"
                    
                    let ed = Singer(context: moc)
                    ed.firstName = "Ed"
                    ed.lastName = "Sheeran"
                    
                    let adele = Singer(context: moc)
                    adele.firstName = "Adele"
                    adele.lastName = "Adkins"
                    
                    if moc.hasChanges {
                        try? moc.save()
                    }
                }

                TextField("Filter value", text: $lastNameFilter)
                
                NavigationLink(destination: CandyView()) {
                    Text("Go to CandyView")
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
