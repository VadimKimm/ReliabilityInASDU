//
//  JMModel.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 29.10.2022.
//

import Foundation

struct JMModel: Identifiable {
    let id = UUID()
    let name: String
    let values: [Double]
}

struct JMLineChartData {
    let keys: [String]
    let data: [JMModel]
}
