//
//  ContentView.swift
//  Animations
//
//  Created by Akifumi Fujita on 2021/05/19.
//

import SwiftUI

struct ContentView: View {
    let letters = Array("Hello SwiftUI")
    //@State private var animationAmount: CGFloat = 1
    @State private var animationAmount = 0.0
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    @State private var isShowingRed = false
    
    var body: some View {
        print(animationAmount)
        
        return VStack {
            //Stepper("Scale amount", value: $animationAmount.animation(), in: 1...10)
            
            //Spacer()
            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200, height: 200)
                    //.transition(.asymmetric(insertion: .scale, removal: .opacity))
                    .transition(.pivot)
            }
                
            HStack(spacing: 0) {
                        ForEach(0..<letters.count) { num in
                            Text(String(self.letters[num]))
                                .padding(5)
                                .font(.title)
                                .background(self.enabled ? Color.blue : Color.red)
                                .offset(self.dragAmount)
                                .animation(Animation.default.delay(Double(num) / 20))
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { self.dragAmount = $0.translation }
                            .onEnded { _ in
                                self.dragAmount = .zero
                                self.enabled.toggle()
                            }
                    )
            
            LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 300, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(dragAmount)
                .gesture(
                    DragGesture()
                        .onChanged { self.dragAmount = $0.translation }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                self.dragAmount = .zero
                            }
                        }
                )
                //.animation(.spring())
            
            Button("Tap Me") {
                self.enabled.toggle()
            }
            .frame(width: 200, height: 200)
            .background(enabled ? Color.blue : Color.red)
            .animation(nil)
            .foregroundColor(.white)
            //.animation(.default)
            .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
            .animation(.interpolatingSpring(stiffness: 10, damping: 1))
            
            Button("Tap Me") {
                //self.animationAmount += 1
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                    self.animationAmount += 360
                    self.isShowingRed.toggle()
                }
            }
            .padding(50)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .rotation3DEffect(
                .degrees(animationAmount),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            //.scaleEffect(animationAmount)
            //.scaleEffect(animationAmount)
            //.blur(radius: (animationAmount - 1) * 3)
//            .overlay(
//                Circle()
//                    .stroke(Color.red)
//                    .scaleEffect(animationAmount)
//                    .opacity(Double(2 - animationAmount))
//                    .animation(
//                        Animation.easeOut(duration: 1)
//                            .repeatForever(autoreverses: false)
//                    )
//            )
//            .onAppear {
//                self.animationAmount = 2
//            }
        }
    }
}

struct CornerRotatedModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotatedModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotatedModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
