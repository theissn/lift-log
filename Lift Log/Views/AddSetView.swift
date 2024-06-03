//
//  AddSetView.swift
//  Lift Log
//
//  Created by theis on 03/06/2024.
//

import SwiftUI

struct AddSetView: View {
    @State var workout: String = "db_row"
    
    var body: some View {
        VStack {
            Form {
                Picker("Lift", selection: $workout) {
                    Text("DB Row").tag("db_row")
                    Text("Pull-ups").tag("pullups")
                    Text("Hanging Leg Raises").tag("hlr")
                }
            }
        }
    }
}

#Preview {
    AddSetView()
}
