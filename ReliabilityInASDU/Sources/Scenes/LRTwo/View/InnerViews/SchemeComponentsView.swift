//
//  SchemeComponentsView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import SwiftUI

struct SchemeComponentsView: View {

    @Binding var block: [SchemeElement]

    var body: some View {
        VStack {
            List(block) { element in
                VStack(alignment: .leading) {
                    Text(element.title)
                    Text("Дата установки: \(element.installationDate.convertToString())")
                }
            }
        }
        .border(.white)
    }
}

struct SchemeComponentsView_Previews: PreviewProvider {
    static var previews: some View {
        SchemeComponentsView(block: .constant(SchemeBlockType.thirdType.block))
    }
}
