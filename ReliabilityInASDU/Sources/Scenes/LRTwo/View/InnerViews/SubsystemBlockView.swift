//
//  SchemeBlockView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import SwiftUI

struct SubsystemBlockView: View {

    var imageName: String
    @Binding var isVisible: Bool

    var body: some View {
        VStack {
            Image(imageName)

            Button("Редактировать эелементы") {
                isVisible = true
            }
            .padding(.bottom, 8)
        }
    }
}

struct SchemeBlockView_Previews: PreviewProvider {
    static var previews: some View {
        SubsystemBlockView(imageName: "blockFirstType", isVisible: .constant(true))
    }
}
