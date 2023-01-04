//
//  ParseData.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 12.09.2022.
//

import Foundation

class ParseData  {

//    @Published var intensityMistakes = [IntensityMistakes]()

//    init(){
//        loadData()
//    }

    static let shared = ParseData()
//
//    func loadData() -> [OperatorTaskModel] {
//        var result = [OperatorTaskModel]()
//
//        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
//            print("Json file not found")
//            return result
//        }
//
//        do {
//            let data = try? Data(contentsOf: url)
//            let intensityMistakes = try JSONDecoder().decode([OperatorTaskModel].self, from: data!)
//            result = intensityMistakes
////            return intensityMistakes
//        } catch {
//            print(error)
//        }
//
//        return result
//    }
//
//    func loadBlankModel() -> [OperatorTaskModel] {
//        var result = [OperatorTaskModel]()
//
//        guard let url = Bundle.main.url(forResource: "blankData", withExtension: "json") else {
//            print("Json file not found")
//            return result
//        }
//
//        do {
//            let data = try? Data(contentsOf: url)
//            let blankModel = try JSONDecoder().decode([OperatorTaskModel].self, from: data!)
////            self.intensityMistakes.append(contentsOf: blankModel)
//            result = blankModel
//        } catch {
//            print(error)
//        }
//
//        return result
//    }

//    func deleteModel(_ offsets: IndexSet) {
//        self.intensityMistakes.remove(atOffsets: offsets)
//    }

//    func saveData() {
//        guard let url = Bundle.main.url(forResource: "testData", withExtension: "json") else {
//            print("Json file not found")
//            return
//        }
//
//        do {
//            let data = try JSONSerialization.data(withJSONObject: self.intensityMistakes, options: [])
//            try data.write(to: url, options: [])
//        } catch {
//            print(error)
//        }

//        let documentsURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        let fileUrl = documentsURL?.appendingPathComponent("test.json")
//        let fileExists = FileManager.default.fileExists(atPath: fileUrl!.path)
//        print(fileExists)
//        print(documentsURL)
//
//        guard let url = Bundle.main.url(forResource: "savedData", withExtension: "json") else {
//            print("Json file not found")
//            return
//        }
//
//        do {
//            let jsonEncoder = JSONEncoder()
//            let jsonData = try jsonEncoder.encode(self.intensityMistakes)
//            try jsonData.write(to: url, options: [.atomic, .noFileProtection])
//        } catch {
//            print(error)
//        }
//    }
}
