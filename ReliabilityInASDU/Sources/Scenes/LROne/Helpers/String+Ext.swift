//
//  String+Ext.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 16.09.2022.
//

import Foundation

extension String {

    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "-", "."]
        return Set(self).isSubset(of: nums)
    }

    func convertToDemical() -> (base: Double, power: Double) {
        var base = Double()
        var power = Double()

        guard self.contains("-"), self.contains("10") else {
            return (Double(self) ?? 1, 0)
        }

        let parts = self.components(separatedBy: "*")

        if parts.count == 1 {
            base = 1
        } else {
            base = Double(parts[0]) ?? 1
        }

        let secondParts = self.components(separatedBy: "-")
        power = Double(secondParts[1]) ?? 1

        return (base, power)
    }
}
