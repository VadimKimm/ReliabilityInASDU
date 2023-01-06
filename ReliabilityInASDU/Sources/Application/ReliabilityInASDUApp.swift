//
//  ReliabilityInASDUApp.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 12.09.2022.
//

import SwiftUI

@main
struct ReliabilityInASDUApp: App {

    let stashController = StashController.shared
    let migrator = Migrator()

    var body: some Scene {
        WindowGroup {
            let _ = UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            MainView()
                .environment(\.managedObjectContext, stashController.contatiner.viewContext)
        }
    }
}
