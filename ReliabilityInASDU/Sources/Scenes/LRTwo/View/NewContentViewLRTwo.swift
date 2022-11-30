//
//  NewContentViewLRTwo.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 28.11.2022.
//

import SwiftUI

struct NewContentViewLRTwo: View {
    
    @State var subsystems = [SubsystemBlock]()
    @State private var targetReliabilityFactor = "0.95"
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showReplacementPlan = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {

            }
            .frame(width: 80)
            .padding(.top, 40)

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
                        ReplacementPlanView(isVisible: $showReplacementPlan,
                                            subsystems: subsystems)
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
    }
}

struct NewContentViewLRTwo_Previews: PreviewProvider {
    static var previews: some View {
        NewContentViewLRTwo()
    }
}

// MARK: - Make plan

extension NewContentViewLRTwo {
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
//                arrayOfPi.append(p)
//                pForElements.map { arrayOfPi.append($0) }
//
//                for p in pForElements {
//                    arrayOfPi.append(p)
//                }
            case .secondType:
                let _ = calculatePForSecondType(Pdesired: Pdesired).map { arrayOfPi.append($0) }
            case .thirdType:
                let _ = calculatePForThirdType(Pdesired: Pdesired).map { arrayOfPi.append($0) }
            case .fourthType:
                let _ = calculatePForFourthType(Pdesired: Pdesired).map { arrayOfPi.append($0) }
            }

            let timeToReplacement = calculateTimeToReplacementForElements(subsystem, arrayOfPi: arrayOfPi)
            let dateToReplacement = calculateDateToReplacementForElements(subsystem, timeStamp: timeToReplacement)
            for (index, time) in timeToReplacement.enumerated() {
                print("Требуемая надежность элемента \(index + 1) - \(arrayOfPi[index])")
                print("Время до замены элемента \(index + 1) - \(time)")
                print("Дата замены элемента \(index + 1) - \(dateToReplacement[index].convertToString())")
                subsystem.elements[index].dateToReplacement = dateToReplacement[index]
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
}
