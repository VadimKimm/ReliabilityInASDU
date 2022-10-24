//
//  ChartAreaView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 19.10.2022.
//

import SwiftUI

struct ChartAreaView: View {

    var data: [KaplanModel]
    var scaleFactor: Double

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0)
                .fill(Color(#colorLiteral(red: 0.8906477705, green: 0.9005050659, blue: 0.8208766097, alpha: 1)))

            ForEach(data[0].values.indices) { i in
                let list = data.map { $0.values[i] }
                LineShape(yValues: list, scaleFactor: scaleFactor)
                    .stroke(CustomColors.colors[i], lineWidth: 2.0)
            }
        }
    }
}
