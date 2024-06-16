//
//  Formatter.swift
//  Lift Log
//
//  Created by theis on 30/05/2024.
//

import Foundation

class Formatter {
    static func roundToNearestPlate(number: Double, isKg: Bool = true) -> Double {
        let numberToAimFor = isKg ? 2.5 : 5
        
        let scaled = ceil(number / numberToAimFor)
        let rounded = scaled.rounded() // Use standard rounding
        let final = rounded * numberToAimFor
        
        let minValue: Double = isKg ? 20 : 45
        
        return final < minValue ? minValue : final
    }
}
