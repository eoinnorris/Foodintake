//
//  PenaltiesView.swift
//  Foodintake
//
//  Created by eoinkortext on 10/09/2023.
//

import SwiftUI

class PenaltiesViewModel: ObservableObject {
    var total: Int = 10
    var negative: Int = 5
    var positive: Int = 0
    
    enum PointsType {
        case total
        case negative
        case positive
    }
    
    func validate() -> Bool {
        true
    }
    
    func defaults(forType type:PointsType) -> Int {
        switch type {
        case .total:
            return 10
        case .negative:
            return 5
        case .positive:
            return 0
        }
    }
    
    func addToPoints(type:PointsType, value:String) {
        let intValue = Int(value) ?? defaults(forType: type)
        switch type {
            
        case .total:
            total = intValue
        case .negative:
            negative = intValue
        case .positive:
            positive = intValue
        }
    }
}

struct PenaltyHeader: View {
    
    var body: some View {
        Text("Penalties for bread")
                .font(.title)
        Text("Max criteria is 2 units")

    }
}

struct TotalPenaltyView: View {
    @ObservedObject var penaltiesViewModel:PenaltiesViewModel
    @State private var totalPoints = "10"

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
                    penaltiesViewModel.addToPoints(type: .total, value: modifiedText)
                    
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
                    TotalPenaltyView(penaltiesViewModel: penaltiesViewModel)
                }
                Section(header: Text("Points deducted for extra bread")) {
                    TotalPenaltyView(penaltiesViewModel: penaltiesViewModel)
                }
                Section(header: Text("Points deducted for not reaching target")) {
                    TotalPenaltyView(penaltiesViewModel: penaltiesViewModel)
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
