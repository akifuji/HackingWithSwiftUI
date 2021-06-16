//
//  DetailView.swift
//  FaceList
//
//  Created by Akifumi Fujita on 2021/06/16.
//

import SwiftUI

struct DetailView: View {
    let faceImage: FaceImage
    
    var body: some View {
        VStack(alignment: .center) {
            faceImage.image
                .resizable()
                .scaledToFit()
            Text(faceImage.name)
            Text(faceImage.note)
            Spacer()
        }
        .padding(.horizontal)
    }
}
