//
//  AstronautView.swift
//  Moonshot
//
//  Created by Akifumi Fujita on 2021/05/26.
//

import SwiftUI

struct AstronautView: View {
    init(astronaut: Astronaut) {
        self.astronaut = astronaut
        let missions: [Mission] = Bundle.main.decode("missions.json")
        var matches = [String]()
        for mission in missions {
            for member in mission.crew {
                if member.name == astronaut.id {
                    matches.append(mission.displayName)
                }
            }
        }
        self.missionNames = matches
    }
    
    let astronaut: Astronaut
    let missionNames: [String]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    Text(self.astronaut.description)
                        .padding()
                    
                    Text("Apollo programs - \(self.missionNames.joined(separator: ", "))")
                        .padding(.leading)
                }
            }
        }
        .navigationTitle(Text(astronaut.name))
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
