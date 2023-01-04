//
//  SaveView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 04.01.2023.
//

import SwiftUI

struct SaveView: View {
    @Binding var name: String
    @Binding var isVisible: Bool
    var action: () -> Void

    var body: some View {
        VStack {
            Text("Введите название")
            TextField("", text: $name)
            Button("Подтвердить") {
                action()
                isVisible.toggle()
                name = ""
            }
        }
        .padding(.all, 20)
    }
}
