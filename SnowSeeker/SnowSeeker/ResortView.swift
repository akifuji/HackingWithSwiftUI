//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Akifumi Fujita on 2021/06/27.
//

import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct ResortView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @EnvironmentObject var favorites: Favorites
    @State private var selectedFacility: String?
    let resort: Resort
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
                    Text(resort.imageCredit)
                        .font(.caption)
                }
                
                HStack {
                    if sizeClass == .compact {
                        Spacer()
                        VStack { ResortDetailsView(resort: resort) }
                        Spacer()
                        VStack { SkiDetailsView(resort: resort) }
                        Spacer()
                    } else {
                        Spacer()
                        ResortDetailsView(resort: resort)
                        Spacer()
                        SkiDetailsView(resort: resort)
                        Spacer()
                    }
                }
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    Text("Faciliries")
                        .font(.headline)
                    HStack {
                        ForEach(resort.facilities) { facility in
                            Facility.icon(for: facility)
                                .font(.title)
                                .onTapGesture {
                                    selectedFacility = facility
                                }
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
                
                Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                    if favorites.contains(resort) {
                        favorites.remove(resort)
                    } else {
                        favorites.add(resort)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(Text("\(resort.name), \(resort.country)"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $selectedFacility) { facility in
            Facility.alert(for: facility)
        }
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.example)
    }
}
