//
//  WorkoutViewModel.swift
//  Lift Log
//
//  Created by t4 on 17/05/2024.
//

import Foundation
import SwiftUI

class WorkoutViewModel: ObservableObject {
    @AppStorage("week") var week = 1
    @AppStorage("trainingMax") var trainingMax: Double = 80
    
    @AppStorage("squatMax") var squatMax: Double = 100
    @AppStorage("deadliftMax") var deadliftMax: Double = 120
    @AppStorage("benchMax") var benchMax: Double = 80
    @AppStorage("ohpMax") var ohpMax: Double = 60
    
    @Published var showWorkoutSheet = false
    @Published var lift: LiftType = .squat
    
    func startWorkout(lift: LiftType) {
        self.showWorkoutSheet = true
    }
    
    func getTopSet(lift: LiftType) -> String {
        let percentage = self.getMainSetPercentages().last ?? 0.5
        let reps = self.getReps().last ?? 5
        let unit = UserDefaults.standard.string(forKey: "unit") ?? "kg"
        let weight = self.getWeight(lift: lift)
        let liftWeight = (weight * (self.trainingMax / 100)) * percentage
        
        let prettyWeight = Formatter.roundToNearestPlate(number: liftWeight)
        
        return "\(reps)+ @ \(prettyWeight) \(unit)"
    }
    
    func getSets(lift: LiftType) -> [WorkoutSet] {
        let weight = self.getWeight(lift: lift)
        var sets: [WorkoutSet] = []
        
        sets.append(contentsOf: self.getWarmupSets(lift: lift, weight: weight))
        sets.append(contentsOf: self.getMainSets(lift: lift, weight: weight))
        
        return sets
    }
    
    private func getWarmupSets(lift: LiftType, weight: Double) -> [WorkoutSet] {
        var sets: [WorkoutSet] = []
        
        if self.week == 4 {
            return sets
        }

        for (index, percentage) in [0.4, 0.5, 0.6].enumerated() {
            let liftWeight = (weight * (self.trainingMax / 100)) * percentage

            sets.append(WorkoutSet(
                id: UUID(),
                setNum: index + 1,
                liftType: lift,
                liftName: lift.rawValue,
                workoutSection: .warmup,
                weight: Formatter.roundToNearestPlate(number: liftWeight),
                reps: 5,
                percentage: percentage
            ))
        }
        
        return sets
    }
    
    private func getMainSets(lift: LiftType, weight: Double) -> [WorkoutSet] {
        var sets: [WorkoutSet] = []
        
        let reps = self.getReps()
        
        for (index, percentage) in getMainSetPercentages().enumerated() {
            let liftWeight = (weight * (self.trainingMax / 100)) * percentage
            
            sets.append(WorkoutSet(
                id: UUID(), 
                setNum: (index + 1) + 3,
                liftType: lift,
                liftName: lift.rawValue,
                workoutSection: .main,
                weight: Formatter.roundToNearestPlate(number: liftWeight),
                reps: reps[index],
                amrap: index == 2 ? 0 : nil,
                percentage: percentage
            ))
        }
        
        return sets
    }
    
    private func getMainSetPercentages() -> Array<Double> {
        switch week {
        case 1:
            return [0.65, 0.75, 0.85]
        case 2:
            return [0.7, 0.8, 0.9]
        case 3:
            return [0.75, 0.85, 0.95]
        case 4:
            return [0.4, 0.5, 0.6]
        default:
            return []
        }
    }
    
    private func getReps() -> Array<Int> {
        switch week {
        case 2:
            return [3,3,3]
        case 3:
            return [5,3,1]
        default:
            return [5,5,5]
        }
    }
    
    func getWeight(lift: LiftType) -> Double {
        switch lift {
        case .squat:
            return self.squatMax
        case .ohp:
            return self.ohpMax
        case .bench:
            return self.benchMax
        case .deadlift:
            return self.deadliftMax
        case .accessory:
            return 0
        }
    }
    
    func getTrainingMax(lift: LiftType) -> Double {
        let weight = self.getWeight(lift: lift)
        let liftWeight = weight * (self.trainingMax / 100)
        let prettyWeight = Formatter.roundToNearestPlate(number: liftWeight)
        
        return prettyWeight
        
    }
}
