//
//  ContentView.swift
//  FaceList
//
//  Created by Akifumi Fujita on 2021/06/15.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var faceList = FaceList()
    @State private var showingImagePicker = false
    @State private var showingEditView = false
    @State private var newImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                List(faceList.faceImages) { faceImage in
                    NavigationLink(destination: DetailView(faceImage: faceImage)) {
                        HStack {
                            faceImage.image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                            Text(faceImage.name)
                        }
                    }
                }
                if let newImage = self.newImage {
                    NavigationLink(destination: EditView(faceList: faceList, image: newImage), isActive: $showingEditView) {}
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: { showingEditView = true }) {
                ImagePicker(image: $newImage)
            }
            .onAppear(perform: loadData)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("FaceList")
        do {
            let data = try Data(contentsOf: filename)
            faceList.faceImages = try JSONDecoder().decode([FaceImage].self, from: data)
        } catch {
            print("Unable to load saved data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
