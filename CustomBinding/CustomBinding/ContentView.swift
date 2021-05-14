//
//  ContentView.swift
//  CustomBinding
//
//  Created by Akifumi Fujita on 2021/05/13.
//

import SwiftUI

struct ContentView: View {
    @State private var agreedToTerms = false
    @State private var agreedToPrivacyPolicy = false
    @State private var agreedToEmails = false
    
    var body: some View {
        let agreeToAll = Binding<Bool>(
            get: {
                self.agreedToTerms && self.agreedToPrivacyPolicy && self.agreedToEmails
            },
            set: {
                self.agreedToTerms = $0
                self.agreedToPrivacyPolicy = $0
                self.agreedToEmails = $0
            }
        )
        
        return VStack {
            Toggle(isOn: $agreedToTerms) {
                Text("Agree to terms")
            }
            Toggle(isOn: $agreedToPrivacyPolicy) {
                Text("Agree to privacy policy")
            }
            Toggle(isOn: $agreedToEmails) {
                Text("Agree to receve shipping emails")
            }
            Toggle(isOn: agreeToAll) {
                Text("Agree to all")
            }
        }
        .padding(50)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
