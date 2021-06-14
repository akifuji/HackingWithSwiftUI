//
//  ContentView.swift
//  Accessibility
//
//  Created by Akifumi Fujita on 2021/06/14.
//

import SwiftUI

struct ContentView: View {
    static let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]
    
    static let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks",
    ]
    
    @State private var selectedPicture = Int.random(in: 0...3)
    @State private var estimate = 25.0
    @State private var rating = 3
    
    var body: some View {
        VStack {
            Image(ContentView.pictures[selectedPicture])
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    selectedPicture = Int.random(in: 0...3)
                }
                .accessibility(label: Text(ContentView.labels[selectedPicture]))
                .accessibility(addTraits: .isButton)
                .accessibility(removeTraits: .isImage)
            
            Image(decorative: "character")
                .accessibility(hidden: true)
            
            VStack {
                Text("Your score is")
                Text("1000")
                    .font(.title)
            }
            //.accessibilityElement(children: .combine)
            .accessibilityElement(children: .ignore)
            .accessibility(label: Text("Your score is 1000"))
            
            Slider(value: $estimate, in: 0...50)
                .padding()
                .accessibility(value: Text("\(Int(estimate))"))
            
            Stepper("Rate our service: \(rating)/5", value: $rating, in: 1...5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
