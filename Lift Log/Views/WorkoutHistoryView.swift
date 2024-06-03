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
                                        Text(workout.liftType.rawValue)
                                            .font(.system(size: 16, design: .monospaced))
                                            .fontWeight(.bold)
                                        Spacer()
                                        
                                        Text(dateFormatter(workout.endTime))
                                            .font(.system(size: 16, design: .monospaced))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray4))
                                .cornerRadius(12)
                            }
                        }
                    }
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
}

#Preview {
    WorkoutHistoryView()
}
