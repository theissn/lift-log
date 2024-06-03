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
    
    var setNum: Int
    var liftType: LiftType
    var liftName: String
    var workoutSection: WorkoutSection
    var weight: Double
    var reps: Int
    var completedAt: Date?
    var amrap: Int?
    var percentage: Double?
    
    init(id: UUID, setNum: Int, liftType: LiftType, liftName: String, workoutSection: WorkoutSection, weight: Double, reps: Int, completedAt: Date? = nil, amrap: Int? = nil, percentage: Double? = nil) {
        self.id = id
        self.setNum = setNum
        self.liftType = liftType
        self.liftName = liftName
        self.workoutSection = workoutSection
        self.weight = weight
        self.reps = reps
        self.completedAt = completedAt
        self.amrap = amrap
        self.percentage = percentage
    }
}
