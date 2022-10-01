//
//  ParseData.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 12.09.2022.
//

import Foundation

class ParseData: ObservableObject  {

    @Published var intensityMistakes = [IntensityMistakes]()

    init(){
        loadData()
    }

    func loadData() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            print("Json file not found")
            return
        }

        do {
            let data = try? Data(contentsOf: url)
            let intensityMistakes = try JSONDecoder().decode([IntensityMistakes].self, from: data!)
            self.intensityMistakes = intensityMistakes
        } catch {
            print(error)
        }
    }

    func loadBlankModel() {
        guard let url = Bundle.main.url(forResource: "blankData", withExtension: "json") else {
            print("Json file not found")
            return
        }

        do {
            let data = try? Data(contentsOf: url)
            let blankModel = try JSONDecoder().decode([IntensityMistakes].self, from: data!)
            self.intensityMistakes.append(contentsOf: blankModel)
        } catch {
            print(error)
        }
    }

    func deleteModel(_ offsets: IndexSet) {
        self.intensityMistakes.remove(atOffsets: offsets)
    }

    func saveData() {
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

        guard let url = Bundle.main.url(forResource: "savedData", withExtension: "json") else {
            print("Json file not found")
            return
        }

        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self.intensityMistakes)
            try jsonData.write(to: url, options: [.atomic, .noFileProtection])
        } catch {
            print(error)
        }
    }
}
