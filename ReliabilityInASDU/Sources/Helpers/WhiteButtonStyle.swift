//
//  WhiteButtonStyle.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 02.12.2022.
//

import SwiftUI

struct WhiteButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.white : Color.blue)
            .background(configuration.isPressed ? Color.blue : Color.white)
            .cornerRadius(6.0)
            .padding()
    }
}
