//
//  ReplacementPlanView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 30.11.2022.
//

import SwiftUI

struct ReplacementPlanView: View {

    var subsystems: [SubsystemBlock]
    @State private var showForecastView = false
    @Binding var isVisible: Bool

    var body: some View {
        VStack {
            Text("План замены деталей")
                .font(.title)
                .bold()

            ScrollView(.vertical, showsIndicators: false) {
                ForEach(0..<subsystems.count, id: \.self) { index in
                    VStack {
                        Text("Подсистема №\(index + 1)")
                            .font(.title2)
                            .bold()
                            .padding()
                        VStack(spacing: 30) {
                            ForEach(subsystems[index].elements) { element in
                                VStack(alignment: .leading) {
                                    Text(element.title)
                                        .bold()
                                    Text("Дата установки: \(element.installationDate.convertToString())")
                                    Text("Дата замены: \(element.dateToReplacement?.convertToExtendedString() ?? Date().convertToExtendedString())")
                                    Text("Требуемая надежность \(String(format: "%.3f", element.requiredReliability ?? 1))")
                                    ElementChartView(rawData: element.dataForChart)
                                }
                                .padding()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .border(.white)
                }

                Spacer()
            }

            HStack {
                Button("Прогноз количества замен элементов") {
                    showForecastView = true
                }

                Button("Закрыть") {
                    isVisible = false
                }
            }
            .sheet(isPresented: $showForecastView) {
                ForecastElementReplacementView(subsystems: subsystems, isVisible: $showForecastView)
            }
        }
        .padding()
    }
}
