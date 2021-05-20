//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Akifumi Fujita on 2021/05/10.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correntAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = "0"
    @State private var spinAmount = 0.0
    @State private var opacityAmount: CGFloat = 0.0
    @State private var offsetAmount: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correntAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
//                        Image(self.countries[number])
//                            .renderingMode(.original)
//                            .clipShape(Capsule())
//                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
//                            .shadow(color: .black, radius: 2)
                        FlagImage(image: Image(self.countries[number]))
                            .rotation3DEffect(
                                .degrees(number == self.correntAnswer ? spinAmount : 0),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .blur(radius: number != self.correntAnswer ? opacityAmount : 0)
                            .offset(x: 0, y: offsetAmount)
                    }
                }
                Text("Current Score: \(userScore)")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
                self.opacityAmount = 0
                withAnimation {
                    self.offsetAmount = 0
                }
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correntAnswer {
            scoreTitle = "Correct"
            userScore = String(Int(userScore)! + 10)
            withAnimation {
                self.spinAmount += 360
                self.opacityAmount = 4
            }
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            withAnimation {
                self.offsetAmount = 1000
            }
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correntAnswer = Int.random(in: 0...2)
    }
}

struct FlagImage: View {
    let image: Image
    
    init(image: Image) {
        self.image = image
    }
    
    var body: some View {
        self.image
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //.environment(\.colorScheme, .dark)
    }
}
