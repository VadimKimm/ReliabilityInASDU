//
//  IntensityMistakes.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 12.09.2022.
//

import Foundation

struct IntensityMistakes: Codable, Identifiable {
    var id = UUID()
    var intensityMistakes: String
    var description: String
    var numberOfOperations: String
    var averageTime: String

    enum CodingKeys: CodingKey {
        case intensityMistakes
        case description
        case numberOfOperations
        case averageTime
    }
}

extension IntensityMistakes {
    enum Probabilities {
        static var Pk: Double = 0.95
        static var Pob: Double = 1
        static var Pi: Double = 0.7
    }
}
