//
//  EditButtonView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 29.11.2022.
//

import SwiftUI

struct EditButtonView: View {

    @Binding var isVisible: Bool

    var body: some View {
        Button("Редактировать") {
            isVisible = true
        }
    }
}

struct EditButtonView_Previews: PreviewProvider {
    static var previews: some View {
        EditButtonView(isVisible: .constant(true))
    }
}
