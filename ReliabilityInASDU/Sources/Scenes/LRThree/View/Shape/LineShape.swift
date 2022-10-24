//
//  LineShape.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 19.10.2022.
//

import SwiftUI

struct LineShape: Shape {

    var yValues: [Double]
    var scaleFactor: Double

    func path(in rect: CGRect) -> Path {
        let xIncrement = (rect.width / (CGFloat(yValues.count)))
        var xValue = xIncrement * 0.5
        var path = Path()
        var startValue = yValues[0]

        path.move(to: CGPoint(x: xValue,
                              y: (rect.height - (yValues[0] * scaleFactor))))

        for i in 0..<yValues.count {
            xValue += xIncrement
            var point = CGPoint()

            if startValue == yValues[i] {
                point = CGPoint(x: xValue,
                                y: (rect.height - (yValues[i] * scaleFactor)))
            } else if startValue != yValues[i] {
                point = CGPoint(x: xValue - xIncrement,
                                y: (rect.height - (yValues[i-1] * scaleFactor)))
                path.addLine(to: point)

                point = CGPoint(x: xValue - xIncrement,
                                y: (rect.height - (yValues[i] * scaleFactor)))
            }

            startValue = yValues[i]
            path.addLine(to: point)
        }

        return path
    }
}
