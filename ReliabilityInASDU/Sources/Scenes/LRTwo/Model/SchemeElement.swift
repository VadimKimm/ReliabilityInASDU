//
//  SchemeElement.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import Foundation
import OrderedCollections
import SwiftUI

struct SchemeElement: Identifiable {
    var id = UUID()
    var title: String
    var timeToFailure: String
    var intensityMistakes: String
    var installationDate: Date
    var requiredReliability: Double?
    var dateToReplacement: Date?
    var dataForChart: OrderedDictionary<String, String>?

    var _timeToFailure: String {
        get {
            timeToFailure
        } set {
            timeToFailure = newValue
            intensityMistakes = String(1.0 / (Double(newValue) ?? 10))
        }
    }

    var _intensityMistakes: String {
        get {
            intensityMistakes
        } set {
            intensityMistakes = newValue
            timeToFailure = String(1.0 / (Double(newValue) ?? 10))
        }
    }
}
