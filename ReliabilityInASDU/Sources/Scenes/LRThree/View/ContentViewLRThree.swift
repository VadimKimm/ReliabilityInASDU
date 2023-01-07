//
//  ContentViewLRThree.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 18.10.2022.
//

import SwiftUI

struct ContentViewLRThree: View {

    @State var numberOfObjects: String = "10"
    @State var data: [KaplanModel]? = nil

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                VStack {
                    Text("Кол-во объектов:")
                    TextField("", text: $numberOfObjects)
                        .frame(width: 50)
                        .foregroundColor(numberOfObjects.isNumeric
                                         ? .white
                                         : .red)
                    Button("Tap") {
                        calculate(Int(numberOfObjects) ?? 10)
                    }
                }
            }
            .frame(width: 100)
            .padding(.top, 40)

            VStack {
                ZStack(alignment: .topLeading) {
                    Color(red: 208/255, green: 225/255, blue: 242/255, opacity: 0.4)
                        .edgesIgnoringSafeArea(.all)

                    ZStack {
                        LineChartView(
                            title: "АНАЛИЗ ВЫЖИВАЕМОСТИ",
                            chartData: KaplanLineChartData(
                                keys: ["S(t)", "S(t)-", "S(t)+"],
                                data: data ?? [KaplanModel(name: "0",
                                                           values: [0.0, 0.0, 0.0])]))
                    }
                }
                .frame(width: 900)
            }
        }
        .frame(minWidth: 1000, minHeight: 600)
    }
}

// MARK: - Calculate Kaplan Model

extension ContentViewLRThree {
    func calculate(_ objects: Int) {
        var _y = Double(objects)
        var _d = 0.0
        var s = 1.0
        var time = 0
        var sum = 0.0
        var dataArray: [KaplanModel] = []

        dataArray.append(KaplanModel(name: String(time),
                                     values: [1.0, 1.0, 1.0]))

        while _y > 1 {
            if Double.random(in: 0...1) < 0.2 {
                _d = 2
            } else if Double.random(in: 0...1) <= 0.5 {
                _d = 1
            } else {
                _d = 0
            }

            s = s  * (_y - _d) / _y
            sum = sum + _d / (_y * (_y - _d))
            let sigma = s * sqrt(sum)
            let leftS = s - sigma * 1.96
            let rightS = s + sigma * 1.96

            dataArray.append(KaplanModel(name: String(time),
                                         values: [s,
                                                  leftS >= 1 ? 1 : leftS,
                                                  rightS >= 1 ? 1 : rightS]))

            time += 1
            _y -= _d
        }

        self.data = dataArray
    }
}
