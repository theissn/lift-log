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
    
    func getTopSet(lift: LiftType) -> String {
        let percentage = self.getMainSetPercentages().last ?? 0.5
        let reps = self.getReps().last ?? 5
        let unit = UserDefaults.standard.string(forKey: "unit") ?? "kg"
        let weight = self.getWeight(lift: lift) ?? 100
        let liftWeight = (weight * (self.trainingMax / 100)) * percentage
        
        let prettyWeight = self.roundToNearest2dot5(number: liftWeight)
        
        return "\(prettyWeight) \(unit) @ \(reps)+"
    }
    
    func getSets(lift: LiftType) -> [WorkoutSet] {
        return []
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

    private func getWeight(lift: LiftType) -> Double? {
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
    
    private func roundToNearest2dot5(number: Double) -> Double {
        let scaled = ceil(number / 2.5)
        let rounded = scaled.rounded() // Use standard rounding
        return rounded * 2.5
    }
}
