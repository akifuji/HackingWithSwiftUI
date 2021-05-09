//
//  ContentView.swift
//  UnitConverter
//
//  Created by Akifumi Fujita on 2021/05/09.
//

import SwiftUI

struct ContentView: View {
    let lengthUnit: [UnitLength] = [.meters, .kilometers, .feet, .yards, .miles]
    let lengthUnitString = ["meters", "kilometers", "feet", "yard", "miles"]
    
    @State private var inputUnit = 0
    @State private var outputUnit = 0
    @State private var inputValue = ""
    
    var inputMeasurementValue: Measurement<UnitLength> {
        let valueDouble = Double(inputValue) ?? 0
        return Measurement(value: valueDouble, unit: lengthUnit[inputUnit])
    }
    
    var convertedValue: Double {
        return inputMeasurementValue.converted(to: lengthUnit[outputUnit]).value
    }
    
    var body: some View {
        Form {
            Section(header: Text("Input unit")) {
                Picker("Input unit", selection: $inputUnit) {
                    ForEach(0 ..< lengthUnit.count) {
                        Text("\(self.lengthUnitString[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Output unit")) {
                Picker("Output unit", selection: $outputUnit) {
                    ForEach(0 ..< lengthUnit.count) {
                        Text("\(self.lengthUnitString[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Before conversion")) {
                TextField("0", text: $inputValue)
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text("After conversion")) {
                Text("\(convertedValue)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .dark)
    }
}
