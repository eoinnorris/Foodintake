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

/*struct ContentView: View {
 @State private var showContent = true
 
 var body: some View {
 VStack(spacing: 20) {
 Button("Toggle Content") {
 showContent.toggle()
 }
 
 Rectangle()
 .fill(Color.blue)
 .frame(width: 100, height: 100)
 .zoomOut(when: $showContent)
 }
 }
 }
 
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }
*/
