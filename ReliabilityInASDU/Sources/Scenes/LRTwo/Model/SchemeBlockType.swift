//
//  SchemeBlockType.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import Foundation

enum SchemeBlockType: String, Identifiable, CaseIterable {
    case empty = "_"
    case firstType = "Тип 1"
    case secondType = "Тип 2"
    case thirdType = "Тип 3"
    case fourthType = "Тип 4"

    var id: Self {
        self
    }

    var block: [SchemeElement] {
        switch self {
        case .empty:
            return [SchemeElement]()
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

extension SchemeBlockType {
    func createFirstTypeBlock() -> [SchemeElement] {
        let block = [SchemeElement(title: "Первый элемент",
                                   timeToFailure: "10",
                                   intensityMistakes: "1e-1",
                                   installationDate: .now)]

        return block
    }

    func createSecondTypeBlock() -> [SchemeElement] {
        var block = createFirstTypeBlock()
        block.append(SchemeElement(title: "Второй элемент",
                                   timeToFailure: "10",
                                   intensityMistakes: "1e-1",
                                   installationDate: .now))

        return block
    }

    func createThirdTypeBlock() -> [SchemeElement] {
        var block = createSecondTypeBlock()
        block.append(SchemeElement(title: "Третий элемент",
                                   timeToFailure: "10",
                                   intensityMistakes: "1e-1",
                                   installationDate: .now))

        return block
    }

    func createFourthTypeBlock() -> [SchemeElement] {
        var block = createThirdTypeBlock()
        block.append(SchemeElement(title: "Четвертый элемент",
                                   timeToFailure: "10",
                                   intensityMistakes: "1e-1",
                                   installationDate: .now))

        return block
    }
}
