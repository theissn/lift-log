//
//  HomeView.swift
//  Lift Log
//
//  Created by t4 on 17/05/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var workoutViewModel = WorkoutViewModel()
    
    var body: some View {
        VStack {
            Picker(selection: <#T##Binding<Hashable>#>, content: <#T##() -> View#>, label: <#T##() -> View#>)
        }
    }
}

#Preview {
    HomeView()
}
