//
//  SchemeView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import SwiftUI

struct SubsystemView: View {

    @Binding var selectedItem: SubsystemBlock
    @Binding var isVisible: Bool

    var body: some View {
        VStack {
            Picker("Изменить тип", selection: $selectedItem.type) {
                ForEach(SubsystemBlockType.allCases) { type in
                    Text(type.rawValue)
                }
            }
            .frame(width: 200)
            .padding(.top, 8)

            if selectedItem.type == .firstType {
                SubsystemBlockView(imageName: "blockFirstType", isVisible: $isVisible)
            } else if selectedItem.type == .secondType {
                SubsystemBlockView(imageName: "blockSecondType", isVisible: $isVisible)
            } else if selectedItem.type == .thirdType {
                SubsystemBlockView(imageName: "blockThirdType", isVisible: $isVisible)
            } else if selectedItem.type == .fourthType {
                SubsystemBlockView(imageName: "blockFourthType", isVisible: $isVisible)
            } else {
                SubsystemBlockView(imageName: "blockEmpty", isVisible: $isVisible)
            }
        }
    }
}
