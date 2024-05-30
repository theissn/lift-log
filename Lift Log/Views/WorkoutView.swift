//
//  WorkoutView.swift
//  Lift Log
//
//  Created by t4 on 16/05/2024.
//

import SwiftUI

struct WorkoutView: View {
    @State var startTime = Date()
    @State var currentWorkoutTime = "00:00"
    @State var currentRestTime = "00:00"
    @State var currentSetEndedAt: Date?
    @State var timer: Timer?
    @State var restTimer: Timer?
    @State var isChecked = false
    @State private var showingPopover = false
    
    @ObservedObject var viewModel: WorkoutViewModel
    
    @State var sets: [WorkoutSet] = []
    
    @Environment(\.dismiss) var dismiss
    
    @State var showCancelAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                    ]) {
                        VStack {
                            Text("Duration")
                                .fontWeight(.bold)
                                .font(.system(size: 14, design: .monospaced))
                                .padding(.bottom, 8)
                            
                            Text("\(currentWorkoutTime)")
                                .font(.system(size: 20, design: .monospaced))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .border(Color(.systemGray4).opacity(0.8))
                        
                        VStack {
                            Text("Rest")
                                .fontWeight(.bold)
                                .font(.system(size: 14, design: .monospaced))
                                .padding(.bottom, 8)
                            
                            HStack {
                                Text("\(currentRestTime)")
                                    .font(.system(size: 20, design: .monospaced))
                                
                                if let _ = currentSetEndedAt {
                                    Button {
                                        self.stopRestTimer()
                                    } label: {
                                        Image(systemName: "xmark.circle")
                                            .imageScale(.small)
                                            .foregroundColor(.primary)
                                    }
                                    
                                }
                            }
                            
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .border(Color(.systemGray4).opacity(0.8))
                        
                        
                        VStack {
                            Text("Excercise")
                                .fontWeight(.bold)
                                .font(.system(size: 14, design: .monospaced))
                                .padding(.bottom, 8)
                            
                            HStack {
                                Text(self.viewModel.lift.rawValue)
                                    .font(.system(size: 20, design: .monospaced))
                                
                                Button {
                                    self.showingPopover = true
                                } label: {
                                    Image(systemName: "info.circle")
                                        .imageScale(.small)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .border(Color(.systemGray4).opacity(0.8))
                        
                        VStack {
                            Text("Day")
                                .fontWeight(.bold)
                                .font(.system(size: 14, design: .monospaced))
                                .padding(.bottom, 8)
                            
                            Text("\(startTime.formatted(Date.FormatStyle().weekday(.abbreviated)))")
                                .font(.system(size: 20, design: .monospaced))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .border(Color(.systemGray4).opacity(0.8))
                    }
                    .padding(.horizontal, 8)
                    .padding(.top)
                    
                    VStack {
                        Divider()
                            .padding(.top)
                        
                        HStack {
                            Text("WARM-UP")
                                .fontWeight(.bold)
                                .font(.system(size: 14, design: .monospaced))
                                .padding(.vertical, 8)
                            
                            Spacer()
                        }
                        .padding(.horizontal)

                        
                        ForEach(sets.filter({ $0.workoutSection == .warmup })) { set in
                            WorkoutSetCell(
                                set: set,
                                updateSet: {
                                    updateSet($0)
                                }, 
                                startRestTimer: self.startRestTimer
                            )
                            
                            Divider()
                        }
                        
                        HStack {
                            Text("MAIN")
                                .fontWeight(.bold)
                                .font(.system(size: 14, design: .monospaced))
                                .padding(.vertical, 8)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ForEach(sets.filter({ $0.workoutSection == .main })) { set in
                            WorkoutSetCell(
                                set: set,
                                updateSet: {
                                    updateSet($0)
                                },
                                startRestTimer: self.startRestTimer
                            )
                            
                            Divider()
                        }
                        
//                        Button {
//                        } label: {
//                            HStack {
//                                Image(systemName: "plus.app")
//                                Text("Add Set")
//                            }
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color(.systemGray4))
//                        }
//                        .padding()
                    }
                }
            }
            .sheet(isPresented: self.$showingPopover, content: {
                MaxesView(viewModel: self.viewModel)
                //                    .padding()
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        self.showCancelAlert = true
                    }
                    .foregroundStyle(.primary)
                    .alert("Delete Workout?", isPresented: $showCancelAlert, actions: {
                        Button(role: .destructive) {
                            dismiss()
                        } label: {
                            Text("Delete")
                        }
                        
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Complete") {
                        for set in sets {
                            print(set.id, set.completedAt, set.reps, set.setNum)
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .onAppear {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                let now = Date()
                let difference = Calendar.current.dateComponents([.hour, .minute], from: startTime, to: now)
                
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute]
                formatter.unitsStyle = .positional
                formatter.zeroFormattingBehavior = .pad
                
                if let formattedDifference = formatter.string(from: difference) {
                    currentWorkoutTime = formattedDifference
                }
                
            }
            
            self.sets = viewModel.getSets(lift: self.viewModel.lift)
        }
        .onDisappear {
            self.timer?.invalidate()
            self.restTimer?.invalidate()
        }
    }
    
    private func startRestTimer() {
        self.stopRestTimer()
        
        currentSetEndedAt = Date()
        guard let restStart = currentSetEndedAt else { return }
        
        self.restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let now = Date()
            let difference = Calendar.current.dateComponents([.minute, .second], from: restStart, to: now)
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            
            if let formattedDifference = formatter.string(from: difference) {
                currentRestTime = formattedDifference
            }
        }
    }
    
    private func stopRestTimer() {
        currentRestTime = "00:00"
        currentSetEndedAt = nil
        restTimer?.invalidate()
    }
    
    private func updateSet(_ set: WorkoutSet) {
        if let index = sets.firstIndex(where: { $0.id == set.id }) {
            sets[index] = set
        }
        
        if set.completedAt == nil {
            self.stopRestTimer()
        }
    }
    
    private func dateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: self.startTime)
    }
}

#Preview {
    WorkoutView(viewModel: WorkoutViewModel())
}
