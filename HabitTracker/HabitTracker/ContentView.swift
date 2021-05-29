//
//  ContentView.swift
//  HabitTracker
//
//  Created by Akifumi Fujita on 2021/05/29.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habits = Habits()
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.items) { habit in
                    HStack {
                        NavigationLink(destination: DetailView(habits: habits, habit: habit)) {
                            Text(habit.name)
                                .font(.headline)
                            Spacer()
                            Text("\(habit.amount)回")
                        }
                    }
                }
                .onDelete(perform: removeItems)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    EditButton()
                    Button(action: {
                        self.showingAddHabit = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddHabit) {
            AddView(habits: habits)
        }
    }
    
    private func removeItems(at offsets: IndexSet) {
        habits.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let habits = Habits()
        habits.items.append(Habit(name: "Drink water", description: "", amount: 0))
        return ContentView(habits: habits)
    }
}
