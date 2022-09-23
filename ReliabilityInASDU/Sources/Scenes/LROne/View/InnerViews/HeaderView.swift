//
//  HeaderView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 23.09.2022.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 5, height: 0)
            HStack(spacing: 50) {
                Text("Виды деятельности")
                Text("Интенсивность ошибок")
                Text("Число выполненых операций")
                Text("Среднее время выполнения операции")
            }
            Rectangle()
                .frame(width: 5, height: 0)
        }
        .foregroundColor(.white)
        .font(.title2)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
