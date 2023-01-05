//
//  SubsystemBlockType.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import Foundation

public enum SubsystemBlockType: String, Identifiable, CaseIterable {
    case firstType = "Тип 1"
    case secondType = "Тип 2"
    case thirdType = "Тип 3"
    case fourthType = "Тип 4"

    public var id: Self {
        self
    }

    var block: [SchemeElement] {
        switch self {
        case .firstType:
            return createFirstTypeBlock()
        case .secondType:
            return createSecondTypeBlock()
        case .thirdType:
            return createThirdTypeBlock()
        case .fourthType:
            return createFourthTypeBlock()

        }
    }
    
}

extension SubsystemBlockType {
    func createFirstTypeBlock() -> [SchemeElement] {
        let block = [SchemeElement(title: "Первый элемент",
                                   timeToFailure: "10000",
                                   intensityMistakes: "1e-4",
                                   installationDate: .now)]

        return block
    }

    func createSecondTypeBlock() -> [SchemeElement] {
        var block = createFirstTypeBlock()
        block.append(SchemeElement(title: "Второй элемент",
                                   timeToFailure: "10000",
                                   intensityMistakes: "1e-4",
                                   installationDate: .now))

        return block
    }

    func createThirdTypeBlock() -> [SchemeElement] {
        var block = createSecondTypeBlock()
        block.append(SchemeElement(title: "Третий элемент",
                                   timeToFailure: "10000",
                                   intensityMistakes: "1e-4",
                                   installationDate: .now))

        return block
    }

    func createFourthTypeBlock() -> [SchemeElement] {
        var block = createThirdTypeBlock()
        block.append(SchemeElement(title: "Четвертый элемент",
                                   timeToFailure: "10000",
                                   intensityMistakes: "1e-4",
                                   installationDate: .now))

        return block
    }
}
