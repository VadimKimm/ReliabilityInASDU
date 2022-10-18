//
//  SchemeEditBlockView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import SwiftUI

struct SchemeEditBlockView: View {
    
    @Binding var isVisible: Bool
    @Binding var block: [SchemeElement]

    var body: some View {
        VStack {
            Text(block.isEmpty ? "Нет элементов" : "Редактирование элементов")

            HStack {
                ForEach($block) { element in
                    VStack {
                        HStack {
                            Text("Наименование:")
                            TextField("", text: element.title)
                        }
                        .padding([.horizontal, .top])

                        HStack {
                            Text("Нараб. на отказ:")
                            TextField("", text: element.timeToFailure)
                        }
                        .padding(.horizontal)

                        HStack {
                            Text("Интенсив. отказов:")
                            TextField("", text: element.intensityMistakes)
//                            Text("\(element.intensityMistakes)")
                        }
                        .padding(.horizontal)

                        HStack {
                            Text("Дата установки: ")
                            DatePicker("", selection: element.installationDate, displayedComponents: .date)
                                .labelsHidden()
                        }
                        .padding([.horizontal, .bottom])

                    }
                }
                .frame(width: 300)
                .border(.white)
            }

            Spacer()
            
            Button("Cancel") {
                isVisible = false
            }
        }
        .padding()
    }
}
