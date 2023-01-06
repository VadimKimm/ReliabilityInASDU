//
//  RealmSystem.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.01.2023.
//

import Foundation
import RealmSwift

class RealmSystem: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var targetReliabilityFactor: String
    @Persisted var date = Date()
    @Persisted var blocks: List<RealmSubsystemBlock> = List<RealmSubsystemBlock>()

    override class func primaryKey() -> String? {
        "id"
    }
}
