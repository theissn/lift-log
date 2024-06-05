//
//  WorkoutView.swift
//  Lift Log
//
//  Created by t4 on 16/05/2024.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State var sets: [WorkoutSet] = []
    @State var startTime = Date()
    @State var currentWorkoutTime = "00:00"
    @State var currentRestTime = "00:00"
    @State var currentSetEndedAt: Date?
    @State var timer: Timer?
    @State var restTimer: Timer?
    @State var isChecked = false
    @State private var showingPopover = false
    @State var showCancelAlert = false
    @State var showCompleteAlert = false
    @State var showAddSetSheet = false
    @State var notesText = ""
    @State var showUpsellSheet = false
    
    var hasAssistanceSets: Bool {
        return sets.filter({ $0.workoutSection == .assistance }).isEmpty == false
    }

    var hasWarmupSets: Bool {
        return sets.filter({ $0.workoutSection == .warmup }).isEmpty == false
    }
    
    @ObservedObject var viewModel: WorkoutViewModel
    
    var workout: Workout?
    
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
                                Text(self.workout?.liftType.rawValue ?? self.viewModel.lift.rawValue)
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
                        .border(Color(.systemGray4))
                        .opacity(0.8)
     
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
                        
                        if hasWarmupSets {
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
                                    startRestTimer: self.startRestTimer,
                                    canUpdate: self.workout == nil
                                )
                                
                                Divider()
                            }
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
                                startRestTimer: self.startRestTimer,
                                canUpdate: self.workout == nil
                            )
                            
                            Divider()
                        }
                        
                        if hasAssistanceSets {
                            HStack {
                                Text("ASSISTANCE")
                                    .fontWeight(.bold)
                                    .font(.system(size: 14, design: .monospaced))
                                    .padding(.vertical, 8)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        ForEach(sets.filter({ $0.workoutSection == .assistance })) { set in
                            WorkoutSetCell(
                                set: set,
                                updateSet: {
                                    updateSet($0)
                                },
                                startRestTimer: self.startRestTimer,
                                showLiftName: true,
                                canUpdate: self.workout == nil
                            )
                            
                            Divider()
                        }
                        
                        if self.workout == nil {
                            Button {
                                self.showAddSetSheet.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "plus.app")
                                    Text("Add Set")
                                }
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray4))
                            }
                            .padding()
                            .sheet(isPresented: $showAddSetSheet) {
                                AddSetView(setNumber: self.sets.count + 1, tmax: viewModel.getTrainingMax(lift: self.viewModel.lift), addLift: { self.sets.append($0) })
                            }
                        }
                        
                        TextEditorWithLabel(text: $notesText, label: "Workout Notes", isDisabled: self.workout != nil)
                            .padding()
                    }
                }
            }
            .sheet(isPresented: self.$showingPopover, content: {
                MaxesView(viewModel: self.viewModel)
            })
            .toolbar {
                if workout == nil {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            self.showCancelAlert = true
                        }
                        .foregroundStyle(.primary)
                        .alert("Delete Workout?", isPresented: $showCancelAlert) {
                            Button(role: .destructive) {
                                dismiss()
                            } label: {
                                Text("Delete")
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Complete") {
                            self.showCompleteAlert = true
                        }
                        .foregroundStyle(.primaryBrand)
                        .alert("Save Workout?", isPresented: $showCompleteAlert) {
                            Button(role: .cancel) {
                                self.showCompleteAlert.toggle()
                            } label: {
                                Text("Cancel")
                                
                            }
                            .foregroundColor(.primary)
                            
                            Button {
//                                self.showUpsellSheet.toggle()
//                                let descriptor = FetchDescriptor<Workout>()
//                                let count = (try? modelContext.fetchCount(descriptor)) ?? 0
//
//                                print(count)
//                                
//                                return
                                
//                                print(self.notesText)
                                
                                let workout = Workout(
                                    id: UUID(),
                                    week: self.viewModel.week,
                                    startTime: self.startTime,
                                    endTime: Date(),
                                    liftType: self.viewModel.lift,
                                    notes: self.notesText,
                                    workoutSets: self.sets
                                )
                                
                                print(workout)
                                
                                context.insert(workout)
                                
                                dismiss()
                            } label: {
                                Text("Save")
                                    .foregroundColor(.primaryBrand)
                            }
                        }
                        .sheet(isPresented: $showUpsellSheet) {
                            SaveWorkoutUpsellSheet()
                                .interactiveDismissDisabled()
                        }
                    }
                }
            }
        }
        .onAppear {
            if let workout = self.workout {
                self.sets = workout.workoutSets.sorted(by: { $0.setNum < $1.setNum })
                self.startTime = workout.startTime
                self.notesText = workout.notes ?? ""
                
                calcWorkoutDuration(workout.endTime)
                
                return
            }
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                calcWorkoutDuration()
            }
            
            self.sets = viewModel.getSets(lift: self.viewModel.lift)
        }
        .onDisappear {
            self.timer?.invalidate()
            self.restTimer?.invalidate()
        }
    }
    
    private func calcWorkoutDuration(_ nowTime: Date? = nil) {
        var now = Date()
        
        if let nowTime = nowTime {
            now = nowTime
        }
        
        let difference = Calendar.current.dateComponents([.hour, .minute], from: startTime, to: now)
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        if let formattedDifference = formatter.string(from: difference) {
            currentWorkoutTime = formattedDifference
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
        .modelContainer(for: [Workout.self, WorkoutSet.self])
}
