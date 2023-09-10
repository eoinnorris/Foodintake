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
    
}

enum PointsType {
    case total
    case penaltyAboveCriteria
    case penaltyBelowCriteria
    case awardAboveCriteria
    case awardBelowCriteria
}

class PenaltiesViewModel: ObservableObject {
    var total: Int = 10
    var negativeAbove: PenaltyValueType = .init(value: 10, direction: .negative)
    var positiveAbove: PenaltyValueType = .init(value: 0, direction: .positive)
    var negativeBelow: PenaltyValueType = .init(value: 5, direction: .negative)
    var positiveBelow: PenaltyValueType = .init(value: 5, direction: .negative)

 
    
    func validate() -> Bool {
        true
    }
    
    func defaults(forType type:PointsType) -> Int {
        switch type {
        case .total:
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
        case .total:
            total = intValue
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
    
    var body: some View {
        Text("Penalties for bread")
                .font(.title)
        Text("Max units is 2 units")
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

struct PenaltiesView: View {
    @StateObject private var penaltiesViewModel = PenaltiesViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            PenaltyHeader()
            
            Form {
                Section(header: Text("Points awarded on meeting criteria")) {
                    PenaltySettingItem(penaltiesViewModel: penaltiesViewModel, pointsType: .total)
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
        }
    }
}

struct PenaltiesView_Previews: PreviewProvider {
    static var previews: some View {
        PenaltiesView()
    }
}
