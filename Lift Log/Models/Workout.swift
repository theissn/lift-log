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
    var week: Int
    var startTime: Date
    var endTime: Date
    var liftType: LiftType
    var notes: String?
    @Relationship var workoutSets: [WorkoutSet]
    
    init(id: UUID, week: Int, startTime: Date, endTime: Date, liftType: LiftType, notes: String? = nil, workoutSets: [WorkoutSet]) {
        self.id = id
        self.week = week
        self.startTime = startTime
        self.endTime = endTime
        self.liftType = liftType
        self.notes = notes
        self.workoutSets = workoutSets
    }
}
