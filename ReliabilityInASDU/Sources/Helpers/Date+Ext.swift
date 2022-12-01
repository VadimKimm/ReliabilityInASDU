//
//  Date+Ext.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import Foundation

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return dateFormatter.string(from: self)
    }

    func convertToExtendedString() -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}
