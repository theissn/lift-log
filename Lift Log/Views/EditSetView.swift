//
//  EditSetView.swift
//  Lift Log
//
//  Created by theis on 05/06/2024.
//

import SwiftUI
import SwiftData

struct EditSetView: View {
    @Environment(\.dismiss) var dismiss
    @State var set: WorkoutSet
    var deleteSet: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    HStack {
                        Text("Weight")
                        Spacer()
                        TextField("Weight", value: $set.weight, format: .number)
                    }
                    
                    HStack {
                        Text("Reps")
                        Spacer()
                        TextField("Reps", value: $set.reps, format: .number)
                    }
                }
                .multilineTextAlignment(.trailing)
                
                Button {
                    deleteSet()
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.primaryBrand)
                        .cornerRadius(10)
                        .foregroundColor(.primary)

                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
        }
    }
}

//#Preview {
//    VStack {
//        EditSetView(set: WorkoutSet(id: UUID(), setNum: 1, liftType: .squat, liftName: LiftType.squat.rawValue, workoutSection: .main, weight: 200, reps: 5))
//    }
//        .modelContainer(for: [WorkoutSet.self])
//}
