//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Akifumi Fujita on 2021/05/30.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var observableOrder = ObservableOrder()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $observableOrder.order.type) {
                        ForEach(0..<Order.types.count) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper(value: $observableOrder.order.quantity, in: 3...20) {
                        Text("Number of cakes: \(observableOrder.order.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $observableOrder.order.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }
                    
                    if observableOrder.order.specialRequestEnabled {
                        Toggle(isOn: $observableOrder.order.extraFrosting) {
                            Text("Add extra frosting")
                        }

                        Toggle(isOn: $observableOrder.order.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: AddressView(observableOrder: observableOrder)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
