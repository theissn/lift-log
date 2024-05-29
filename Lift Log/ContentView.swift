//
//  ContentView.swift
//  Lift Log
//
//  Created by t4 on 16/05/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
        }
        .tint(.primary)
    }
}

#Preview {
    ContentView()
}
