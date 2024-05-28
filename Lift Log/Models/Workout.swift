//
//  Workout.swift
//  Lift Log
//
//  Created by t4 on 16/05/2024.
//

import Foundation
import SwiftData

@Model
class Workout {
    @Attribute(.unique) var id: UUID
    var startTime: Date
    var endTime: Date
    var notes: String?
    
    @Relationship var workoutSets: [WorkoutSet]
    
    init(id: UUID, startTime: Date, endTime: Date, notes: String? = nil, workoutSets: [WorkoutSet]) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes
        self.workoutSets = workoutSets
    }
}
