//
//  AddView.swift
//  iExpense
//
//  Created by Akifumi Fujita on 2021/05/23.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Add new expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard let actualAmount = Int(self.amount) else {
                            self.alertTitle = "Invalid input"
                            self.alertMessage = "\(self.amount) is not a valid number"
                            self.showingAlert = true
                            return
                        }
                        let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                        self.expenses.items.append(item)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
