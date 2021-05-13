//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Akifumi Fujita on 2021/05/12.
//

import SwiftUI

struct ContentView: View {
    @State private var useRedColor = false
    
    var body: some View {
        VStack {
            Text("ViewsAndModifiers")
                .prominentTitled()
            
            VStack {
                Text("Gryffindor")
                    .font(.largeTitle)
                Text("Hufflepuff")
                    .blur(radius: 1)
                Text("Ravenclaw")
                Text("Slytherin")
            }
            .font(.title)
            .blur(radius: 2)
            
            Button("Hello World") {
                print(type(of: self.body))
                self.useRedColor.toggle()
            }
            .frame(width: 200, height: 200)
            .background(useRedColor ? Color.red : Color.blue)
            
            Text("Hello World")
                .padding()
                .background(Color.red)
                .padding()
                .background(Color.blue)
                .padding()
                .background(Color.green)
                .padding()
                .background(Color.yellow)
            
            Color.blue
                .frame(width: 300, height: 200)
                .watermarked(with: "Hacking with Swift")
        }
    }
}

struct Watermark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black)
        }
    }
}

struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.blue)
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
    func prominentTitled() -> some View {
        self.modifier(ProminentTitle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //.environment(\.colorScheme, .dark)
    }
}
