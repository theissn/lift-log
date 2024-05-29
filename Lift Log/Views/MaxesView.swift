//
//  MaxesView.swift
//  Lift Log
//
//  Created by theis on 29/05/2024.
//

import SwiftUI

struct RepMaxFormula {
    var result: String
    var name: String
}

struct MaxesView: View {
    var viewModel: WorkoutViewModel
    
    @State var weight: Double = 60
    @State var reps: Double = 10
    
    @State var formulas: [RepMaxFormula] = []
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                Text("MAXES")
                    .font(.system(size: 24, design: .monospaced))
                    .fontWeight(.bold)
                    .padding(.vertical)
                
                LazyVGrid(columns: columns, content: {
                    ForEach(LiftType.allCases.filter({ $0 != .accessory }), id: \.rawValue) { lift in
                        VStack {
                            Text(lift.rawValue)
                                .font(.system(size: 20, design: .monospaced))
                                .padding(.bottom, 16)
                            
                            HStack(spacing: 30) {
                                VStack {
                                    Text("1RM")
                                        .font(.system(size: 14, design: .monospaced))
                                    
                                    Text(String(format: "%.2f", viewModel.getWeight(lift: lift)))
                                        .font(.system(size: 18, design: .monospaced))
                                }
                                
                                VStack {
                                    Text("TMAX")
                                        .font(.system(size: 14, design: .monospaced))
                                    
                                    Text(String(format: "%.2f", viewModel.getTrainingMax(lift: lift)))
                                        .font(.system(size: 18, design: .monospaced))
                                }
                                
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .border(Color(.systemGray4).opacity(0.8))
                    }
                })
                
                VStack {
                    Text("CALC 1RM")
                        .font(.system(size: 20, design: .monospaced))
                        .fontWeight(.bold)
                        .padding(.vertical)

                    
                    HStack {
                        Text("Weight")
                        
                        TextField("Weight", value: $weight, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(8)
                    .border(Color(.systemGray4).opacity(0.8))
                    
                    
                    HStack {
                        Text("Reps")
                        TextField("Reps", value: $reps, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(8)
                    .border(Color(.systemGray4).opacity(0.8))
                    
                    Button {
                        self.calc1RM()
                    } label: {
                        Text("Calculate")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .border(Color(.systemGray4).opacity(0.8))
                            .foregroundColor(.primary)

                    }

                }
                
                HStack {
                    ForEach(formulas, id: \.name) { formula in
                        VStack {
                            Text(formula.name)
                                .fontWeight(.bold)
                                .font(.system(size: 14, design: .monospaced))
                                .padding(.bottom, 8)
                            
                            Text(formula.result)
                                .font(.system(size: 20, design: .monospaced))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .border(Color(.systemGray4).opacity(0.8))
                    }
                }
//                .padding(.horizontal, 8)
                .padding(.top)
            }
            .padding(.horizontal, 8)
        }
        .onAppear {
            self.calc1RM()
        }
    }
    
    private func calc1RM() {
        let brzycki = self.weight / (1.0278 - 0.0278 * self.reps)
        let landers = (100 * self.weight) / (101.3 - 2.67123 * self.reps)
        let epley = self.weight * (1 + 0.0333 * self.reps)
        
        self.formulas = []
        
        formulas.append(RepMaxFormula(result: String(format: "%.2f", brzycki), name: "Brzycki"))
        formulas.append(RepMaxFormula(result: String(format: "%.2f", landers), name: "Lander"))
        formulas.append(RepMaxFormula(result: String(format: "%.2f", epley), name: "Epley"))
    }
}

#Preview {
    MaxesView(viewModel: WorkoutViewModel())
}
