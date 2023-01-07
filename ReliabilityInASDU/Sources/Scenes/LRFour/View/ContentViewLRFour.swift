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

    @State var m: String = "" //число обнаруженных отказов между тестированием
    @State var N: String = "" //число ошибок, первоначально присутствующих в программе
    @State var x: String = "" //интервалы времени между отказами
    //    @State var T: String = "10" //продолжительность тестирования
    @State var jmResult: String = ""
    @State var dataForChart: OrderedDictionary<Double, Double>? = nil

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var jmItems: FetchedResults<JMItem>

    @State private var showingSheet = false
    @Binding var selectedView: Int

    @State private var showingSaveView = false
    @State private var saveItemName = ""

    var body: some View {
        HStack {
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

                        Button("Рассчитать") {
                            calculateMills()
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true)

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

                        VStack {
                            Text("x - интервалы времени между отказами")
                            TextField("", text: $x)
                                .frame(width: 150)
                                .foregroundColor(S.isNumeric ? .white : .red)
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.title3)

                    HStack {
                        Text("Вероятность того, что в программе нет ошибок:")

                        TextField("", text: $jmResult)
                            .frame(width: 150)

                        Button("Рассчитать") {
                            calculateJM()
                        }

                        Button("Сохранить в файл") {
                            let text = makeStringToSave()
                            FileExporter.exportPDF(text: text)
                        }                    }

                    Button("Показать график") {
                        showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet) {
                        HStack(alignment: .top) {
                            JMChartView(isVisible: $showingSheet,
                                        rawData: dataForChart)

                            JMTableView(dataForTable: dataForChart)
                                .padding([.horizontal, .top], 20)
                                .frame(width: 300)
                        }
                    }
                }

                Spacer()
            }
            .padding(.leading, 20)
            .frame(width: 750)

            VStack(alignment: .leading) {
                List {
                    ForEach(jmItems) { item in
                        VStack(alignment: .leading) {
                            Text(item.name ?? "Unknown")
                            Text(item.date?.convertToExtendedString() ?? "Unknown")
                        }
                        .onTapGesture(count: 2, perform: {
                            setItemValues(of: item)
                        })
                    }
                    .onDelete(perform: removeJMItem(at: ))

                }

                Button("Сохранить в БД") {
                    showingSaveView.toggle()
                }
                .sheet(isPresented: $showingSaveView) {
                    SaveView(name: $saveItemName, isVisible: $showingSaveView, action: save)
                }

                Button("Сохранить в файл") {
                    let text = makeStringToSave()
                    FileExporter.exportPDF(text: text)
                }
            }
            .frame(width: 200)
            .padding(.all, 20)
        }
        .frame(minWidth: 1000, minHeight: 600)
        .navigationTitle("РАСЧЕТ НАДЕЖНОСТИ ПО")
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                Button {
                    selectedView = 0
                } label: {
                    Image(systemName: "arrow.left").imageScale(.large)
                }
            }
        }
    }
}

struct ContentViewLRFour_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewLRFour(selectedView: .constant(0))
    }
}

//CoreData functions

extension ContentViewLRFour {
    func removeJMItem(at offsets: IndexSet) {
        for index in offsets {
            let item = jmItems[index]
            moc.delete(item)
        }

        try? moc.save()
    }

    func save() {
        let jmItem = JMItem(context: moc)
        jmItem.name = saveItemName
        jmItem.date = Date()
        jmItem.x = x
        jmItem.m = m
        jmItem.n = N
        jmItem.probability = jmResult

        try? moc.save()
    }

    func setItemValues(of item: JMItem) {
        x = item.x ?? "1 2 3"
        m = item.m ?? "3"
        N = item.n ?? "4"
        jmResult = item.probability ?? "0.57 0.69 0.83"
        calculateJM()
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
        millsResult = String(format: "%.3f", result > 1 ? 1 : result)
    }

    func factorial(_ n: Int) -> Double {
        (1...n).map(Double.init).reduce(1.0, *)
    }
}

// MARK: - J-M functions

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

        var xValues: Deque<Double> = []
        var yValues: Deque<Double> = []

        for (_, time) in array.enumerated() {
            var pValue = exp(-(N - K) * C * time)

            if pValue > 1 {
                pValue = 1
            } else if pValue <= 0 {
                pValue = 0
            }

            xValues.append(time)
            yValues.append(pValue)

            P.append(String(format: "%.2f", pValue))
        }

        yValues.reverse()
        let exponentYValuesForChart = convertToExponent(xValues: xValues,
                                                        yValues: yValues)

        dataForChart = OrderedDictionary(uniqueKeysWithValues: zip(xValues, exponentYValuesForChart))

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

    func convertToExponent(xValues: Deque<Double>, yValues: Deque<Double>) -> Deque<Double> {
        var newValues = Deque<Double>()

        guard let x1 = xValues.first,
              let x2 = xValues.last,
              let y1 = yValues.first,
              let y2 = yValues.last
        else {
            return newValues
        }

        let b = log(y1 / y2) / (x1 - x2)
        let s = log(y1) - log(y1 / y2) * x1 / (x1 - x2)
        let c = exp(s)

        for x in xValues {
            let newValue = c * exp(b * x)
            newValues.append(newValue)
        }

        return newValues
    }
}

// MARK: - Save to file

extension ContentViewLRFour {
    func makeStringToSave() -> String {
        var text = "РАСЧЕТ НАДЕЖНОСТИ ПО\n\n"
        text += "Модель Миллса\n"
        text += " Количество искусственно внесенных ошибок, S: \(S)\n"
        text += " Число обнаруженных искусственных ошибок, V: \(V)\n"
        text += " Число обнаруженных естесственных ошибок, K: \(K)\n"
        text += "  Вероятность того, что в программе нет ошибок:: \(millsResult)\n\n"

        text += "Модель Джелинского-Моранды\n"
        text += " Число обнаруженных отказов ПО за время тестирования, m: \(m)\n"
        text += " Число ошибок, первоначально присутствующих в программе, N: \(N)\n"
        text += " Интервалы времени между отказами, x: \(x)\n"
        text += "  Вероятность того, что в программе нет ошибок: \(jmResult)"

        return text
    }
}
