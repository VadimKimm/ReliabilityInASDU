//
//  ContentViewModelLROne.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 23.09.2022.
//

import Foundation

struct ContentViewModelLROne {
    
    func computeProbability(array:  [IntensityMistakes]) -> String {

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

    func setNewConstants(Pk: Double?, Pob: Double?, Pi: Double?) {
        IntensityMistakes.Probabilities.Pk = Pk ?? IntensityMistakes.Probabilities.Pk
        IntensityMistakes.Probabilities.Pob = Pob ?? IntensityMistakes.Probabilities.Pob
        IntensityMistakes.Probabilities.Pi = Pi ?? IntensityMistakes.Probabilities.Pi
    }
}
