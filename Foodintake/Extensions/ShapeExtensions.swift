//
//  ShapeExtensions.swift
//  Foodintake
//
//  Created by eoinkortext on 04/09/2023.
//

import SwiftUI

struct PointedRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Top point
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        
        // Top right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.25))
        
        // Bottom right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.75))
        
        // Bottom point
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        // Bottom left corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.75))
        
        // Top left corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.25))
        
        // Close the shape
        path.closeSubpath()
        
        return path
    }
}
