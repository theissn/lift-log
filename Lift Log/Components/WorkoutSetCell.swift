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
    
    var body: some View {
        VStack {
            HStack {
                //                Button {
                //                    showEditSheet = true
                //                } label: {
                //                    Image(systemName: "square.and.pencil")
                //                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                //                        .foregroundColor(.primary)
                //                }
                //                .padding(.trailing, 8)
                
                Button {
                    print(set.setNum)
                    
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
                        Text("Set \(set.setNum)")
                            .font(.system(size: 16, design: .monospaced))
                            .fontWeight(.semibold)
                        
                        
                        Text(getPrettyWeight(reps: set.reps))
                            .font(.system(size: 16, design: .monospaced))
                            .fontWeight(.semibold)
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
                
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EmptyView()
        }
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
//    WorkoutSetCell()
//}
