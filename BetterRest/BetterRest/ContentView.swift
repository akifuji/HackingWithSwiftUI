//
//  ContentView.swift
//  BetterRest
//
//  Created by Akifumi Fujita on 2021/05/15.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var idealBedTime = ""
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var showingResult = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(showingResult ? "Your ideal bedtime is \n \(idealBedTime)" : "")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Form {
                    Section(header: Text("When do you want to wake up?")) {
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    Section(header: Text("Desired amount of sleep")) {
                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g") hours")
                        }
                    }
                    
                    Section(header: Text("Daily coffee intake")) {
    //                    Stepper(value: $coffeeAmount, in: 0...20) {
    //                        if coffeeAmount == 1 {
    //                            Text("1 cup")
    //                        } else {
    //                            Text("\(coffeeAmount) cups")
    //                        }
    //                    }
                        Picker("", selection: $coffeeAmount) {
                            ForEach(0..<21) {
                                if $0 == 1 {
                                    Text("1 cup")
                                } else {
                                    Text("\($0) cups")
                                }
                            }
                        }
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    self.showingResult = true
                })
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                Button(action: calculateBedtime) {
                    Text(showingResult ? "" : "Calculate")
                }
            )
        }
    }
    
    func calculateBedtime() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        let model = SleepCalculator()
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            idealBedTime = formatter.string(from: sleepTime)
            alertMessage = idealBedTime
            alertTitle = "Your ideal bedtime is..."
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
