//
//  JMChartView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 29.10.2022.
//

import SwiftUI

struct JMChartView: View {

    @Binding var isVisible: Bool
    @State var data: [KaplanModel]? = nil

    var body: some View {
        VStack {
            VStack {
                ZStack(alignment: .topLeading) {
                    Color(red: 208/255, green: 225/255, blue: 242/255, opacity: 0.4)
                        .edgesIgnoringSafeArea(.all)

                    ZStack {
                        LineChartView(
                            title: "АНАЛИЗ ВЫЖИВАЕМОСТИ",
                            chartData: LineChartData(
                                keys: ["S(t)", "S(t)-", "S(t)+"],
                                data: data ?? [KaplanModel(name: "0",
                                                           values: [0.0, 0.0, 0.0])]))
                    }
                }
                .frame(width: 900, height: 700)
            }

            Button("Cancel") {
                isVisible.toggle()
            }
        }
    }
}

struct JMChartView_Previews: PreviewProvider {
    static var previews: some View {
        JMChartView(isVisible: .constant(true))
    }
}
