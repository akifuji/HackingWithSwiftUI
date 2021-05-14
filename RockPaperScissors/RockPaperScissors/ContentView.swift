//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Akifumi Fujita on 2021/05/15.
//

import SwiftUI

struct ContentView: View {
    let moves = ["Rock", "Paper", "Scissors"]
    @State private var currentMove = Int.random(in: 0...2)
    @State private var userShouldWin = Bool.random()
    @State private var userPickeedMove = 0
    @State private var showingResult = false
    @State private var alertTitle = ""
    @State private var userScore = "0"
    @State private var roundCount = 1
    
    var body: some View {
        VStack {
            Text("Round \(roundCount)")
            Text("Your score: \(userScore)")
            Text("Current choice: \(self.moves[currentMove])")
            Text("You should \(userShouldWin ? "win!" : "loose!")")
            HStack {
                ForEach(0 ..< self.moves.count) { number in
                    Button(self.moves[number]) {
                        self.buttonTapped(number)
                    }
                    .padding()
                }
                .alert(isPresented: $showingResult) {
                    Alert(title: Text(self.alertTitle), message: Text(roundCount == 10 ? "You final score is \(userScore)" : ""), dismissButton: .default(Text("Continue")) {
                        if roundCount < 10 {
                            self.askQuestion()
                        } else {
                            userScore = "0"
                            roundCount = 1
                        }
                    })
                }
            }
        }
    }
    
    func buttonTapped(_ number: Int) {
        if didUserWin(userMove: number) == userShouldWin {
            self.alertTitle = "Correct!"
            self.userScore = "\(Int(self.userScore)! + 10)"
        } else {
            self.alertTitle = "Wrong!"
            self.userScore = "\(Int(self.userScore)! - 10)"
        }
        showingResult = true
    }
    
    func askQuestion() {
        self.roundCount += 1
        self.currentMove = Int.random(in: 0...2)
        self.userShouldWin = Bool.random()
    }
    
    func didUserWin(userMove: Int) -> Bool {
        switch userMove {
        case 0:
            return self.currentMove == 2
        case 1:
            return self.currentMove == 0
        case 2:
            return self.currentMove == 1
        default:
            return false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
