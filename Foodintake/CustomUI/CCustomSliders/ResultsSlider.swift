//
//  ResultsSlider.swift
//  Foodintake
//
//  Created by eoinkortext on 10/09/2023.
//

import SwiftUI
import Combine

//SliderValue to restrict double range: 0.0 to 1.0
@propertyWrapper
struct ResultsSliderValue {
    var value: Double
    
    init(wrappedValue: Double) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Double {
        get { value }
        set { value = min(max(0.0, newValue), 1.0) }
    }
}

class ResultsSliderHandle: ObservableObject {
    
    //Slider Size
    let sliderWidth: CGFloat
    let sliderHeight: CGFloat
    
    //Slider Range
    let sliderValueStart: Double
    let sliderValueRange: Double
    
    //Slider Handle
    var width: CGFloat = 8
    var height: CGFloat = 20
    
    var startLocation: CGPoint
    
    //Current Value
    @Published var currentPercentage: ResultsSliderValue
    
    //Slider Button Location
    @Published var onDrag: Bool
    @Published var currentLocation: CGPoint
    
    init(sliderWidth: CGFloat,
         sliderHeight: CGFloat,
         sliderValueStart: Double,
         sliderValueEnd: Double,
         startPercentage: ResultsSliderValue) {
        self.sliderWidth = sliderWidth
        self.sliderHeight = sliderHeight
        
        self.sliderValueStart = sliderValueStart
        self.sliderValueRange = sliderValueEnd - sliderValueStart
        
        let startLocation = CGPoint(x: (CGFloat(startPercentage.wrappedValue)/1.0)*sliderWidth, y: sliderHeight/2)
        
        self.startLocation = startLocation
        self.currentLocation = startLocation
        self.currentPercentage = startPercentage
        
        self.onDrag = false
    }
    
    lazy var sliderDragGesture: _EndedGesture<_ChangedGesture<DragGesture>>  = DragGesture()
    .onChanged { value in
        self.onDrag = true
        
        let dragLocation = value.location
        
        //Restrict possible drag area
        self.restrictSliderBtnLocation(dragLocation)
        
        //Get current value
        self.currentPercentage.wrappedValue = Double(self.currentLocation.x / self.sliderWidth)
        
    }.onEnded { _ in
        self.onDrag = false
    }
    
    private func restrictSliderBtnLocation(_ dragLocation: CGPoint) {
        //On Slider Width
        if dragLocation.x > CGPoint.zero.x && dragLocation.x < sliderWidth {
            calcSliderBtnLocation(dragLocation)
        }
    }
    
    private func calcSliderBtnLocation(_ dragLocation: CGPoint) {
        if dragLocation.y != sliderHeight/2 {
            currentLocation = CGPoint(x: dragLocation.x, y: sliderHeight/2)
        } else {
            currentLocation = dragLocation
        }
    }
    
    //Current Value
    var currentValue: Double {
        return sliderValueStart + currentPercentage.wrappedValue * sliderValueRange
    }
    
    //Current Value
    var intCurrentValue: Int {
        return Int(sliderValueStart + currentPercentage.wrappedValue * sliderValueRange)
    }
}

class ResultsSliderViewModel: ObservableObject {
    
    //Slider Size
    let width: CGFloat = 280
    let height: CGFloat = 2
    let radius: CGFloat = 5
    
    //Slider value range from valueStart to valueEnd
    let valueStart: Double
    let valueEnd: Double
    
    //Slider Handle
    @Published var highHandle: ResultsSliderHandle
    @Published var midHandle:  ResultsSliderHandle
    @Published var lowHandle:  ResultsSliderHandle
    
    //Handle start percentage (also for starting point)
    @ResultsSliderValue var highHandleStartPercentage = 1.0
    @ResultsSliderValue var midHandleStartPercentage = 0.5
    @ResultsSliderValue var lowHandleStartPercentage = 0.0
    
    
    var anyCancellableHigh: AnyCancellable?
    var anyCancellableLow: AnyCancellable?
    
    init(start: Double, end: Double) {
        valueStart = start
        valueEnd = end
        
        highHandle = ResultsSliderHandle(sliderWidth: width,
                                  sliderHeight: height,
                                  sliderValueStart: valueStart,
                                  sliderValueEnd: valueEnd,
                                  startPercentage: _highHandleStartPercentage
        )
        
        midHandle = ResultsSliderHandle(sliderWidth: width,
                                 sliderHeight: height,
                                 sliderValueStart: valueStart,
                                 sliderValueEnd: valueEnd,
                                 startPercentage: _midHandleStartPercentage
        )
        
        lowHandle = ResultsSliderHandle(sliderWidth: width,
                                 sliderHeight: height,
                                 sliderValueStart: valueStart,
                                 sliderValueEnd: valueEnd,
                                 startPercentage: _lowHandleStartPercentage
        )
        
        anyCancellableHigh = highHandle.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
        anyCancellableLow = lowHandle.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
        anyCancellableLow = midHandle.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
    }
    
    //Percentages between high and low handle
    var percentagesBetween: String {
        return String(format: "%.2f", highHandle.currentPercentage.wrappedValue - lowHandle.currentPercentage.wrappedValue)
    }
    
    //Value between high and low handle
    var valueBetween: String {
        return String(format: "%.2f", highHandle.currentValue - lowHandle.currentValue)
    }
}



struct ResultsSliderView: View {
    @ObservedObject var slider: ResultsSliderViewModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: slider.height)
            .fill(Color.gray.opacity(0.2))
            .frame(width: slider.width, height: slider.height)
            .overlay(
                ZStack {
                    //Path between both handles
                    ResultsSliderPathBetweenView(slider: slider)
                    
                    //Low Handle
                    ResultsSliderHandleView(handle: slider.lowHandle)
                    //                        .highPriorityGesture(slider.lowHandle.sliderDragGesture)
                    
                    //mid Handle
                    ResultsMidSliderHandleView(handle: slider.midHandle)
                        .highPriorityGesture(slider.midHandle.sliderDragGesture)
                    
                }
            )
    }
}

struct ResultsMidSliderHandleView: View {
    @ObservedObject var handle: ResultsSliderHandle
    
    var body: some View {
        PointedRectangle()
            .frame(width: handle.width, height: handle.height)
            .foregroundColor(.blue.opacity(0.8))
            .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 0)
            .scaleEffect(handle.onDrag ? 1.3 : 1)
            .position(x: handle.currentLocation.x, y: handle.currentLocation.y)
    }
}

struct ResultsSliderHandleView: View {
    @ObservedObject var handle: ResultsSliderHandle
    
    var body: some View {
        Rectangle()
            .frame(width: handle.width, height: handle.height)
            .foregroundColor(.black.opacity(0.8))
            .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 0)
            .scaleEffect(handle.onDrag ? 1.3 : 1)
            .position(x: handle.currentLocation.x, y: handle.currentLocation.y)
    }
}

struct ResultsSliderPathBetweenView: View {
    @ObservedObject var slider: ResultsSliderViewModel
    
    var body: some View {
        Path { path in
            path.move(to: slider.lowHandle.currentLocation)
            path.addLine(to: slider.highHandle.currentLocation)
        }
        .stroke(Color.blue.gradient, lineWidth: slider.height)
    }
}
