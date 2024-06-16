//
//  PlaygroundView.swift
//  Lift Log
//
//  Created by theis on 05/06/2024.
//

import SwiftUI

struct PlaygroundView: View {
    var body: some View {
        VStack {
            Button("Delete") {
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.primaryBrand)
            .cornerRadius(10)
            .foregroundStyle(.primary)
            .padding()
        }
    }
}

#Preview {
    PlaygroundView()
}
