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
    @State var timer: Timer?
    @State var isChecked = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
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
                        Text("Excercise")
                            .fontWeight(.bold)
                            .font(.system(size: 14, design: .monospaced))
                            .padding(.bottom, 8)
                        
                        Text("Squat")
                            .font(.system(size: 20, design: .monospaced))
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
                
                ScrollView {
                    VStack {
                        Divider()
                            .padding(.top)
                        
                        ForEach(0..<50) { x in
                            HStack {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "slider.horizontal.2.square")
                                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                                        .foregroundColor(.primary)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Set \(x + 1)")
                                        .font(.system(size: 16, design: .monospaced))
                                        .fontWeight(.semibold)
                                    
                                    Text("\(x * 10)kg x 5")
                                        .font(.system(size: 16, design: .monospaced))
                                        .fontWeight(.semibold)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    isChecked.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                                            .font(.system(size: 18, weight: .regular, design: .monospaced))
                                            .foregroundColor(.primary)
//
//                                        Text("Checkbox")
//                                            .font(.system(size: 18, weight: .regular, design: .monospaced))
//                                            .foregroundColor(.primary)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())

                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .onTapGesture {
                                self.isChecked.toggle()
                            }
                            
                            Divider()
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        
                    }
                    .foregroundStyle(.primary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Complete") {
                        
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
                
                print(difference, startTime, now)
                
                if let formattedDifference = formatter.string(from: difference) {
                    currentWorkoutTime = formattedDifference
                }

            }
        }
        .onDisappear {
            self.timer?.invalidate()
        }
    }
    
    private func dateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: self.startTime)
    }
}

#Preview {
    WorkoutView()
}
