//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Akifumi Fujita on 2021/06/23.
//

import SwiftUI

let HMBookTitle = ["風の歌を聴け", "1973年のピンボール", "羊をめぐる冒険", "世界の終りとハードボイルド・ワンダーランド", "ノルウェイの森", "ダンス・ダンス・ダンス", "国境の南、太陽の西", "ねじまき鳥クロニクル", "スプートニクの恋人", "海辺のカフカ", "アフターダーク", "1Q84", "色彩を持たない多崎つくると、彼の巡礼の年", "騎士団長殺し"]

struct ContentView: View {
    @State private var tappedIndex = 0
    
    var body: some View {
        VStack {
            Text("index: \(String(tappedIndex))")
            HStack(alignment: VerticalAlignment.arrowAlignment) {
                Image(systemName: "arrow.right.circle.fill")
                    .alignmentGuide(VerticalAlignment.arrowAlignment) { d in 10 }
                    .border(Color.red, width: 1)
                VStack(alignment: .leading) {
                    ForEach(0..<HMBookTitle.count) { index in
                        if index == tappedIndex {
                            Text(HMBookTitle[index])
                                .alignmentGuide(VerticalAlignment.arrowAlignment) {
                                   d in 10 }
                                .border(Color.black, width: 1)
                        } else {
                            Text(HMBookTitle[index])
                                .onTapGesture(perform: {
                                    tappedIndex = index
                                })
                                .border(Color.black, width: 1)
                        }
                    }
                }
                .border(Color.green, width: 1)
            }
            .border(Color.black, width: 1)
        }
    }
}

extension VerticalAlignment {
    private enum ArrowAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }
    static let arrowAlignment = VerticalAlignment(ArrowAlignment.self)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
