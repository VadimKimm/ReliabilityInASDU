//
//  RealmSchemeElement.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.01.2023.
//

import Foundation
import OrderedCollections
import RealmSwift

class RealmSchemeElement: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var timeToFailure: String
    @Persisted var intensityMistakes: String
    @Persisted var installationDate: Date
    @Persisted var requiredReliability: Double?
    @Persisted var dateToReplacement: Date?

    override class func primaryKey() -> String? {
        "id"
    }
}
