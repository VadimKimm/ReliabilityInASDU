//
//  BlueButtonStyle.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 30.11.2022.
//

import SwiftUI

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.blue : Color.white)
            .background(configuration.isPressed ? Color.gray : Color.blue)
            .cornerRadius(6.0)
            .padding()
    }
}
