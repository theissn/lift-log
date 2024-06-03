//
//  Lift.swift
//  Lift Log
//
//  Created by theis on 03/06/2024.
//

import Foundation
import SwiftData


@Model
class Lift {
    @Attribute(.unique) var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
