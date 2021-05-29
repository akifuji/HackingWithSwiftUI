//
//  DetailView.swift
//  HabitTracker
//
//  Created by Akifumi Fujita on 2021/05/29.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var habits: Habits
    @State private var name: String
    @State private var description: String
    @State private var amount: String
    let habit: Habit
    
    init(habits: Habits, habit: Habit) {
        self.habits = habits
        self.habit = habit
        self.name = habit.name
        self.description = habit.description
        self.amount = String(habit.amount)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Title", text: $name)
                    TextField("Description", text: $description)
                    TextField("Amount", text: $amount)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Button(action: {
                        amount = String(Int(amount)! + 1)
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 60))
                    }
                    .padding()
                    Button(action: {
                        guard Int(amount)! > 0 else {
                            return
                        }
                        amount = String(Int(amount)! - 1)
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 60))
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Update") {
                        guard let amountInt = Int(amount) else {
                            return
                        }
                        let index = habits.items.firstIndex(where: { $0.id == habit.id })!
                        habits.items[index] = Habit(name: name, description: description, amount: amountInt)
                    }
                    Button(action: {
                        let index = habits.items.firstIndex(where: { $0.id == habit.id })!
                        habits.items.remove(at: index)
                    }) {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let habits = Habits()
        let habit = Habit(name: "Drink water", description: "Drink water every 2 hours", amount: 0)
        habits.items.append(habit)
        return DetailView(habits: habits, habit: habit)
    }
}
