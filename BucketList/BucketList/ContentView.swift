//
//  ContentView.swift
//  BucketList
//
//  Created by Akifumi Fujita on 2021/06/11.
//

import SwiftUI
import LocalAuthentication
import MapKit

struct ContentView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var isUnlocked = false
    @State private var locations = [MKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false
    
    var body: some View {
        ZStack {
            MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill(Color.blue)
                .opacity(3)
                .frame(width: 32, height: 32)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        let newLocation = MKPointAnnotation()
                        newLocation.coordinate = centerCoordinate
                        newLocation.title = "Example location"
                        locations.append(newLocation)
                        selectedPlace = newLocation
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
        .alert(isPresented: $showingPlaceDetails) {
            Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information."), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                showingEditScreen = true
            })
        }
        .sheet(isPresented: $showingEditScreen) {
            if let selectedPlace = selectedPlace {
                EditView(placemark: selectedPlace)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                    } else {
                        
                    }
                }
            }
        } else {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension FileManager {
    static func save(_ file: String) {
        let url = self.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            try file.write(to: url, atomically: true, encoding: .utf8)
            let input = try String(contentsOf: url)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }
}
