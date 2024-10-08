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
                    .foregroundStyle(.primaryBrand)
                    .font(.system(size: 26, design: .monospaced))
                    .fontWeight(.black)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                    .padding(.top, 16)
                
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
                    Button {
                        viewModel.lift = lift
                        viewModel.startWorkout(lift: lift)
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
//                                ZStack {
//                                    Circle()
//                                        .stroke(lineWidth: 1)
//                                        .foregroundStyle(.primaryBrand)
//                                        .frame(width: 32, height: 32)
//                                    
//                                    Text("\(lift.rawValue[0])")
//                                        .foregroundStyle(.primaryBrand)
//                                        .font(.system(size: 16, design: .monospaced))
//                                        .fontWeight(.bold)
//
//                                }
//                                .padding(.trailing, 4)
                                
                                VStack(alignment: .leading) {
                                    Text("\(lift.rawValue)")
                                        .font(.system(size: 16, design: .monospaced))
                                        .foregroundColor(.primary)
                                        .bold()
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Text(viewModel.getTopSet(lift: lift))
                                        .font(.system(size: 14, design: .monospaced))
                                        .foregroundColor(.primary)
                                        .bold()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray4))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
                
                Spacer()
            }
            .sheet(isPresented: $viewModel.showWorkoutSheet) {
                WorkoutView(viewModel: self.viewModel)
                    .interactiveDismissDisabled()
            }
        }
    }
}

#Preview {
    HomeView()
}
