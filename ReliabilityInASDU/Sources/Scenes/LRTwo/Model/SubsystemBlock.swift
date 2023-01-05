//
//  SubsystemBlock.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 29.11.2022.
//

import Foundation
import SwiftUI

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

    init(stringType: String) {
        switch stringType {
        case "Тип 1":
            self.type = .firstType
        case "Тип 2":
            self.type = .secondType
        case "Тип 3":
            self.type = .thirdType
        case "Тип 4":
            self.type = .fourthType
        default:
            self.type = .firstType
        }
    }
}
