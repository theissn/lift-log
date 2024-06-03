//
//  TextEditorWithLabel.swift
//  Lift Log
//
//  Created by theis on 03/06/2024.
//

import SwiftUI

struct TextEditorWithLabel: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var text: String
    
    var label: String?
    var isDisabled = false
    
    var body: some View {
        VStack {
            if let label = self.label {
                Text(label)
                    .font(.system(size: 16, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            TextEditor(text: $text)
                .font(.system(size: 16, design: .monospaced))
                .padding(8)
                .frame(minHeight: 150, maxHeight: 300)
                .scrollContentBackground(.hidden)
                .background(colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray6))
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.5 : 1)
        }
    }
}


#Preview {
    @State var text = "asd"
    
    return TextEditorWithLabel(text: $text, label: "Username")
}
