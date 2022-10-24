//
//  KeyView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 19.10.2022.
//

import SwiftUI

struct KeyView: View {

    let keys: [String]

    var body: some View {
        HStack {
            ForEach(keys.indices) { i in
                HStack(spacing:0) {
                    Image(systemName: "square.fill")
                        .foregroundColor(CustomColors.colors[i])
                    Text("\(keys[i])")
                        .foregroundColor(.black)
                }
            }
        }
    }
}
