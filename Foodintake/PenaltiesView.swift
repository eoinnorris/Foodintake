//
//  PenaltiesView.swift
//  Foodintake
//
//  Created by eoinkortext on 10/09/2023.
//

import SwiftUI

struct PenaltyValueType {
    
    enum Direction {
        case positive
        case negative
    }
    
    let value:Int
    let direction:Direction
    
    func hasValue() -> Bool {
        value > 0
    }
}

enum PointsType {
    case reward
    case penaltyAboveCriteria
    case penaltyBelowCriteria
    case awardAboveCriteria
    case awardBelowCriteria
}

class PenaltiesViewModel: ObservableObject {
    var reward: Int = 10
    var negativeAbove: PenaltyValueType = .init(value: 8, direction: .negative)
    var positiveAbove: PenaltyValueType = .init(value: 0, direction: .positive)
    var negativeBelow: PenaltyValueType = .init(value: 0, direction: .negative)
    var positiveBelow: PenaltyValueType = .init(value: 0, direction: .negative)

    
    func validate() -> Bool {
        true
    }
    
    //todo - either positive or negative up and down
    func calculateScore(forDifference difference:Int) -> Int {
        let total = reward
        var result = 0
        if difference == 0 { return total}
        if difference < 0 {
            if negativeBelow.hasValue() {
                result = total - ( negativeBelow.value * abs(difference))
            } else if positiveBelow.hasValue() {
                result = total + ( positiveBelow.value * abs(difference))
            }
        }
        
        if difference > 0 {
            if negativeAbove.hasValue() {
                result = total - ( negativeAbove.value * abs(difference))
            } else if positiveAbove.hasValue() {
                result = total + ( positiveAbove.value * abs(difference))
            }
        }
        
        return result
    }
    
    func defaults(forType type:PointsType) -> Int {
        switch type {
        case .reward:
            return 10
        case .penaltyAboveCriteria:
            return 5
        case .penaltyBelowCriteria:
            return 0
        case .awardAboveCriteria:
            return 0
        case .awardBelowCriteria:
            return 0
        }
    }
    
    func addToPoints(type:PointsType,
                     value:String) {
        let intValue = Int(value) ?? defaults(forType: type)
        switch type {
        case .reward:
            reward = intValue
        case .penaltyAboveCriteria:
            negativeAbove = .init(value: intValue, direction: .positive)
        case .penaltyBelowCriteria:
            negativeBelow = .init(value: intValue, direction: .negative)
        case .awardAboveCriteria:
            positiveAbove = .init(value: intValue, direction: .positive)
        case .awardBelowCriteria:
            positiveBelow = .init(value: intValue, direction: .negative)
        }
    }
}

struct PenaltyHeader: View {
    let mealType:MealTypeType

    var body: some View {
        VStack {
            Text("Penalties for \(mealType.name ?? "")")
                .font(.title)
            Text("Max units is 2 units")
        }
    }
}

struct PenaltySettingItem: View {
    @ObservedObject var penaltiesViewModel:PenaltiesViewModel
    @State private var totalPoints = "10"
    let pointsType:PointsType

    var body: some View {
        HStack {
            Text("Points")
            Spacer()
            TextField("Enter Points", text: $totalPoints)
                .frame(width: 25)
                .border(.gray)
                .keyboardType(.numberPad)
                .onChange(of: totalPoints) { newValue in
                    // Remove non-numeric characters
                    let modifiedText = newValue.filter { "0123456789".contains($0) }
                    penaltiesViewModel.addToPoints(type: pointsType, value: modifiedText)
                    
                }
            
        }
    }
}

struct VisualResultsView: View {
    
    @StateObject var sliderViewModel: ResultsSliderViewModel = .init(start: 0.0, end: 10.0)
    @ObservedObject var penaltiesViewModel:PenaltiesViewModel
    let mealType:MealTypeType

    private var units: String {
        withAnimation {
            "\(sliderViewModel.midHandle.intCurrentValue)"
        }
    }
    
    // get rid of midHandle
    var score: Int {
        let difference =  sliderViewModel.midHandle.intCurrentValue - Int(mealType.daily)
        return penaltiesViewModel.calculateScore(forDifference: difference)
    }

    var body: some View {
        VStack {
            Text("Visual Results")
                .font(.callout)
            HStack {
                Text("Consumed \(units) units of \(mealType.name ?? "")")
                    .font(.caption)
                    .padding(.top, 2)
            }
            ResultsSliderView(slider: sliderViewModel)
                .padding(.top, 10)
            HStack {
                Text("Score: \(score)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top, 30)
                Spacer()
            }.padding(.leading, 70)
     
        }
    }
}

struct PenaltiesView: View {
    @StateObject private var penaltiesViewModel = PenaltiesViewModel()
    let mealType:MealTypeType
    
    var body: some View {
        VStack(alignment: .center) {
            PenaltyHeader(mealType: mealType)
                .padding()
            Form{
                Section(header: Text("Points awarded on meeting criteria")) {
                    PenaltySettingItem(penaltiesViewModel: penaltiesViewModel, pointsType: .reward)
                }
                Section(header: Text("Points deducted for extra bread")) {
                    PenaltySettingItem(penaltiesViewModel: penaltiesViewModel, pointsType: .penaltyAboveCriteria )
                }
                Section(header: Text("Points awarded for extra bread")) {
                    PenaltySettingItem(penaltiesViewModel: penaltiesViewModel, pointsType: .awardAboveCriteria )
                }
                Section(header: Text("Points deducted for not reaching target")) {
                    PenaltySettingItem(penaltiesViewModel: penaltiesViewModel, pointsType: .penaltyBelowCriteria)
                }
                Section(header: Text("Points awarded for eating less bread")) {
                    PenaltySettingItem(penaltiesViewModel: penaltiesViewModel, pointsType: .awardBelowCriteria )
                }
            }
            .frame(height: UIScreen.screenHeight * 0.6)
            VisualResultsView(penaltiesViewModel: penaltiesViewModel,
                              mealType: mealType)
                .padding(.top, 5)
            Spacer()
        }
    }
}

struct PenaltiesView_Previews: PreviewProvider {
    static var previews: some View {
        let mealType = TestMealType(daily: 2, max: 6, min: 0, name:"white bread",count: 0)
        PenaltiesView(mealType: mealType)
    }
}

struct TestMealType:MealTypeType {
    var daily: Int16
    var max: Int16
    var min: Int16
    var name: String?
    var count: Int16
    var time: Date?
    var day: Day?
}
