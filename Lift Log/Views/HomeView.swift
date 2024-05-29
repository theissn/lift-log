//
//  HomeView.swift
//  Lift Log
//
//  Created by t4 on 17/05/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = WorkoutViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Lift Log")
                    .font(.system(size: 26, design: .monospaced))
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                
                Text("Week")
                    .font(.system(size: 18, design: .monospaced))
                    .padding(.horizontal)
                
                Picker("Week", selection: self.$viewModel.week) {
                    ForEach(1..<5) { week in
                        Text("\(week)").tag(week)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom)
                
                ForEach(LiftType.allCases.filter({ $0 != .accessory }), id: \.rawValue) { lift in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(lift.rawValue)")
                                    .font(.system(size: 16, design: .monospaced))
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text(viewModel.getTopSet(lift: lift))
                                    .font(.system(size: 14, design: .monospaced))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray4))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
                
                Spacer()
            }
            .onAppear {
            }
        }
    }
}

#Preview {
    HomeView()
}
