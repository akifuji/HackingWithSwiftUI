//
//  ContentView.swift
//  Moonshot
//
//  Created by Akifumi Fujita on 2021/05/24.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var showingDate = true
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        Text(self.showingDate ? mission.formattedLaunchDate : self.getCrewNames(of: mission))
                    }
                }
            }
            .navigationTitle("Moonshot")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(self.showingDate ? "Show crew" : "Show date") {
                        self.showingDate.toggle()
                    }
                }
            }
        }
    }
    
    func getCrewNames(of mission: Mission) -> String {
        var matches = [String]()
        for crew in mission.crew {
            if let match = astronauts.first(where: { $0.id == crew.name }) {
                matches.append(match.name)
            }
        }
        return matches.joined(separator: ", ")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
