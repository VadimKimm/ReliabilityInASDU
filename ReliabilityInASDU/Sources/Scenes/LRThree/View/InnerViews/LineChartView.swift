//
//  LineChartView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 19.10.2022.
//

import SwiftUI

struct LineChartView: View {

    var title: String
    var chartData: LineChartData

    let isShowingKey = true

    var body: some View {
        let data = chartData.data
        GeometryReader { gr in
            let headHeight = gr.size.height * 0.10
            let maxValue = data.flatMap { $0.values }.max()!
            let axisWidth = gr.size.width * 0.15
            let axisHeight = gr.size.height * 0.1
            let keyHeight = gr.size.height * (isShowingKey ? 0.1 : 0.0)
            let fullChartHeight = gr.size.height - axisHeight - headHeight - keyHeight

            let tickMarks = AxisParameters.getTicks(top: Int(maxValue))
            let scaleFactor = (fullChartHeight * 0.95) / CGFloat(tickMarks[tickMarks.count-1]) * 2

            VStack {
                ChartHeaderView(title: title)
                    .frame(height: headHeight)

                ZStack {
                    Rectangle()
                        .fill(Color(#colorLiteral(red: 0.8906477705, green: 0.9005050659, blue: 0.8208766097, alpha: 1)))

                    HStack {
                        VStack(spacing:0) {
                            if isShowingKey {
                                KeyView(keys: chartData.keys)
                                    .frame(height: keyHeight)
                            }

                            HStack(spacing:0) {
                                YaxisView(scaleFactor: Double(scaleFactor))
                                    .frame(width:axisWidth, height: fullChartHeight)
                                ChartAreaView(data: data, scaleFactor: Double(scaleFactor))
                                    .frame(height: fullChartHeight)
                            }

                            HStack(spacing:0) {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width:axisWidth, height:axisHeight)
                                XaxisView(data: data)
                                    .frame(height:axisHeight)
                            }
                        }

                        Spacer(minLength: 140)
                    }

                }
            }
        }
    }
}
