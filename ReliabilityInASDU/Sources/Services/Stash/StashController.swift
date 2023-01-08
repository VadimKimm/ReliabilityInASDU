//
//  StashController.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 04.01.2023.
//

import CoreData

struct StashController {
    static let shared = StashController()

    let contatiner: NSPersistentContainer

    init() {
        contatiner = NSPersistentContainer(name: "Stash")
        contatiner.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error \(error.localizedDescription)")
            }
        }
    }

    func deleteAllData(entity: String) {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try contatiner.viewContext.execute(DelAllReqVar) }
        catch { print(error) }
    }
}
