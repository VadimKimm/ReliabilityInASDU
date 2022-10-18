//
//  SchemeElement.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import Foundation

struct SchemeElement: Identifiable {
    var id = UUID()
    var title: String
    var timeToFailure: String
    var intensityMistakes: String
//    {
//        get {
//            return String(1 / (Double(timeToFailure) ?? 1))
//        }
//    }
    var installationDate: Date
}
