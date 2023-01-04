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

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, stashController.contatiner.viewContext)
        }
    }
}
