//
//  SettingsView.swift
//  Lift Log
//
//  Created by theis on 29/05/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    
    @State private var formatter = NumberFormatter()
    @FocusState private var isFocused
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Settings")
                        .foregroundStyle(.primaryBrand)
                        .font(.system(size: 26, design: .monospaced))
                        .fontWeight(.black)
                        .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        LiftInputRow(name: "Squat", value: $viewModel.squatMax, unit: viewModel.unit, isFocused: $isFocused)
                        LiftInputRow(name: "Deadlift", value: $viewModel.deadliftMax, unit: viewModel.unit, isFocused: $isFocused)
                        LiftInputRow(name: "Bench", value: $viewModel.benchMax, unit: viewModel.unit, isFocused: $isFocused)
                        LiftInputRow(name: "OHP", value: $viewModel.ohpMax, unit: viewModel.unit, isFocused: $isFocused)
                        
                        HStack {
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.primaryBrand)
                                    .frame(width: 48, height: 48)
                                
                                Image(systemName: "percent")
                                    .foregroundColor(.primaryBrand)

                            }
                            .padding(.trailing, 8)
                            
                            Text("Training Max")
                                .font(.headline)
                            
                            Spacer()
                            
                            TextField("", value: $viewModel.trainingMax, formatter: self.formatter)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .focused($isFocused)
                                .frame(width: 80)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGroupedBackground))
                                .cornerRadius(8)
                            
                            Text("%")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    
                    HStack {
                        Button {
                            changeCycle(lowerWeight: -5, upperWeight: -2.5)
                        } label: {
                            HStack {
                                Image(systemName: "arrowshape.turn.up.backward")
                                Text("Prev Cycle")
                            }
                                .tint(.primaryBrand)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .border(.primaryBrand)
                        }
                        .padding()
                        
                        Button {
                            changeCycle(lowerWeight: 5, upperWeight: 2.5)
                        } label: {
                            HStack {
                                Image(systemName: "arrowshape.turn.up.right")
                                Text("Next Cycle")
                            }
                                .tint(.primaryBrand)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .border(.primaryBrand)
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            self.isFocused = false
                        }
                        .font(.system(size: 16, design: .monospaced))
                        .tint(.primaryBrand)
                    }
            }
            }
        }
        .onAppear {
            self.formatter.numberStyle = .decimal
        }
    }
    
    private func changeCycle(lowerWeight: Double, upperWeight: Double) {
        self.viewModel.squatMax += lowerWeight
        self.viewModel.deadliftMax += lowerWeight
        self.viewModel.benchMax += upperWeight
        self.viewModel.ohpMax += upperWeight
    }
}

struct LiftInputRow: View {
    var name: String
    @Binding var value: Double
    var unit: String
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.primaryBrand)
                    .frame(width: 48, height: 48)
                
                Text("\(name[0])")
                    .foregroundStyle(.primaryBrand)
                    .font(.system(size: 20, design: .monospaced))

            }
            .padding(.trailing, 8)
            
            Text(name)
                .font(.system(size: 18, design: .monospaced))
                .fontWeight(.bold)
            
            Spacer()
            
            TextField("", value: $value, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .focused($isFocused)
                .frame(width: 80)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(8)
            
            Text(unit)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    SettingsView()
}
