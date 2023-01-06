////
////  NewContentViewLRTwo.swift
////  ReliabilityInASDU
////
////  Created by Vadim Kim on 28.11.2022.
////
//
//import SwiftUI
//import OrderedCollections
//import Collections
//
//struct ContentViewLRTwo: View {
//
//    @Binding var selectedView: Int
//    @State var subsystems = [SubsystemBlock]()
//    @State private var targetReliabilityFactor = "0.95"
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    @State private var showReplacementPlan = false
//
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var systemSchemeItems: FetchedResults<SystemSchemeItem>
//
//    @State private var showingSaveView = false
//    @State private var saveItemName = ""
//
//    var body: some View {
//        HStack {
//            VStack {
//                //Верхний стэк
//                VStack {
//                    Text(subsystems.isEmpty ? "Добавьте подсистемы" : "Схема")
//                        .font(.title)
//                        .bold()
//
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 5) {
//                            ForEach(subsystems.indices, id: \.self) { index in
//                                VStack {
//                                    Text("Подсистема №\(index + 1)")
//                                        .bold()
//                                        .font(.title3)
//                                        .padding(.top, 10)
//                                    SubsystemView(selectedItem: $subsystems[index],
//                                                  isVisible: $subsystems[index].isSelected)
//
//                                    Button(role: .destructive) {
//                                        subsystems.removeAll(where: {$0.id == $subsystems[index].id})
//                                    } label: {
//                                        Label("Удалить", systemImage: "trash")
//                                            .foregroundColor(.red)
//                                    }
//
//                                    SubsystemComponentsView(subsystem: $subsystems[index])
//                                }
//                                .border(.white)
//                                .sheet(isPresented: $subsystems[index].isSelected) {
//                                    SubsystemEditBlockView(isVisible: $subsystems[index].isSelected,
//                                                           subsystem: $subsystems[index])
//                                }
//                            }
//                            .padding(5)
//                        }
//                    }
//                    .frame(width: 730, height: 440)
//                    .border(.white)
//                    .sheet(isPresented: $showReplacementPlan) {
//                        ReplacementPlanView(subsystems: subsystems, isVisible: $showReplacementPlan)
//                    }
//                }
//                .alert("Ошибка", isPresented: $showAlert) {
//                    Button("OK", role: .cancel) {
//                        showAlert.toggle()
//                    }
//                } message: {
//                    Text(alertMessage)
//                }
//
//                //Нижний стэк
//                VStack() {
//                    HStack {
//                        Text("Критич. уровень надежности")
//                            .font(.title2)
//                            .bold()
//                            .padding(.horizontal, 10)
//                        TextField("", text: $targetReliabilityFactor)
//                            .frame(width: 60)
//                            .foregroundColor(targetReliabilityFactor.isNumeric && Double(targetReliabilityFactor) ?? 0.95 < 1.0  ? .white : .red)
//
//                        Button {
//                            subsystems.append(SubsystemBlock(type: .firstType))
//                        } label: {
//                            Text("Добавить подсистему")
//                                .frame(width: 200, height: 40)
//                                .lineLimit(1)
//                                .clipShape(Capsule())
//                        }
//                        .buttonStyle(WhiteButtonStyle())
//                        .frame(width: 200)
//                        .padding(.leading, 70)
//
//                        Button {
//                            guard (Double(targetReliabilityFactor) != nil && Double(targetReliabilityFactor) ?? 0.95 < 1)
//                            else {
//                                alertMessage = "Уровень надежности должен быть меньше 1"
//                                showAlert.toggle()
//                                return
//                            }
//                            makePlan()
//                            guard !subsystems.isEmpty
//                            else {
//                                showAlert.toggle()
//                                return
//                            }
//                            showReplacementPlan.toggle()
//                        } label: {
//                            Text("Сформировать план")
//                                .frame(width: 200, height: 40)
//                                .lineLimit(1)
//                                .clipShape(Capsule())
//                        }
//                        .buttonStyle(WhiteButtonStyle())
//                        .frame(width: 200)
//                        .padding(.leading, 10)
//
//                    }
//                }
//                .padding(.top, 20)
//            }
//            .frame(width: 750)
//
//            // TODO: тут должны быть кнопки для сохранения/импорта в базу данных
//            VStack(alignment: .leading) {
//                List {
//                    ForEach(systemSchemeItems) { item in
//                        VStack(alignment: .leading) {
//                            Text(item.name ?? "Unknown")
//                            Text(item.date?.convertToExtendedString() ?? "Unknown")
//                        }
//                        .onTapGesture(count: 2, perform: {
//                            setSystemSchemeValues(of: item)
//                        })
//                    }
//                    .onDelete(perform: removeSystemSchemeItem(at: ))
//                }
//
//                Button("Сохранить") {
//                    showingSaveView.toggle()
//                }
//                .sheet(isPresented: $showingSaveView) {
//                    SaveView(name: $saveItemName, isVisible: $showingSaveView, action: save )
//                }
//            }
//            .frame(width: 200)
//            .padding(.all, 20)
//        }
//        .frame(minWidth: 1000, minHeight: 600)
//        .navigationTitle("НАДЕЖНОСТЬ ТЕХНОЛОГИЧЕСКОГО ОБОРУДОВАНИЯ. ПОСТРОЕНИЕ ПЛАНА ЗАМЕНЫ ОБОРУДОВАНИЯ")
//        .toolbar {
//            ToolbarItemGroup(placement: .navigation) {
//                Button {
//                    selectedView = 0
//                } label: {
//                    Image(systemName: "arrow.left").imageScale(.large)
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Core data functions
//
//extension ContentViewLRTwo {
//    func save() {
//        var subsystemsArray = [SubsystemBlockItem(context: moc)]
//
//        for rawSubsystem in self.subsystems {
//            var elementsArray = [SubsystemElementItem(context: moc)]
//
//            for rawElement in rawSubsystem.elements {
//                let element = SubsystemElementItem(context: moc)
//                element.id = rawElement.id
//                element.intensityMistakes = rawElement.intensityMistakes
//                element.requiredReliability = rawElement.requiredReliability ?? 0.0
//                element.timeToFailure = rawElement.timeToFailure
//                element.title = rawElement.title
//                element.dateToReplacement = rawElement.dateToReplacement
//                element.installationDate = rawElement.installationDate
//                elementsArray.append(element)
//            }
//
//            let subsystemBlockItem = SubsystemBlockItem(context: moc)
//            subsystemBlockItem.elements = elementsArray
//            subsystemBlockItem.type = rawSubsystem.type.rawValue
//            subsystemsArray.append(subsystemBlockItem)
//        }
//
//        let systemScheme = SystemSchemeItem(context: moc)
//        systemScheme.reliability = targetReliabilityFactor
//        systemScheme.date = Date()
//        systemScheme.name = saveItemName
//        systemScheme.subsystems = subsystemsArray
//
//        try? moc.save()
//    }
//
//    func setSystemSchemeValues(of item: SystemSchemeItem) {
//        targetReliabilityFactor = item.reliability ?? "Unknown"
//
//        guard let coreDataSubsystems = item.subsystems else { return }
//
//        var unwrappedSubsystemsArray = [SubsystemBlock]()
//
//        for subsystem in coreDataSubsystems {
//            guard let elements = subsystem.elements else { return }
//
//            var unwrappedElementsArray = [SchemeElement]()
//            for element in elements {
//                let unwrappedElement = SchemeElement(id: element.id ?? UUID(),
//                                                     title: element.title ?? "Unknown",
//                                                     timeToFailure: element.timeToFailure ?? "Unknown",
//                                                     intensityMistakes: element.intensityMistakes ?? "Unknown",
//                                                     installationDate: element.installationDate ?? Date(),
//                                                     requiredReliability: element.requiredReliability,
//                                                     dateToReplacement: element.dateToReplacement ?? Date())
//                unwrappedElementsArray.append(unwrappedElement)
//            }
//
//            let unwrappedSubsystem = SubsystemBlock(stringType: subsystem.type ?? "Тип 1")
//            unwrappedSubsystem.elements = unwrappedElementsArray
//
//            unwrappedSubsystemsArray.append(unwrappedSubsystem)
//        }
//
//        self.subsystems = unwrappedSubsystemsArray
//    }
//
//    func removeSystemSchemeItem(at offsets: IndexSet) {
//        for index in offsets {
//            let item = systemSchemeItems[index]
//            moc.delete(item)
//        }
//
//        try? moc.save()
//    }
//}
//
//
//// MARK: - Make plan
//
//extension ContentViewLRTwo {
//    func makePlan() {
//        guard !subsystems.isEmpty else {
//            alertMessage = "Количество подсистем равно 0. Добавьте подсистемы."
//            showAlert.toggle()
//            return
//        }
//
//        let numberOfSubsystems = subsystems.count
//        let Pdesired = calculatePdesired(numberOfSubsystems: numberOfSubsystems)
//
//        for (number, subsystem) in subsystems.enumerated() {
//            var arrayOfPi = [Double]()
//            print("Подсистема #\(number + 1)")
//
//            switch subsystem.type {
//            case .firstType:
//                let _ = calculatePForFirstType(Pdesired: Pdesired).map { arrayOfPi.append($0) }
//            case .secondType:
//                let _ = calculatePForSecondType(Pdesired: Pdesired).map { arrayOfPi.append($0) }
//            case .thirdType:
//                let _ = calculatePForThirdType(Pdesired: Pdesired).map { arrayOfPi.append($0) }
//            case .fourthType:
//                let _ = calculatePForFourthType(Pdesired: Pdesired).map { arrayOfPi.append($0) }
//            }
//
//            let timeToReplacement = calculateTimeToReplacementForElements(subsystem, arrayOfPi: arrayOfPi)
//            let dateToReplacement = calculateDateToReplacementForElements(subsystem, timeStamp: timeToReplacement)
//            let chartData = createChartDataForElements(subsystem, timeToReplacement: timeToReplacement)
//
//            for (index, time) in timeToReplacement.enumerated() {
//                print("Требуемая надежность элемента \(index + 1) - \(arrayOfPi[index])")
//                print("Время до замены элемента \(index + 1) - \(time)")
//                print("Дата замены элемента \(index + 1) - \(dateToReplacement[index].convertToString())")
//                subsystem.elements[index].dateToReplacement = dateToReplacement[index]
//                subsystem.elements[index].dataForChart = chartData[index]
//                subsystem.elements[index].requiredReliability = arrayOfPi[index]
//            }
//        }
//
//        print("--------------------------------\n\n")
//    }
//
//    //MARK: - Calculate Pi
//
//    func calculatePdesired(numberOfSubsystems: Int) -> Double  {
//        let lhs = Float(targetReliabilityFactor) ?? 0.95
//        let rhs = Float(1.0 / Double(numberOfSubsystems))
//        let result = pow(lhs, rhs)
//
//        return Double(result)
//    }
//
//    func calculatePForFirstType(Pdesired: Double) -> [Double] {
//        [Pdesired]
//    }
//
//    func calculatePForSecondType(Pdesired: Double) -> [Double] {
//        let P1 = (2 - sqrt(4.0 - 4.0 * Pdesired)) / 2
//        return [P1, P1]
//    }
//
//    func calculatePForThirdType(Pdesired: Double) -> [Double] {
//        let P1 = sqrt((2 - sqrt(4.0 - 4.0 * Pdesired)) / 2)
//        let P3 = (2 - sqrt(4.0 - 4.0 * Pdesired)) / 2
//        return [P1, P1, P3]
//    }
//
//    func calculatePForFourthType(Pdesired: Double) -> [Double]{
//        let P1 = sqrt((2 - sqrt(4.0 - 4.0 * Pdesired)) / 2)
//        return [P1, P1, P1, P1]
//    }
//
//    //MARK: - Calculate time to element replacement
//
//    func calculateTimeToReplacementForElements(_ subsystem: SubsystemBlock, arrayOfPi: [Double]) -> [Double] {
//        var result = [Double]()
//
//        for (index, element) in subsystem.elements.enumerated() {
//            let timeToFailure = Double(element.timeToFailure) ?? 1
//            let timeToReplacement = -log(arrayOfPi[index]) * timeToFailure
//            result.append(timeToReplacement)
//        }
//
//        return result
//    }
//
//    func calculateDateToReplacementForElements(_ subsystem: SubsystemBlock, timeStamp: [Double]) -> [Date] {
//        var result = [Date]()
//
//        for (index, element) in subsystem.elements.enumerated() {
//            let installationDate = element.installationDate
//            var dateComponents = DateComponents()
//            dateComponents.hour = Int(timeStamp[index])
//
//            let replacementDate = Calendar.current.date(byAdding: dateComponents, to: installationDate) ?? Date()
//            result.append(replacementDate)
//        }
//
//        return result
//    }
//
//    func createChartDataForElements(_ subsystem: SubsystemBlock,
//                                    timeToReplacement: [Double]) -> [OrderedDictionary<String, String>] {
//        var result = [OrderedDictionary<String, String>]()
//
//        for (index, element) in subsystem.elements.enumerated() {
//            var valuesForChart: Deque<String> = []
//            var keysForChart: Deque<String> = []
//            let step = timeToReplacement[index] / 8
//
//            for t in stride(from: 0, to: timeToReplacement[index] + step, by: step) {
//                let P = exp(-(Double(element.intensityMistakes) ?? 0.1 ) * Double(t))
//                let installationDate = element.installationDate
//                var dateComponents = DateComponents()
//                dateComponents.hour = Int(t)
//                let date = Calendar.current.date(byAdding: dateComponents, to: installationDate) ?? Date()
//
//                valuesForChart.append(String(P))
//                keysForChart.append(date.convertToExtendedString())
//            }
//
//            result.append(OrderedDictionary(uniqueKeysWithValues: zip(keysForChart, valuesForChart)))
//        }
//
//        return result
//    }
//}
