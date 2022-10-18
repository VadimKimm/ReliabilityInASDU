//
//  SchemeView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import SwiftUI

struct SchemeView: View {

    @Binding var selection: SchemeBlockType
    @Binding var block: [SchemeElement]

    var action: () -> Void

    var body: some View {
        VStack {
            Picker("Выбор подсистемы", selection: $selection) {
                ForEach(SchemeBlockType.allCases) { type in
                    Text(type.rawValue)
                }
            }
            .frame(width: 200)
            .padding(.top, 8)

            if selection == .firstType {
                SchemeBlockView(imageName: "blockFirstType", action: action)
            } else if selection == .secondType {
                SchemeBlockView(imageName: "blockSecondType", action: action)
            } else if selection == .thirdType {
                SchemeBlockView(imageName: "blockThirdType", action: action)
            } else if selection == .fourthType {
                SchemeBlockView(imageName: "blockFourthType", action: action)
            } else {
                SchemeBlockView(imageName: "blockEmpty", action: action)
            }
        }
        .onChange(of: selection, perform: { newValue in
            block = newValue.block
        })
        .border(.white)
    }
}
