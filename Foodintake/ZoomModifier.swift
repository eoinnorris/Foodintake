//
//  ZoomModifier.swift
//  Foodintake
//
//  Created by eoinkortext on 10/09/2023.
//

import SwiftUI

import SwiftUI

struct ZoomOutModifier: ViewModifier {
    @Binding var show: Bool
    
    func body(content: Content) -> some View {
        Group {
            if show {
                content
                    .scaleEffect(show ? 1 : 0.01) // Small value instead of 0 to trigger the animation
                    .opacity(show ? 1 : 0)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 0.3)) {
                            show = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            show = false
                        }
                    }
                    .transition(.asymmetric(insertion: .identity, removal: .scale))
            }
        }
    }
}

extension View {
    func zoomOut(when show: Binding<Bool>) -> some View {
        self.modifier(ZoomOutModifier(show: show))
    }
}

