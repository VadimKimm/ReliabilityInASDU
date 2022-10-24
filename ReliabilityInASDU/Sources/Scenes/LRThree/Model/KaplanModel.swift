//
//  KaplanModel.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 19.10.2022.
//

import Foundation

struct KaplanModel: Identifiable {
    let id = UUID()
    let name: String
    let values: [Double]
}

struct LineChartData {
    let keys: [String]
    let data: [KaplanModel]
}

extension KaplanModel {
    static func getData() -> [KaplanModel] {
        let data = [
            KaplanModel(name: "0", values: [1, 1, 0.8]),
            KaplanModel(name: "1", values: [1, 1, 0.8]),
            KaplanModel(name: "2", values: [0.9, 1, 0.7]),
            KaplanModel(name: "3", values: [0.9, 1, 0.6]),
            KaplanModel(name: "4", values: [0.8, 1, 0.6]),
            KaplanModel(name: "5", values: [0.7, 0.9, 0.5]),
            KaplanModel(name: "6", values: [0.6, 0.8, 0.4]),
            KaplanModel(name: "7", values: [0.5, 0.8, 0.4]),
        ]

        return data
    }
}
