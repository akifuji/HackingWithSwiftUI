//
//  ContentView.swift
//  Drawing
//
//  Created by Akifumi Fujita on 2021/05/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Arc(startAngle: .degrees(0), endAngle: .degrees(120), clockwise: true)
                    .stroke(Color.blue, lineWidth: 10)
                    .frame(width: 300, height: 300)
    
                Triangle()
                    .fill(Color.red)
                    .frame(width: 300, height: 300)
                
//                Path { path in
//                    path.move(to: CGPoint(x: 200, y: 100))
//                    path.addLine(to: CGPoint(x: 100, y: 300))
//                    path.addLine(to: CGPoint(x: 300, y: 300))
//                    path.addLine(to: CGPoint(x: 200, y: 100))
//                    path.addLine(to: CGPoint(x: 100, y: 300))
//                }
//                .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//                .stroke(Color.blue.opacity(0.25), lineWidth: 10)
//                .fill(Color.blue)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CircleView()) {
                        Button("Next") {}
                    }
                }
            }
        }
    }
}

struct Arc: Shape, InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount: CGFloat = 0
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
