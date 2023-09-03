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
    @StateObject var slider:CustomSliderViewModel
    
    internal init(mealType: MealType) {
        self.mealType = mealType
        self._slider = StateObject(wrappedValue: CustomSliderViewModel(start: Double(mealType.min), end: Double(mealType.max)))
    }
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("\(mealType.capitalisedName) max: \(Int(slider.highHandle.currentValue))")
                    Text("\(mealType.capitalisedName) min: \(Int(slider.lowHandle.currentValue))")
                }.padding(.bottom, 5)
                
                SliderView(slider: slider)
            }
        }.onAppear{
            value = Double(mealType.min)
        }
    }
}


//struct HeaderView: View {
//
//
//}

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let selectedDay:Day
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MealType.name, ascending: true)],
        animation: .none)
    
    private var mealTypes: FetchedResults<MealType>
    
    private var dayMealTypes: [MealType] {
        let daysArray = Array(mealTypes)
        return daysArray.filter {$0.day == selectedDay}
    }
    
    var selectedDayString: String {
        guard let date = selectedDay.date else {
            return "Today"
        }
        
        return date.dayNameAndDate
    }
    
    @ViewBuilder
    var header: some View {
        VStack {
            HStack {
                Text("Limits for:")
                    .padding(.trailing, 5)
                Text(selectedDayString)

            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                header
                ForEach(dayMealTypes, id: \.self) { type in
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


