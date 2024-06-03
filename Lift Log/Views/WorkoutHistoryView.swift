//
//  WorkoutHistoryView.swift
//  Lift Log
//
//  Created by theis on 03/06/2024.
//

import SwiftUI
import SwiftData

struct WorkoutHistoryView: View {
    
    @Query(sort: \Workout.endTime, order: .reverse)
    var workouts: [Workout] = []
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("History")
                    .foregroundStyle(.primaryBrand)
                    .font(.system(size: 26, design: .monospaced))
                    .fontWeight(.black)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .padding(.top, 16)
                
                ScrollView {
                    LazyVStack {
                        ForEach(workouts) { workout in
                            NavigationLink {
                                WorkoutView(viewModel: WorkoutViewModel(), workout: workout)
                            } label: {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Cycle \(workout.week)")
                                                .font(.system(size: 14, design: .monospaced))
                                                .fontWeight(.black)
                                                .padding(.bottom, 8)

                                            HStack(alignment: .bottom) {
                                                VStack(alignment: .leading) {
                                                    Text(workout.liftType.rawValue)
                                                        .font(.system(size: 14, design: .monospaced))
                                                    
                                                    Text(topSetPretty(workout))
                                                        .font(.system(size: 14, design: .monospaced))
                                                }
                                                
                                                Spacer()
                                                
                                                Text(dateFormatter(workout.endTime))
                                                    .font(.system(size: 13, design: .monospaced))

                                            }
                                        }
                                        .foregroundColor(.primary)

                                        
//                                        Spacer()
//                                        
//                                        VStack(alignment: .trailing) {
//                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray4))
                            }
                            .padding(.bottom, 8)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    func dateFormatter(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
    
    func topSetPretty(_ workout: Workout) -> String {
        let unit = UserDefaults.standard.string(forKey: "unit") ?? "kg"
        let set = workout.workoutSets.sorted(by: { $0.weight > $1.weight }).first
        
        if let set = set {
            return "\(set.reps) @ \(set.weight)\(unit)"
        }
        
        return ""
    }
}

#Preview {
    WorkoutHistoryView()
}
