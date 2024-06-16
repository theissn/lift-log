//
//  AddSetView.swift
//  Lift Log
//
//  Created by theis on 03/06/2024.
//

import SwiftUI
import SwiftData

struct AddSetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @AppStorage("unit") var unit: String = "kg"
    
    @State var workout: String = ""
    @State var weight: Double = 60
    @State var reps: Int = 10
    @State var count: Int = 1
    @State var lift: String = ""
    @State var showAddLiftAlert = false
    @Query private var lifts: [Lift] = []
    @State var type: String = "percentage"
    
    var setNumber: Int
    var tmax: Double
    var addLift: (_ set: WorkoutSet) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Weight/%", selection: $type) {
                    Text("Percentage").tag("percentage")
                    Text("Weight").tag("weight")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top)
                
                Form {
                    HStack {
                        Picker("Lift", selection: $workout) {
                            ForEach(lifts) { lift in
                                Text(lift.name).tag(lift.name)
                            }
                        }
                    }
                    
                    if type == "percentage" {
                        HStack {
                            Text("Percentage")
                            
                            TextField("Percentage", value: $weight, formatter: NumberFormatter())
                                .multilineTextAlignment(.trailing)
                            
                            Text("%")
                        }
                    }
                    
                    if type == "weight" {
                        HStack {
                            Text("Weight")
                            
                            TextField("Weight", value: $weight, formatter: NumberFormatter())
                                .multilineTextAlignment(.trailing)
                            
                            Text(self.unit)
                        }
                    }
                    
                    HStack {
                        Text("Reps")
                        
                        TextField("Reps", value: $reps, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Sets")
                        
                        TextField("Sets", value: $count, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Set(s)") {
                        for num in 0..<count {
                            var newWeight = weight
                            
                            if type == "percentage" {
                                newWeight = tmax * (weight / 100)
                                newWeight = Formatter.roundToNearestPlate(number: newWeight, isKg: true)
                            }
                            
                            let workout = WorkoutSet(id: UUID(), setNum: setNumber + num, liftType: .accessory, liftName: self.workout, workoutSection: .assistance, weight: newWeight, reps: self.reps)
                            
                            if type == "percentage" {
                                workout.percentage = weight / 100
                            }
                            
                            addLift(workout)
                        }
                        
                        dismiss()
                    }
                    .foregroundStyle(.primaryBrand)
                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        self.showAddLiftAlert.toggle()
//                    } label: {
//                        HStack {
//                            Text("Add Lift")
//                        }
//                        .foregroundStyle(.primaryBrand)
//                    }
//                    .alert("Add Lift", isPresented: $showAddLiftAlert) {
//                        TextField("Lift Name", text: $lift)
//                        
//                        Button(role: .cancel) {
//                            self.showAddLiftAlert.toggle()
//                        } label: {
//                            Text("Cancel")
//                        }
//                        
//                        Button {
//                            let lift = Lift(id: UUID(), name: self.lift)
//                            self.context.insert(lift)
//                            
//                            self.showAddLiftAlert.toggle()
//                        } label: {
//                            Text("Save")
//                        }
//                    }
//                }
            }
            .onAppear {
                initialSetupLifts()
                                
                if let name = lifts.first?.name {
                    self.workout = name
                }
            }
        }
    }
    
    private func initialSetupLifts() {
        if !lifts.isEmpty {
            return
        }
        
        let lifts = ["DB Rows", "Pull-Ups", "Hanging Leg Raises", "Hamstring Curls", "Squats", "OHP", "Bench", "Deadlift"]
        
        for lift in lifts {
            let data = Lift(id: UUID(), name: lift)
            context.insert(data)
        }
    }
}

#Preview {
    AddSetView(setNumber: 1, tmax: 200, addLift: { print($0) })
        .modelContainer(for: [Lift.self])
}
