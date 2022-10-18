//
//  SchemeBlockView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import SwiftUI

struct SchemeBlockView: View {

    var imageName: String
    var action: () -> Void

    var body: some View {
        VStack {
            Image(imageName)

            Button("Редактирование подсистемы") {
                action()
            }
            .buttonStyle(.bordered)
            .padding(.bottom, 8)
        }
    }
}

struct SchemeBlockView_Previews: PreviewProvider {
    static var previews: some View {
        SchemeBlockView(imageName: "blockFirstType", action: { print("123") })
    }
}
