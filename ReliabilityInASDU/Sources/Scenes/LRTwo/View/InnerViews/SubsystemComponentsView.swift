//
//  SubsystemComponentsView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import SwiftUI

struct SubsystemComponentsView: View {

    @Binding var subsystem: SubsystemBlock

    var body: some View {
        VStack {
            List(subsystem.elements) { element in
                VStack(alignment: .leading) {
                    Text(element.title)
                    Text("Дата установки: \(element.installationDate.convertToString())")
                }
            }
        }
        .border(.white)
    }
}

//struct SchemeComponentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubsystemComponentsView(subsystem: .constant(SubsystemBlock(type: .firstType)))
//    }
//}
