//
//  Migrator.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.01.2023.
//

import Foundation
import RealmSwift

class Migrator {
    init() {
        updateScheme()
    }

    func updateScheme() {
        let config = Realm.Configuration(schemaVersion: 3)
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
}
