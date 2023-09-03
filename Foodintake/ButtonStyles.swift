//
//  ButtonStyles.swift
//  Foodintake
//
//  Created by eoinkortext on 31/08/2023.
//

import SwiftUI

enum ButtonDirection {
    case increment
    case decrement
}

struct CounterButtonStyle: ButtonStyle {
    
    let mealType: MealType
    let buttonDirection:ButtonDirection
    // Large Purple Button, used in Auth and Terms flows
    func makeBody(configuration: Configuration) -> some View {
        CounterButtonView(configuration: configuration,
                          mealType: mealType,
                          buttonDirection: buttonDirection
        )
    }
    
    struct CounterButtonView: View {
        let configuration: ButtonStyle.Configuration
        let mealType: MealType
        let buttonDirection:ButtonDirection
        @Environment(\.isEnabled) private var isEnabled: Bool

        
        var body: some View {
            configuration.label
                .font(.title3)
                .frame(width: UILayout.dailyButtonSize, height: UILayout.dailyButtonSize)
                .foregroundColor(backgroundColor())
        }
        
        var incrementBGColor: Color {
            let nextValue = mealType.count + 1
            if nextValue > mealType.max {
                return Color.red
            }
            
            return Color.green
            
        }
        
        var decrementBGColor: Color {
            let nextValue = mealType.count - 1
            if nextValue > mealType.max {
                return Color.red
            }
            
            return Color.green
        }
        
        func backgroundColor() -> Color {
            
            if isEnabled {
                if buttonDirection == .increment {
                    return incrementBGColor
                } else if buttonDirection == .decrement {
                    return decrementBGColor
                }
            }
            return Color.gray.opacity(0.8)
            
        }
    }
}
