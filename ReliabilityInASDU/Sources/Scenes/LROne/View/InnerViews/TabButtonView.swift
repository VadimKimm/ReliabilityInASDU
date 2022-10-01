//
//  TabButtonView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 16.09.2022.
//

import SwiftUI

struct TabButtonView: View {

    let image: String
    let title: String
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 7) {
                Image(systemName: image)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)

                Text(title)
                    .fontWeight(.semibold)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
            .frame(width: 70)
            .background(Color.primary.opacity(0.15))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 70)
    }
}

struct TabButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TabButtonView(image: "house", title: "123", action: { print("123") })
    }
}
