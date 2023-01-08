//
//  RealmSubsystemBlock.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.01.2023.
//

import Foundation
import RealmSwift

class RealmSubsystemBlock: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var elements: List<RealmSchemeElement> = List<RealmSchemeElement>()
    @Persisted var isSelected = false
    @Persisted var type: String

    override class func primaryKey() -> String? {
        "id"
    }
}
