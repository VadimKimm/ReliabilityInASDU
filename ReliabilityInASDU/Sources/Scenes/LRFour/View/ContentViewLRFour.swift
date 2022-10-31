//
//  ContentViewLRFour.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 25.10.2022.
//

import SwiftUI
import OrderedCollections
import Collections

struct ContentViewLRFour: View {

    @State var result = ""
    @State var S: String = "10"
    @State var V: String = "5"
    @State var K: String = "6"
    @State var millsResult: String = ""

    @State var m: String = "3" //число обнаруженных отказов между тестированием
    @State var N: String = "4" //число ошибок, первоначально присутствующих в программе
    @State var x: String = "1 2 3" //интервалы времени между отказами
    @State var T: String = "10" //продолжительность тестирования
    @State var jmResult: String = "" //продолжительность тестирования
    @State var dataForChart: OrderedDictionary<Double, Double>? = nil

    @State private var showingSheet = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                //Боковое меню
            }
            .frame(width: 80)
            .padding(.top, 40)

            VStack {
                VStack(spacing: 40) {
                    Text("Модель Миллса")
                        .font(.largeTitle)
                        .padding(.top, 20)

                    HStack(spacing: 40) {
                        VStack {
                            Text("𝑆 – количество искусственно внесенных ошибок")
                            TextField("", text: $S)
                                .frame(width: 50)
                                .foregroundColor(S.isNumeric ? .white : .red)
                        }

                        VStack {
                            Text("𝑉 – число обнаруженных искусственных ошибок")
                            TextField("", text: $V)
                                .frame(width: 50)
                                .foregroundColor(V.isNumeric ? .white : .red)
                        }

                        VStack {
                            Text("𝐾 – число обнаруженных естесственных ошибок")
                            TextField("", text: $K)
                                .frame(width: 100)
                                .foregroundColor(K.isNumeric ? .white : .red)
                        }
                    }
                    .font(.title3)

                    HStack {
                        Text("Вероятность того, что в программе нет ошибок:")

                        TextField("", text: $millsResult)
                            .frame(width: 70)

                        Button("press") {
                            calculateMills()
                        }
                    }
                }

                VStack(spacing: 40) {
                    Text("Модель Джелинского-Моранды")
                        .font(.largeTitle)
                        .padding(.top, 20)

                    HStack(spacing: 40) {
                        VStack {
                            Text("m – число обнаруженных отказов ПО за время тестирования")
                            TextField("", text: $m)
                                .frame(width: 50)
                                .foregroundColor(S.isNumeric ? .white : .red)
                        }

                        VStack {
                            Text("N – число ошибок, первоначально присутствующих в программе")
                            TextField("", text: $N)
                                .frame(width: 50)
                                .foregroundColor(S.isNumeric ? .white : .red)
                        }
                    }
                    .font(.title3)

                    HStack(spacing: 40) {
                        VStack {
                            Text("x - интервалы времени между отказами")
                            TextField("", text: $x)
                                .frame(width: 150)
                                .foregroundColor(S.isNumeric ? .white : .red)
                        }

                        VStack {
                            Text("T - продолжительность тестиррования")
                            TextField("", text: $T)
                                .frame(width: 50)
                                .foregroundColor(S.isNumeric ? .white : .red)
                        }
                    }
                    .font(.title3)

                    HStack {
                        Text("Вероятность того, что в программе нет ошибок:")

                        TextField("", text: $jmResult)
                            .frame(width: 150)

                        Button("press") {
                           calculateJM()
                        }
                    }

                    Button("Показать график") {
                        showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet) {
                        JMChartView(isVisible: $showingSheet,
                                    rawData: dataForChart)
                    }
                }

                Spacer()
            }
            .frame(width: 750)
        }
        .frame(minWidth: 1000, minHeight: 600)
    }
}

struct ContentViewLRFour_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewLRFour()
    }
}

//Mills functions
extension ContentViewLRFour {
    func calculateMills() {
        let s = Int(S) ?? 1 //𝑆 – количество искусственно внесенных ошибок
        let v = Int(V) ?? 1 //𝑉 – число обнаруженных искусственных ошибок
        let k = Int(K) ?? 1 //𝐾 – число обнаруженных естесственных ошибок
        let n = k * s / v //количество есстественных ошибок в коде

        let numTop = v - 1
        let numBot = s
        let denTop = v + n
        let denBot = s + n + 1

        guard numBot > numTop, denBot > denTop else {
            millsResult = "invalid input"
            return
        }

        let numerator = factorial(numBot) / (factorial(numTop) * factorial(numBot - numTop))
        let denominator = factorial(denBot) / (factorial(denTop) * factorial(denBot - denTop))
        let result = numerator / denominator
        millsResult = String(format: "%.6f", result > 1 ? 1 : result)
    }

    func factorial(_ n: Int) -> Double {
        (1...n).map(Double.init).reduce(1.0, *)
    }
}

//J-M functions
extension ContentViewLRFour {
    func calculateJM() {
        let array = x.convertToArray()
        let K = Double(m) ?? 1.0
        let N = Double(N) ?? 1.0
//        let T = Double(T) ?? 1.0
        var P = [String]()

        let B = calculateB(array: array)
        let A = calculateA(array: array)
        let Q = calculateQ(B: B, A: A, K: K)
        let C = calculateC(K: K, A: A, Q: Q, N: N)

        var valuesForChart: Deque<Double> = []
        var keysForChart: Deque<Double> = []

        for (_, time) in array.enumerated() {
            var pValue = exp(-(N - K) * C * time)

            if pValue > 1 {
                pValue = 1
            } else if pValue <= 0 {
                pValue = 0
            }

            keysForChart.append(time)
            valuesForChart.append(pValue)

            P.append(String(format: "%.2f", pValue))
        }

        valuesForChart.reverse()
        valuesForChart.prepend(1)
        keysForChart.prepend(0)
        dataForChart = OrderedDictionary(uniqueKeysWithValues: zip(keysForChart,
                                                            valuesForChart))


        let result = P.reversed().joined(separator: " ")
        jmResult = result
    }

    func calculateB(array: [Double]) -> Double {
        var result = Double()

        for (i, time) in array.enumerated() {
            result += Double(i + 1) * time
        }

        return result
    }

    func calculateA(array: [Double]) -> Double {
        array.reduce(0, +)
    }

    func calculateQ(B: Double, A: Double, K: Double) -> Double {
        B / (A * K)
    }

    func calculateC(K: Double, A: Double, Q: Double, N: Double) -> Double {
        (K / A) / (N + 1 - Q * K)
    }
}
