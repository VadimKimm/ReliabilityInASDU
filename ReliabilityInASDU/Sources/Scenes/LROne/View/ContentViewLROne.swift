//
//  ContentViewLROne.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 12.09.2022.
//

import SwiftUI

struct ContentViewLROne: View {
    @Binding var selectedView: Int

    @ObservedObject var data = ParseData()
    @State var result = ""
    @State var Pk: String = String(IntensityMistakes.Probabilities.Pk)
    @State var Pob: String = String(IntensityMistakes.Probabilities.Pob)
    @State var Pi: String = String(IntensityMistakes.Probabilities.Pi)

    var body: some View {
        HStack {
            VStack {
                HeaderView()
                    .padding(.top, 10)

                List {
                    ForEach($data.intensityMistakes) { $item in
                        VStack {
                            HStack {
                                ZStack {
                                    TextEditor(text: $item.description)
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
                        data.deleteModel(offsets)
                    }
                }
                .padding(.bottom, 10)
            }
            .frame(width: 750)

            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    TabButtonView(image: "plus",
                                  title: "Add",
                                  action: { addButtonPressed() })
                    .padding(.leading, 20)

                    TabButtonView(image: "square.and.arrow.down",
                                  title: "Save",
                                  action: { saveButtonPressed() })
                    .padding(.leading, 20)

                    TabButtonView(image: "equal",
                                  title: "Compute",
                                  action: { computeButtonPressed() })
                    .padding(.leading, 20)

                    TextField("", text: $result)
                        .frame(width: 70)
                        .padding(.leading, 20)

                    Spacer()
                }
                .frame(width: 80)
                .padding(.top, 40)

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
            }
            .frame(width: 150)
            .padding(.top, 40)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewLROne(selectedView: .constant(0))
    }
}

// MARK: - Actions

extension ContentViewLROne {

    private func addButtonPressed() {
        data.loadBlankModel()
    }

    private func saveButtonPressed() {
        data.saveData()
    }

    private func submitButtonPressed() {
        setNewConstants(Pk: Double(Pk),
                        Pob: Double(Pob),
                        Pi: Double(Pi))
    }
}

// MARK: - Вероятность успешного выполнения поставленной задачи диспетчером

extension ContentViewLROne {
    private func computeButtonPressed() {
        submitButtonPressed()
        let result = computeProbability(array: data.intensityMistakes)
        self.result = result
    }

    private func computeProbability(array:  [IntensityMistakes]) -> String {
        var Pop = Double()
        var expPower = Double()
        let Pisp = IntensityMistakes.Probabilities.Pk * IntensityMistakes.Probabilities.Pob * IntensityMistakes.Probabilities.Pi

        for item in array {
            let baseAndPower = item.intensityMistakes.convertToDemical()
            let base = baseAndPower.0
            let power = baseAndPower.1

            expPower += (base * pow(10, -power)) * (Double(item.averageTime) ?? 1) * (Double(item.numberOfOperations) ?? 1)
        }

        Pop = exp(-expPower)
        return String(format: "%.4f", (Pop + (1 - Pop) * Pisp))
    }

    private func setNewConstants(Pk: Double?, Pob: Double?, Pi: Double?) {
        IntensityMistakes.Probabilities.Pk = Pk ?? IntensityMistakes.Probabilities.Pk
        IntensityMistakes.Probabilities.Pob = Pob ?? IntensityMistakes.Probabilities.Pob
        IntensityMistakes.Probabilities.Pi = Pi ?? IntensityMistakes.Probabilities.Pi
    }
}
