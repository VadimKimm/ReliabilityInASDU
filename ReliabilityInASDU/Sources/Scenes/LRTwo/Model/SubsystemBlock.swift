//
//  SubsystemBlock.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 29.11.2022.
//

import Foundation
import SwiftUI

public class SubsystemBlock: NSObject, NSCoding, Identifiable {
    @Published public var id = UUID()
    public var _type: SubsystemBlockType = .firstType
    public var type: SubsystemBlockType {
        get {
            return _type
        } set {
            _type = newValue
            elements = newValue.block
        }
    }

    public var elements: [SchemeElement] = []
    public var isSelected = false

    func toggleIsSelected() {
        isSelected = true
    }

    init(type: SubsystemBlockType) {
        super.init()
        self.type = type
    }

    init(stringType: String) {
        switch stringType {
        case "Тип 1":
            self._type = .firstType
        case "Тип 2":
            self._type = .secondType
        case "Тип 3":
            self._type = .thirdType
        case "Тип 4":
            self._type = .fourthType
        default:
            self._type = .firstType
        }
    }

    public override init() {
        super.init()
    }

    public required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as? UUID ?? UUID()
        _type = coder.decodeObject(forKey: "type") as? SubsystemBlockType ?? SubsystemBlockType.firstType
        elements = coder.decodeObject(forKey: "elements") as? [SchemeElement] ?? [SchemeElement]()
        isSelected = coder.decodeObject(forKey: "isSelected") as? Bool ?? false
    }

    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(type, forKey: "type")
        coder.encode(elements, forKey: "telements")
        coder.encode(isSelected, forKey: "isSelected")
    }
}
