//
//  ContentView.swift
//  Multiplication
//
//  Created by Akifumi Fujita on 2021/05/21.
//

import SwiftUI

struct ContentView: View {
    private let questionCounts = ["5", "10", "20", "ALL"]
    @State private var playingGame = false
    @State private var lowerLimit = 1
    @State private var upperLimit = 12
    @State private var questionCountIndex = 1
    @State private var numPairs: [(Int, Int)] = []
    @State private var currentPairIndex = 0
    @State private var inputAnswer = ""
    @State private var answeredQuestions: [String] = []
    @State private var score = "0"
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if playingGame {
                    VStack {
                        TextField("Enter your answer", text: $inputAnswer, onCommit: enterAnswer)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        List(answeredQuestions, id: \.self) {
                            Text($0)
                        }
                    }
                }
                if !playingGame {
                    VStack {
                        Form {
                            Section(header: Text("Multiplication with the numbers from \(lowerLimit) to \(upperLimit)")) {
                                Stepper("Lower number", value: $lowerLimit, in: 1...upperLimit-1)
                                Stepper("Upper number", value: $upperLimit, in: lowerLimit+1...12)
                            }
                            Section(header: Text("How many questions do you want?")) {
                                Picker("How many questions do you want?", selection: $questionCountIndex) {
                                    ForEach(0..<questionCounts.count) {
                                        Text(self.questionCounts[$0])
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        Button("Game start") {
                            self.startGame()
                        }
                    }
                }
            }
            .navigationBarTitle(playingGame ? generateQuestion(from: numPairs[currentPairIndex]) : "Settings")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    
                })
            }
        }
    }
    
    private func enterAnswer() {
        guard let inputAnswerInt = Int(inputAnswer) else {
            return
        }
        let numPair = numPairs[currentPairIndex]
        let answer = numPair.0 * numPair.1
        if inputAnswerInt == answer {
            answeredQuestions.insert("\(generateQuestion(from: numPair)) = \(inputAnswer) ✅", at: 0)
            score = String(Int(score)! + 1)
        } else {
            answeredQuestions.insert("\(generateQuestion(from: numPair)) = \(inputAnswer) ❌", at: 0)
        }
        inputAnswer = ""
        
        if questionCounts[questionCountIndex] == "ALL" {
            if (currentPairIndex + 1) == questionCounts.count {
                finishGame()
                return
            }
        } else if (currentPairIndex + 1) == Int(questionCounts[questionCountIndex])! {
            finishGame()
            return
        }
        currentPairIndex += 1
    }
    
    private func finishGame() {
        alertTitle = "Finish!"
        alertMessage = "Your score is \(score)"
        showingAlert = true
    }
    
    private func startGame() {
        playingGame = true
        for i in lowerLimit...upperLimit {
            for j in lowerLimit...upperLimit {
                numPairs.append((i, j))
            }
        }
        numPairs.shuffle()
    }
    
    private func generateQuestion(from numPair: (Int, Int)) -> String {
        "\(String(numPair.0)) * \(String(numPair.1))"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
