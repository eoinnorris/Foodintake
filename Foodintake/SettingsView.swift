//
//  SettingsView.swift
//  Foodintake
//
//  Created by eoinkortext on 30/08/2023.
//

import SwiftUI

class SettingsViewController: ObservableObject {
    
}

struct SliderSettingsView: View {
    
    let mealType: MealType
    @State private var value: Double = 0.0
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("\(mealType.capitalisedName) allowance: \(Int(value))")
                }.padding(.bottom, 5)
                
                Slider(value: $value, in: Double(mealType.min)...Double(mealType.max), step:1)
                    .scaleEffect(0.8)
            }
        }.onAppear{
            value = Double(mealType.min)
        }
    }
}


struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MealType.name, ascending: true)],
        animation: .none)
    
    private var mealTypes: FetchedResults<MealType>
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ForEach(mealTypes, id: \.self) { type in
                    SliderSettingsView(mealType:type)
                }
                Spacer()
            } .toolbar {
                /// Cancel  button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}


