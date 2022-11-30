//
//  SubsystemEditBlockView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import SwiftUI

struct SubsystemEditBlockView: View {
    
    @Binding var isVisible: Bool
    @Binding var subsystem: SubsystemBlock

    var body: some View {
        VStack {
            Text(subsystem.elements.isEmpty ? "Нет элементов" : "Редактирование элементов")

            HStack {
                ForEach($subsystem.elements) { element in
                    VStack {
                        HStack {
                            Text("Наименование:")
                            TextField("", text: element.title)
                        }
                        .padding([.horizontal, .top])

                        HStack {
                            Text("Нараб. на отказ, ч:")
                            TextField("", text: element._timeToFailure)
                        }
                        .padding(.horizontal)

                        HStack {
                            Text("Интенс. отказов, 1/ч:")
                            TextField("", text: element._intensityMistakes)
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
                .frame(width: 310)
                .border(.white)
            }

            Spacer()
            
            Button("Подтвердить") {
                isVisible = false
            }
        }
        .padding()
    }
}
