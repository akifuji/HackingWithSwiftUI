//
//  EditView.swift
//  BucketList
//
//  Created by Akifumi Fujita on 2021/06/12.
//

import SwiftUI
import MapKit

enum LoadingState {
    case loading, loaded, failed
}

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placemark: MKPointAnnotation
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $placemark.wrappedTitle)
                    TextField("Description", text: $placemark.wrappedSubtitle)
                }
                Section(header: Text("Nearby...")) {
                    if loadingState == .loaded {
                        List(pages, id: \.pageid) { page in
                            HStack {
                                Text(page.title)
                                    .font(.headline)
                                + Text(": ")
                                Text(page.description)
                                    .italic()
                            }
                        }
                    } else if loadingState == .loading {
                        Text("Loading...")
                    } else {
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Edit place")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear(perform: fetchNearbyPlaces)
        }
    }
    
    private func fetchNearbyPlaces() {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placemark.coordinate.latitude)%7C\(placemark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No data was responded")
                loadingState = .failed
                return
            }
            
            let decoder = JSONDecoder()
            
            guard let items = try? decoder.decode(Result.self, from: data) else {
                print("Decode failed")
                loadingState = .failed
                return
            }
            
            pages = Array(items.query.pages.values).sorted()
            loadingState = .loaded
        }.resume()
    }
}
