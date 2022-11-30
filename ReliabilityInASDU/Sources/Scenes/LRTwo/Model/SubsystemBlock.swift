//
//  SubsystemBlock.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 29.11.2022.
//

import Foundation

class SubsystemBlock: Identifiable {

    private var _type: SubsystemBlockType = .firstType

    var type: SubsystemBlockType {
        get {
            return _type
        } set {
            _type = newValue
            elements = newValue.block
        }
    }

    var elements: [SchemeElement] = []

    var isSelected = false

    init(type: SubsystemBlockType) {
        self.type = type
    }

    func toggleIsSelected() {
        isSelected = true
    }
}
