//
//  nFactorialAtHogwartsApp.swift
//  nFactorialAtHogwarts
//
//  Created by Акбала Тлеугалиева on 29.06.2023.
//

import SwiftUI

@main
struct nFactorialAtHogwartsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
