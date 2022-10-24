//
//  YaxisView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 19.10.2022.
//

import SwiftUI

struct YaxisView: View {

//    var ticks: [Int]
    var ticks = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.7, 0.8, 0.9, 1]
    var scaleFactor: Double

    var body: some View {
        GeometryReader { gr in

            let fullChartHeight = gr.size.height

            ZStack {
                // y-axis line
                Rectangle()
                    .fill(Color.black)
                    .frame(width:1.5)
                    .offset(x: (gr.size.width / 2.0) - 1, y: 1)

                // Tick marks
                ForEach(ticks, id:\.self) { tick in
                    HStack {
                        Spacer()
                        Text("\(tick)")
                            .font(.footnote)
                            .foregroundColor(.black)
                        Rectangle()
                            .frame(width: 10, height: 1)
                            .foregroundColor(.black)
                    }
                    .offset(y: (fullChartHeight / 2.0) - (CGFloat(tick) * CGFloat(scaleFactor)))
                }
            }
        }
    }
}
