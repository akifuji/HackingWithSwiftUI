//
//  FaceImage.swift
//  FaceList
//
//  Created by Akifumi Fujita on 2021/06/15.
//

import SwiftUI

class FaceList: ObservableObject {
    @Published var faceImages = [FaceImage]()
}

struct FaceImage: Identifiable, Codable {
    let id: UUID
    let imageData: Data
    let name: String
    let note: String
    
    var image: Image {
        Image(uiImage: UIImage(data: imageData)!)
    }
}
