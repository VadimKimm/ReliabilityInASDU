//
//  ContentViewLROne.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 12.09.2022.
//

import SwiftUI

struct ContentViewLROne: View {
    @Binding var selectedView: Int

    @State var data = [OperatorTaskModel]()
    @State var result = ""
    @State var Pk: String = "0.95"
    @State var Pob: String = "1"
    @State var Pi: String = "0.7"

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var operatorReliabilityItems: FetchedResults<OperatorReliabilityItem>

    @State private var showingSaveView = false
    @State private var saveItemName = ""

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HeaderView()
                    .padding(.top, 10)

                List {
                    ForEach($data) { $item in
                        VStack {
                            HStack {
                                ZStack {
                                    TextEditor(text: $item.descriptionModel)
                                        .background(.bar)
                                        .menuIndicator(.hidden)

                                    Text(item.description)
                                        .opacity(0)
                                        .padding(.all, 8)
                                        .font(.callout)
                                }
                                .frame(minWidth: 150)

                                TextField("", text: $item.intensityMistakes)
                                    .padding(.leading, 30)
                                    .foregroundColor(item.intensityMistakes.isNumeric ? .white : .red)

                                TextField("", text: $item.numberOfOperations)
                                    .padding(.leading, 30)
                                    .foregroundColor(item.numberOfOperations.isNumeric ? .white : .red)

                                TextField("", text: $item.averageTime)
                                    .padding(.leading, 30)
                                    .foregroundColor(item.averageTime.isNumeric ? .white : .red)
                            }

                            Divider()
                        }
                    }
                    .onDelete { offsets in
                        deleteModel(at: offsets)
                    }
                }
                .padding(.bottom, 10)

                HStack(alignment: .top) {
                    HStack {
                        Text("Pk:   ")
                        TextField("", text: $Pk)
                            .frame(width: 50)
                            .foregroundColor(Pk.isNumeric ? .white : .red)
                    }
                    
                    HStack {
                        Text("Pob: ")
                        TextField("", text: $Pob)
                            .frame(width: 50)
                            .foregroundColor(Pob.isNumeric ? .white : .red)
                    }
                    
                    HStack {
                        Text("Pi:    ")
                        TextField("", text: $Pi)
                            .frame(width: 50)
                            .foregroundColor(Pi.isNumeric ? .white : .red)
                    }

                    Spacer()

                    Button("Добавить строку") {
                        addButtonPressed()
                    }
                }
                .padding(.bottom, 10)

                HStack {
                    Button("Рассчитать") {
                        computeButtonPressed()
                    }

                    Text("Надежность:")

                    TextField("", text: $result)
                        .frame(width: 100)
                        .padding(.leading, 5)
                }
                .padding(.bottom, 10)

            }
            .frame(width: 750)
            .padding(.leading, 20)

            VStack(alignment: .leading) {
                List {
                    ForEach(operatorReliabilityItems) { item in
                        VStack(alignment: .leading) {
                            Text(item.name ?? "Unknown")
                            Text(item.date?.convertToExtendedString() ?? "Unknown")
                        }
                        .onTapGesture(count: 2, perform: {
                            setItemValues(of: item)
                        })
                    }
                    .onDelete(perform: removeOperatorItem(at: ))
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
        .navigationTitle("ОЦЕНКА НАДЕЖНОСТИ БЕЗОШИБОЧНОГО ВЫПОЛНЕНИЯ ОПЕРАТОРОМ ПОСТАВЛЕННЫХ ЕМУ ЗАДАЧ")
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

// MARK: - CoreData Actions

extension ContentViewLROne {
    func removeOperatorItem(at offsets: IndexSet) {
        for index in offsets {
            let item = operatorReliabilityItems[index]
            moc.delete(item)
        }

        try? moc.save()
    }

    func save() {
        let operatorReliabilityItem = OperatorReliabilityItem(context: moc)
        operatorReliabilityItem.items = data
        operatorReliabilityItem.name = saveItemName
        operatorReliabilityItem.date = Date()
        operatorReliabilityItem.pi = Pi
        operatorReliabilityItem.pk = Pk
        operatorReliabilityItem.pob = Pob
        operatorReliabilityItem.reliability = result

        try? moc.save()
    }

    func setItemValues(of item: OperatorReliabilityItem) {
        data = item.items ?? [OperatorTaskModel]()
        result = item.reliability ?? "Unknown"
        Pk = item.pk ?? "Unknown"
        Pi = item.pi ?? "Unknown"
        Pob = item.pob ?? "Unknown"
    }
}

// MARK: - Actions

extension ContentViewLROne {

    private func addButtonPressed() {
        let model = OperatorTaskModel.createBlankModel()
        data.append(model)
    }

    private func deleteModel(at offsets: IndexSet) {
        data.remove(atOffsets: offsets)
    }
}

// MARK: - Вероятность успешного выполнения поставленной задачи диспетчером

extension ContentViewLROne {
    private func computeButtonPressed() {
        let result = computeProbability(array: data)
        self.result = result
    }

    private func computeProbability(array:  [OperatorTaskModel]) -> String {
        var Pop = Double()
        var expPower = Double()
        let Pisp = (Double(Pk) ?? 0.95) * (Double(Pob) ?? 1) * (Double(Pi) ?? 0.7)

        for item in array {
            let baseAndPower = item.intensityMistakes.convertToDemical()
            let base = baseAndPower.0
            let power = baseAndPower.1

            expPower += (base * pow(10, -power)) * (Double(item.averageTime) ?? 1) * (Double(item.numberOfOperations) ?? 1)
        }

        Pop = exp(-expPower)
        return String(format: "%.4f", (Pop + (1 - Pop) * Pisp))
    }
}

// MARK: - Save to file

extension ContentViewLROne {
    func makeStringToSave() -> String {
        var text = String()

        for item in data {
            text += "Вид деятельности: \(item.descriptionModel)\n"
            text += "Интенсивность ошибок: \(item.intensityMistakes)\n"
            text += "Число выполненых операций: \(item.numberOfOperations)\n"
            text += "Среднее время выполнения операции: \(item.averageTime)\n\n"
        }

        text += "Pk: \(Pk) "
        text += "Pob: \(Pob) "
        text += "Pi: \(Pi)\n"
        text += "Надежность: \(result)"

        return text
    }
}
