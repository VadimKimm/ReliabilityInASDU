//
//  ReplacementPlanView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 30.11.2022.
//

import SwiftUI

struct ReplacementPlanView: View {

    @Binding var isVisible: Bool
    var subsystems: [SubsystemBlock]

    var body: some View {
        VStack {
            Text("План замены деталей")
                .font(.title)
                .bold()

            ScrollView(.vertical, showsIndicators: false) {
                ForEach(0..<subsystems.count, id: \.self) { index in
                    VStack {
                        Text("Подсистема №\(index + 1)")
                            .font(.title2)
                            .bold()
                            .padding()
                        HStack(spacing: 30) {
                            ForEach(subsystems[index].elements) { element in
                                VStack(alignment: .leading) {
                                    Text(element.title)
                                        .bold()
                                    Text("Дата установки: \(element.installationDate.convertToString())")
                                    Text("Дата замены: \(element.dateToReplacement?.convertToString() ?? Date().convertToString())")
                                }
                                .padding()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .border(.white)
                }

                Spacer()
            }

            Button("Закрыть") {
                isVisible = false
            }
        }
        .padding()
    }
}

struct ReplacementPlanView_Previews: PreviewProvider {
    static var previews: some View {
        ReplacementPlanView(isVisible: .constant(true), subsystems: [SubsystemBlock(type: .firstType)])
    }
}
