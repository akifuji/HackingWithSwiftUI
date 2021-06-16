//
//  EditView.swift
//  FaceList
//
//  Created by Akifumi Fujita on 2021/06/15.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var faceList = FaceList()
    @State private var name: String = ""
    @State private var note: String = ""
    let image: UIImage
    
    var body: some View {
        GeometryReader { geomery in
            VStack(alignment: .center) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geomery.size.width * 0.8)
                Form {
                    TextField("Name", text: $name)
                    TextField("Note", text: $note)
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    saveData()
                }) {
                    Text("Save")
                }
                .disabled(name.isEmpty)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveData() {
        let filename = getDocumentsDirectory().appendingPathComponent("FaceList")
        do {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("Unable to convert image into jpeg")
                return
            }
            let faceImage = FaceImage(id: UUID(), imageData: imageData, name: name, note: note)
            faceList.faceImages.append(faceImage)
            print(faceList.faceImages.count)
            let encodedData = try JSONEncoder().encode(faceList.faceImages)
            try encodedData.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Unable to save data")
        }
    }
}
