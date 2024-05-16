//
//  ContentView.swift
//  Lift Log
//
//  Created by t4 on 16/05/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showWorkoutSheet = false
    
    var body: some View {
        VStack {
            Button("Start") {
                showWorkoutSheet.toggle()
            }
        }
        .sheet(isPresented: $showWorkoutSheet, content: {
            WorkoutView()
        })
    }
}

#Preview {
    ContentView()
}
