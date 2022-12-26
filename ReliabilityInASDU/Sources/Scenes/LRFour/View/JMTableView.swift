//
//  JMTableView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 25.12.2022.
//

import SwiftUI
import OrderedCollections

struct JMTableView: View {
    var dataForTable: OrderedDictionary<Double, Double>?

    var body: some View {
        VStack {
            Text("Таблица значений")
                .font(.title)
                .padding(.bottom, 10)

            VStack {
                HStack {
                    Text("Время")
                    Spacer()
                    Text("Вероятность того, что в программе нет ошибок")
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.all, 5)
                .font(.title3)
                .frame(width: 200)

                List(1..<((dataForTable?.count ?? 0)) + 1) { xValue in
                    HStack {
                        Text(String(xValue))
                        Spacer()
                        Text(String(format: "%.3f", dataForTable?.elements[xValue - 1].value ?? 0.0))
                    }
                    .padding(.all, 5)
                }
                .frame(width: 200)
                .border(.white)
            }
            .border(.white)
        }
    }
}
