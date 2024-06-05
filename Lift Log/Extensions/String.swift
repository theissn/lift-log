//
//  String.swift
//  Lift Log
//
//  Created by theis on 05/06/2024.
//

import Foundation

extension String {
    public subscript(_ idx: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: idx)]
    }
}
