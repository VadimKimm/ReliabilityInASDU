//
//  SchemeElement.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import Foundation
import OrderedCollections
import SwiftUI

public class SchemeElement: NSObject, NSCoding, Identifiable {
    public var id = UUID()
    public var title: String = ""
    public var timeToFailure: String = ""
    public var intensityMistakes: String = ""
    public var installationDate: Date = Date()
    public var requiredReliability: Double? = 0.0
    public var dateToReplacement: Date? = Date()
    public var dataForChart: OrderedDictionary<String, String>? = OrderedDictionary<String, String>()

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

    init(id: UUID = UUID(), title: String, timeToFailure: String, intensityMistakes: String, installationDate: Date, requiredReliability: Double? = nil, dateToReplacement: Date? = nil) {
        self.id = id
        self.title = title
        self.timeToFailure = timeToFailure
        self.intensityMistakes = intensityMistakes
        self.installationDate = installationDate
        self.requiredReliability = requiredReliability
        self.dateToReplacement = dateToReplacement
    }

    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(timeToFailure, forKey: "timeToFailure")
        coder.encode(intensityMistakes, forKey: "intensityMistakes")
        coder.encode(installationDate, forKey: "installationDate")
        coder.encode(requiredReliability, forKey: "requiredReliability")
        coder.encode(dateToReplacement, forKey: "dateToReplacement")
    }

    public required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as? UUID ?? UUID()
        title = coder.decodeObject(forKey: "title") as? String ?? ""
        timeToFailure = coder.decodeObject(forKey: "timeToFailure") as? String ?? ""
        intensityMistakes = coder.decodeObject(forKey: "intensityMistakes") as? String ?? ""
        installationDate = coder.decodeObject(forKey: "installationDate") as? Date ?? Date()
        requiredReliability = coder.decodeObject(forKey: "requiredReliability") as? Double ?? 0.0
        dateToReplacement = coder.decodeObject(forKey: "dateToReplacement") as? Date ?? Date()
    }
}
