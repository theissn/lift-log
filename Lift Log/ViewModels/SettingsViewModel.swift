//
//  SettingsViewModel.swift
//  Lift Log
//
//  Created by theis on 29/05/2024.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("squatMax") var squatMax: Double = 100
    @AppStorage("deadliftMax") var deadliftMax: Double = 120
    @AppStorage("benchMax") var benchMax: Double = 80
    @AppStorage("ohpMax") var ohpMax: Double = 60
    
    @AppStorage("trainingMax") var trainingMax: Double = 80
    @AppStorage("unit") var unit: String = "kg"
}
