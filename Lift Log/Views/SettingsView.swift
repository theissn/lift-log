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
            VStack {
                Form {
                    Section(header: Text("Lifts")) {
                        HStack {
                            Text("Squat")
                            
                            Spacer()
                            
                            TextField("", value: $viewModel.squatMax, formatter: self.formatter)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .focused($isFocused)
                            
                            Text("\(self.viewModel.unit)")
                        }
                        
                        HStack {
                            Text("Deadlift")
                            
                            Spacer()
                            
                            TextField("", value: $viewModel.deadliftMax, formatter: self.formatter)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .focused($isFocused)
                            
                            Text("\(self.viewModel.unit)")
                        }
                        
                        HStack {
                            Text("Bench")
                            
                            Spacer()
                            
                            TextField("", value: $viewModel.benchMax, formatter: self.formatter)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .focused($isFocused)
                            
                            Text("\(self.viewModel.unit)")
                        }
                        
                        HStack {
                            Text("OHP")
                            
                            Spacer()
                            
                            TextField("", value: $viewModel.ohpMax, formatter: self.formatter)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .focused($isFocused)
                            
                            Text("\(self.viewModel.unit)")
                        }
                        
                        HStack {
                            Text("Traning Max")
                            
                            Spacer()
                            
                            TextField("", value: $viewModel.trainingMax, formatter: self.formatter)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .focused($isFocused)
                            
                            Text("%")
                        }
                    }
                }
                .onSubmit {
                    print("Done")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        self.isFocused = false
                    }
                    .foregroundStyle(.primaryBrand)
                }
            }
        }
        .onAppear {
            self.formatter.numberStyle = .decimal
        }
    }
}

#Preview {
    SettingsView()
}
