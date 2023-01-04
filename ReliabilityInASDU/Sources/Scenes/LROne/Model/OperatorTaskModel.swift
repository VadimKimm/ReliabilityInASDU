//
//  OperatorTaskModel.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 12.09.2022.
//

import Foundation

public class OperatorTaskModel: NSObject, Identifiable, NSCoding {
    public var id = UUID()
    public var intensityMistakes: String = ""
    public var descriptionModel: String = ""
    public var numberOfOperations: String = ""
    public var averageTime: String = ""

    enum CodingKeys: CodingKey {
        case intensityMistakes
        case description
        case numberOfOperations
        case averageTime
    }

    init(intensityMistakes: String, descriptionModel: String, numberOfOperations: String, averageTime: String) {
        self.intensityMistakes = intensityMistakes
        self.descriptionModel = descriptionModel
        self.numberOfOperations = numberOfOperations
        self.averageTime = averageTime
    }

    public override init() {
        super.init()
    }

    public required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as? UUID ?? UUID()
        intensityMistakes = coder.decodeObject(forKey: "intensityMistakes") as? String ?? ""
        descriptionModel = coder.decodeObject(forKey: "descriptionModel") as? String ?? ""
        numberOfOperations = coder.decodeObject(forKey: "numberOfOperations") as? String ?? ""
        averageTime = coder.decodeObject(forKey: "averageTime") as? String ?? ""
    }

    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(intensityMistakes, forKey: "intensityMistakes")
        coder.encode(descriptionModel, forKey: "descriptionModel")
        coder.encode(numberOfOperations, forKey: "numberOfOperations")
        coder.encode(averageTime, forKey: "averageTime")
    }

}

extension OperatorTaskModel {
    static func createBlankModel() -> OperatorTaskModel {
        let model = OperatorTaskModel(intensityMistakes: "10-3",
                                      descriptionModel: "---",
                                      numberOfOperations: "1",
                                      averageTime: "1")
        return model
    }
}
