//
//  ContentViewLROne.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 12.09.2022.
//

import SwiftUI

struct ContentViewLROne: View {

    var viewModel: ContentViewModelLROne?

    @ObservedObject var data = ParseData()
    @State var result = ""
    @State var Pk: String = String(IntensityMistakes.Probabilities.Pk)
    @State var Pob: String = String(IntensityMistakes.Probabilities.Pob)
    @State var Pi: String = String(IntensityMistakes.Probabilities.Pi)

    var body: some View {
        NavigationView {
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

            VStack {
                HeaderView()

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
            }
            .frame(width: 750)

            VStack(alignment: .leading) {
                HStack {
                    Text("Pk:   ")
                    TextField("", text: $Pk)
                        .frame(width: 50)
                }

                HStack {
                    Text("Pob: ")
                    TextField("", text: $Pob)
                        .frame(width: 50)
                }

                HStack {
                    Text("Pi:    ")
                    TextField("", text: $Pi)
                        .frame(width: 50)
                }

                Spacer()
            }
            .frame(width: 150)
            .padding(.top, 40)
        }
        .frame(minWidth: 1000, minHeight: 600)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewLROne()
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
        viewModel?.setNewConstants(Pk: Double(Pk),
                                   Pob: Double(Pob),
                                   Pi: Double(Pi))
    }
}

// MARK: - Вероятность успешного выполнения поставленной задачи диспетчером

extension ContentViewLROne {
    private func computeButtonPressed() {
        submitButtonPressed()
        let result = viewModel?.computeProbability(array: data.intensityMistakes)
        self.result = result ?? ""
    }
}
