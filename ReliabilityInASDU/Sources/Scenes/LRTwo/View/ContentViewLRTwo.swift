//
//  NewContentViewLRTwo.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 28.11.2022.
//

import SwiftUI
import OrderedCollections
import Collections

struct ContentViewLRTwo: View {
    
    @Binding var selectedView: Int
    @State var subsystems = [SubsystemBlock]()
    @State private var targetReliabilityFactor = "0.95"
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showReplacementPlan = false

    var body: some View {
        HStack {
            VStack {
                //Верхний стэк
                VStack {
                    Text(subsystems.isEmpty ? "Добавьте подсистемы" : "Схема")
                        .font(.title)
                        .bold()

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(subsystems.indices, id: \.self) { index in
                                VStack {
                                    Text("Подсистема №\(index + 1)")
                                        .bold()
                                        .font(.title3)
                                        .padding(.top, 10)
                                    SubsystemView(selectedItem: $subsystems[index],
                                                  isVisible: $subsystems[index].isSelected)

                                    Button(role: .destructive) {
                                        subsystems.removeAll(where: {$0.id == $subsystems[index].id})
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                            .foregroundColor(.red)
                                    }

                                    SubsystemComponentsView(subsystem: $subsystems[index])
                                }
                                .border(.white)
                                .sheet(isPresented: $subsystems[index].isSelected) {
                                    SubsystemEditBlockView(isVisible: $subsystems[index].isSelected,
                                                           subsystem: $subsystems[index])
                                }
                            }
                            .padding(5)
                        }
                    }
                    .frame(width: 730, height: 440)
                    .border(.white)
                    .sheet(isPresented: $showReplacementPlan) {
                        ReplacementPlanView(subsystems: subsystems, isVisible: $showReplacementPlan)
                    }
                }

                .alert("Ошибка", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {
                        showAlert.toggle()
                    }
                } message: {
                    Text(alertMessage)
                }

                //Нижний стэк
                VStack() {
                    HStack {
                        Text("Критич. уровень надежности")
                            .font(.title3)
                            .padding(.horizontal, 10)
                        TextField("", text: $targetReliabilityFactor)
                            .frame(width: 60)
                        Button("Сформировать план") {
                            makePlan()

                            guard !subsystems.isEmpty else { return }
                            showReplacementPlan.toggle()
                        }
                        .frame(width: 200)
                        .padding(.leading, 230)
                    }
                }
                .padding(.top, 20)
            }
            .frame(width: 750)

            // TODO: тут должны быть кнопки для сохранения/импорта в базу данных
            VStack(alignment: .leading) {
                Button(role: .cancel) {
                    subsystems.append(SubsystemBlock(type: .firstType))
                } label: {
                  Label("Добавить", systemImage: "plus")
                }

                Spacer()

            }
            .frame(width: 150)
            .padding(.top, 40)
            .padding(.trailing, 20)
        }
        .frame(minWidth: 1000, minHeight: 600)
        .navigationTitle("НАДЕЖНОСТЬ ТЕХНОЛОГИЧЕСКОГО ОБОРУДОВАНИЯ. ПОСТРОЕНИЕ ПЛАНА ЗАМЕНЫ ОБОРУДОВАНИЯ")
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

struct ContentViewLRTwo_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewLRTwo(selectedView: .constant(0))
    }
}

// MARK: - Make plan

extension ContentViewLRTwo {
    func makePlan() {
        guard !subsystems.isEmpty else {
            alertMessage = "Количество подсистем равно 0. Добавьте подсистемы."
            showAlert.toggle()
            return
        }

        let numberOfSubsystems = subsystems.count
        let Pdesired = calculatePdesired(numberOfSubsystems: numberOfSubsystems)

        for (number, subsystem) in subsystems.enumerated() {
            var arrayOfPi = [Double]()
            print("Подсистема #\(number + 1)")

            switch subsystem.type {
            case .firstType:
                let _ = calculatePForFirstType(Pdesired: Pdesired).map { arrayOfPi.append($0) }
            case .secondType:
                let _ = calculatePForSecondType(Pdesired: Pdesired).map { arrayOfPi.append($0) }
            case .thirdType:
                let _ = calculatePForThirdType(Pdesired: Pdesired).map { arrayOfPi.append($0) }
            case .fourthType:
                let _ = calculatePForFourthType(Pdesired: Pdesired).map { arrayOfPi.append($0) }
            }

            let timeToReplacement = calculateTimeToReplacementForElements(subsystem, arrayOfPi: arrayOfPi)
            let dateToReplacement = calculateDateToReplacementForElements(subsystem, timeStamp: timeToReplacement)
            let chartData = createChartDataForElements(subsystem, timeToReplacement: timeToReplacement)

            for (index, time) in timeToReplacement.enumerated() {
//                print("Требуемая надежность элемента \(index + 1) - \(arrayOfPi[index])")
                print("Время до замены элемента \(index + 1) - \(time)")
//                print("Дата замены элемента \(index + 1) - \(dateToReplacement[index].convertToString())")

//                let chartData = createChartDataForElement(for: time,
//                                                          intensityMistakes: Double(subsystem.elements[index].intensityMistakes) ?? 0.01,
//                                                          installationDate: subsystem.elements[index].installationDate)
                subsystem.elements[index].dateToReplacement = dateToReplacement[index]
                subsystem.elements[index].dataForChart = chartData[index]
                subsystem.elements[index].requiredReliability = arrayOfPi[index]
            }
        }

        print("--------------------------------\n\n")
    }

    //MARK: - Calculate Pi

    func calculatePdesired(numberOfSubsystems: Int) -> Double  {
        let lhs = Float(targetReliabilityFactor) ?? 0.95
        let rhs = Float(1.0 / Double(numberOfSubsystems))
        let result = pow(lhs, rhs)

        return Double(result)
    }

    func calculatePForFirstType(Pdesired: Double) -> [Double] {
        [Pdesired]
    }

    func calculatePForSecondType(Pdesired: Double) -> [Double] {
        let P1 = (2 - sqrt(4.0 - 4.0 * Pdesired)) / 2
        return [P1, P1]
    }

    func calculatePForThirdType(Pdesired: Double) -> [Double] {
        let P1 = sqrt((2 - sqrt(4.0 - 4.0 * Pdesired)) / 2)
        let P3 = (2 - sqrt(4.0 - 4.0 * Pdesired)) / 2
        return [P1, P1, P3]
    }

    func calculatePForFourthType(Pdesired: Double) -> [Double]{
        let P1 = sqrt((2 - sqrt(4.0 - 4.0 * Pdesired)) / 2)
        return [P1, P1, P1, P1]
    }

    //MARK: - Calculate time to element replacement

    func calculateTimeToReplacementForElements(_ subsystem: SubsystemBlock, arrayOfPi: [Double]) -> [Double] {
        var result = [Double]()

        for (index, element) in subsystem.elements.enumerated() {
            let timeToFailure = Double(element.timeToFailure) ?? 1
            let timeToReplacement = -log(arrayOfPi[index]) * timeToFailure
            result.append(timeToReplacement)
        }

        return result
    }

    func calculateDateToReplacementForElements(_ subsystem: SubsystemBlock, timeStamp: [Double]) -> [Date] {
        var result = [Date]()

        for (index, element) in subsystem.elements.enumerated() {
            let installationDate = element.installationDate
            var dateComponents = DateComponents()
            dateComponents.hour = Int(timeStamp[index])

            let replacementDate = Calendar.current.date(byAdding: dateComponents, to: installationDate) ?? Date()
            result.append(replacementDate)
        }

        return result
    }

    func createChartDataForElements(_ subsystem: SubsystemBlock,
                                    timeToReplacement: [Double]) -> [OrderedDictionary<String, String>] {
        var result = [OrderedDictionary<String, String>]()

        for (index, element) in subsystem.elements.enumerated() {
            var valuesForChart: Deque<String> = []
            var keysForChart: Deque<String> = []
            let step = timeToReplacement[index] / 8

            for t in stride(from: 0, to: timeToReplacement[index] + step, by: step) {
                let P = exp(-(Double(element.intensityMistakes) ?? 0.1 ) * Double(t))
                let installationDate = element.installationDate
                var dateComponents = DateComponents()
                dateComponents.hour = Int(t)
                let date = Calendar.current.date(byAdding: dateComponents, to: installationDate) ?? Date()

                valuesForChart.append(String(P))
                keysForChart.append(date.convertToExtendedString())
            }

            result.append(OrderedDictionary(uniqueKeysWithValues: zip(keysForChart, valuesForChart)))
        }

        return result
    }
}
