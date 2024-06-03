//
//  WorkoutSetCell.swift
//  Lift Log
//
//  Created by theis on 30/05/2024.
//

import SwiftUI

struct WorkoutSetCell: View {
    @State var set: WorkoutSet
    
    @State var showEditSheet = false
    @State var showAmrapPopup = false
    @State var amrap: Int = 0
    @State var hasSetAmrap = false
    
    var updateSet: (_ set: WorkoutSet) -> Void
    var startRestTimer: () -> Void
    var showLiftName: Bool = false
    var canUpdate: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    showEditSheet = true
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                        .foregroundColor(.primary)
                        .opacity(canUpdate ? 1 : 0.5)
                }
                .padding(.trailing, 8)
                .disabled(!canUpdate)
                
                Button {
                    if !canUpdate {
                        return
                    }
                    
                    if set.completedAt != nil {
                        set.completedAt = nil
                        updateSet(set)
                        return
                    }
                    
                    if set.amrap != nil {
                        self.showAmrapPopup = true
                        return
                    }
                    
                    self.updateSetAttr()
                } label: {
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Text("Set \(set.setNum)")
                                .font(.system(size: 16, design: .monospaced))
                                .fontWeight(.semibold)
                            
                            if self.showLiftName {
                                Text(" - \(set.liftName)")
                                    .font(.system(size: 16, design: .monospaced))
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        HStack(spacing: 4) {
                            Text(getPrettyWeight(reps: set.reps))
                                .font(.system(size: 16, design: .monospaced))
                                .fontWeight(.semibold)
                            
                            if let percentage = set.percentage {
                                Text("(\(String(format: "%.0f", percentage * 100))%)")
                                    .font(.system(size: 16, design: .monospaced))
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.top, 4)
                            
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: set.completedAt != nil ? "checkmark.square.fill" : "square")
                            .font(.system(size: 18, weight: .regular, design: .monospaced))
                            .foregroundColor(.primary)
                    }
                }
                .foregroundStyle(.primary)
                .opacity(canUpdate ? 1 : 0.5)
                .disabled(!canUpdate)
                
            }
        }
//        .sheet(isPresented: $showEditSheet) {
//            Form {
//                TextField("")
//            }
//        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .alert("How many reps did you get?", isPresented: $showAmrapPopup) {
            TextField("Reps", value: $amrap, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
            
            Button("Save", action: {
                self.hasSetAmrap = true
                updateSetAttr()
            })
            .foregroundStyle(.primaryBrand)
        }
        .onAppear {
            self.amrap = set.reps
        }
    }
    
    private func updateSetAttr() {
        set.reps = self.amrap
        set.completedAt = Date()
        updateSet(set)
        startRestTimer()
    }
    
    private func getPrettyWeight(reps: Int) -> String {
        let unit = UserDefaults.standard.string(forKey: "unit") ?? "kg"
        
        var plus = ""
        
        
        if !hasSetAmrap {
            plus = set.amrap == nil ? "" : "+"
        }
        
        
        return "\(reps) reps\(plus) @ \(set.weight)\(unit)"
        
    }
}

//#Preview {
//    WorkoutSetCell(set: WorkoutSet(id: UUID(), setNum: 1, liftType: .squat, liftName: LiftType.squat.rawValue, workoutSection: .main, weight: 200, reps: 5, percentage: 0.75), updateSet: { print($0) }, startRestTimer: {})
//        .modelContainer(for: [Workout.self, WorkoutSet.self])
//}
