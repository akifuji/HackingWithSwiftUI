//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Akifumi Fujita on 2021/05/30.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var observableOrder: ObservableOrder

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $observableOrder.order.name)
                TextField("Street Address", text: $observableOrder.order.streetAddress)
                TextField("City", text: $observableOrder.order.city)
                TextField("Zip", text: $observableOrder.order.zip)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(observableOrder: observableOrder)) {
                    Text("Check out")
                }
                .disabled(!observableOrder.order.hasValidAddress)
            }
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(observableOrder: ObservableOrder())
    }
}
