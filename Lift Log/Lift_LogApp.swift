//
//  Lift_LogApp.swift
//  Lift Log
//
//  Created by t4 on 16/05/2024.
//

import SwiftUI
import SwiftData

@main
struct Lift_LogApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Workout.self, WorkoutSet.self])
        }
    }
}
