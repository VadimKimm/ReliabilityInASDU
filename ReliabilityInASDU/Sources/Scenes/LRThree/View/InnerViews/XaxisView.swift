//
//  XaxisView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 19.10.2022.
//

import SwiftUI

struct XaxisView: View {

    var data: [KaplanModel]

    var body: some View {
        GeometryReader { gr in
            let labelWidth = (gr.size.width * 0.9) / CGFloat(data.count)
            let padWidth = (gr.size.width * 0.05) / CGFloat(data.count)
            ZStack {
                Rectangle()
                    .fill(Color(#colorLiteral(red: 0.8906477705, green: 0.9005050659, blue: 0.8208766097, alpha: 1)))

                Rectangle()
                    .fill(Color.black)
                    .frame(height: 1.5)
                    .offset(x: 0, y: -(gr.size.height/2.0))

                HStack(spacing:0) {
                    ForEach(data) { item in
                        Text(item.name)
                            .font(.footnote)
                            .foregroundColor(.black)
                            .frame(width:labelWidth, height: gr.size.height)
                    }
                    .padding(.horizontal, padWidth)
                }
            }
        }
    }
}
