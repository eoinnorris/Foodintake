//
//  ButtonStyles.swift
//  Foodintake
//
//  Created by eoinkortext on 31/08/2023.
//

import SwiftUI

struct CounterButtonStyle: ButtonStyle {
    // Large Purple Button, used in Auth and Terms flows
    func makeBody(configuration: Configuration) -> some View {
        CounterButtonView(configuration: configuration)
    }
    
    struct CounterButtonView: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool

        
        var body: some View {
            configuration.label
                .font(.title3)
                .frame(width: UILayout.dailyButtonSize, height: UILayout.dailyButtonSize)
                .foregroundColor(backgroundColor())
        }
        
        func backgroundColor() -> Color {
            
            if isEnabled {
                return Color.orange
            }
            
            return Color.gray.opacity(0.8)
            
        }
    }
}
