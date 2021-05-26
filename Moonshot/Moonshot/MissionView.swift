//
//  MissionView.swift
//  Moonshot
//
//  Created by Akifumi Fujita on 2021/05/25.
//

import SwiftUI

struct MissionView: View {
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        var matches = [CrewMember]()
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaunt: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        self.astronaunts = matches
    }
    
    let mission: Mission
    let astronaunts: [CrewMember]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text(mission.formattedLaunchDate)
                    ForEach(self.astronaunts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaunt)) {
                            HStack {
                                Image(self.mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaunt.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer(minLength: 25)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Text(mission.description)
                        .padding(.top)
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle(Text(mission.displayName))
    }
    
    struct CrewMember {
        let role: String
        let astronaunt: Astronaut
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("mission.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
