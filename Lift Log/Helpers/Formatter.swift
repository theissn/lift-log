//
//  Formatter.swift
//  Lift Log
//
//  Created by theis on 30/05/2024.
//

import Foundation

class Formatter {
    static func roundToNearest2dot5(number: Double, isKg: Bool = true) -> Double {
        let scaled = ceil(number / 2.5)
        let rounded = scaled.rounded() // Use standard rounding
        let final = rounded * 2.5
        
        let minValue: Double = isKg ? 20 : 45
        
        return final < minValue ? minValue : final
    }
}
