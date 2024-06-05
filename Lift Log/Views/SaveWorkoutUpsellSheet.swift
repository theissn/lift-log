//
//  SaveWorkoutUpsellSheet.swift
//  Lift Log
//
//  Created by theis on 05/06/2024.
//

import SwiftUI
import StoreKit

struct SaveWorkoutUpsellSheet: View {
    @State private var timeRemaining = 12
    @State private var products: [Product] = []
    let productIds = ["lift_log_premium", "lift_log_premium_annual"]
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Unlock Your Full Potential!")
                    .foregroundStyle(.primaryBrand)
                    .font(.system(size: 20, design: .monospaced))
                    .fontWeight(.bold)
                    .padding()
                
                Text("Take your fitness journey to the next level with these premium features:")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16, design: .monospaced))
                
                    .padding()
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.primaryBrand)
                            .frame(width: 32)
                        
                        Text("Enjoy uninterrupted workouts with unlimited saves")
                            .font(.system(size: 16, design: .monospaced))
                    }
                    
                    HStack {
                        Image(systemName: "chart.xyaxis.line")
                            .foregroundColor(.primaryBrand)
                            .frame(width: 32)
                        
                        Text("Track your progress with detailed max lift history charts")
                            .font(.system(size: 16, design: .monospaced))
                    }
                    
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.primaryBrand)
                            .frame(width: 32)
                        
                        Text("Seamlessly export your data for easy sharing and analysis")
                            .font(.system(size: 16, design: .monospaced))
                        
                    }
                }
                .padding()
                
                VStack {
                    ForEach(self.products) { product in
                        Button {
                            // Don't do anything yet
                        } label: {
                            Text("\(product.displayPrice) - \(product.displayName)")
                        }
                    }

//                    if let product = subscriptionProduct {
//                        Text(product.localizedTitle)
//                        Text(product.localizedDescription)
//                        Button {
//                            purchaseSubscription(product)
//                        } label: {
//                            Text("Upgrade to Premium")
//                                .font(.system(size: 16, design: .monospaced))
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                                .padding()
//                                .background(.primaryBrand)
//                                .cornerRadius(10)
//                        }
//                    } else {
//                        Text("Loading subscription...")
//                    }

                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        VStack {
                            if timeRemaining > 0 {
                                ProgressView(value: Double(timeRemaining), total: 12)
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(width: 24, height: 24)
                                    .padding()
                            } else {
                                Button {
                                    
                                } label: {
                                    Text("Continue")
                                        .font(.system(size: 16, design: .monospaced))
                                }
                                .tint(.primaryBrand)
                            }
                        }
                    }
                }
            }
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
            .task {
                do {
                    try await self.loadProducts()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func loadProducts() async throws {
        self.products = try await Product.products(for: productIds)
        print(self.products)
    }
}

struct CircularProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 2)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .foregroundColor(.primaryBrand)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut)
        }
    }
}

#Preview {
    VStack {}
        .sheet(isPresented: .constant(true), content: {
            SaveWorkoutUpsellSheet()
        })
}
