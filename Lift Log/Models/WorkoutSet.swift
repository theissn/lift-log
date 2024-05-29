//
//  WorkoutSet.swift
//  Lift Log
//
//  Created by t4 on 16/05/2024.
//

import Foundation
import SwiftData

enum LiftType: String, Codable, CaseIterable {
    case squat = "Squat"
    case ohp = "OHP"
    case bench = "Bench"
    case deadlift = "Deadlift"
    case accessory = "Accessory"
}

enum WorkoutSection: String, Codable {
    case warmup
    case main
    case assistance
}

@Model
class WorkoutSet {
    @Attribute(.unique) var id: UUID
    
    var liftType: LiftType
    var liftName: String
    var workoutSection: WorkoutSection
    var weight: Double
    var reps: Int
    var completedAt: Date
    
    init(id: UUID, liftType: LiftType, liftName: String, workoutSection: WorkoutSection, weight: Double, reps: Int, completedAt: Date) {
        self.id = id
        self.liftType = liftType
        self.liftName = liftName
        self.workoutSection = workoutSection
        self.weight = weight
        self.reps = reps
        self.completedAt = completedAt
    }
}
