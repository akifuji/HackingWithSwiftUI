//
//  CircleView.swift
//  Drawing
//
//  Created by Akifumi Fujita on 2021/05/27.
//

import SwiftUI

struct CircleView: View {
    var body: some View {
        NavigationView {
            Circle()
                .strokeBorder(Color.blue, lineWidth: 40)
                .toolbar {
                    NavigationLink(destination: FlowerView()) {
                        Button("Flower") {}
                    }
                }
        }
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView()
    }
}
