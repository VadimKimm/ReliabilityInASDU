//
//  MainView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 30.11.2022.
//

import SwiftUI

struct MainView: View {

    @State var selectedView = 0

    var body: some View {
        if selectedView == 0 {
            VStack {
                Text("МОНИТОРИНГ НАДЕЖНОСТИ В АСДУ")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 100)

                //Buttons
                HStack {
                    Button {
                        selectedView = 1
                    } label: {
                        Text("ОЦЕНКА НАДЕЖНОСТИ БЕЗОШИБОЧНОГО ВЫПОЛНЕНИЯ ОПЕРАТОРОМ ПОСТАВЛЕННЫХ ЕМУ ЗАДАЧ")
                            .frame(width: 300, height: 80)
                            .lineLimit(3)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(BlueButtonStyle())

                    Button {
                        selectedView = 2
                        StashController.shared.deleteAllData(entity: "SystemSchemeItem")
                    } label: {
                        Text("НАДЕЖНОСТЬ ТЕХНОЛОГИЧЕСКОГО ОБОРУДОВАНИЯ. ПОСТРОЕНИЕ ПЛАНА ЗАМЕНЫ ОБОРУДОВАНИЯ")
                            .frame(width: 300, height: 80)
                            .lineLimit(3)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(BlueButtonStyle())

                    Button {
                        selectedView = 3
                    } label: {
                        Text("РАСЧЕТ НАДЕЖНОСТИ ПО")
                            .frame(width: 300, height: 80)
                            .lineLimit(3)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(BlueButtonStyle())
                }
            }
            .frame(minWidth: 1000, minHeight: 600)
            .navigationTitle("МОНИТОРИНГ НАДЕЖНОСТИ В АСДУ")
            .padding(.horizontal, 40)
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    Button {
                        
                    } label: {
                        Image(systemName: "questionmark.circle").imageScale(.large)
                    }
                }
            }
            .background(Color.teal.grayscale(0.33))
        } else if selectedView == 1 {
            ContentViewLROne(selectedView: $selectedView)
                .background(Color.gray)
        } else if selectedView == 2 {
            ContentViewLRTwo(selectedView: $selectedView)
                .background(Color.gray)
        } else if selectedView == 3 {
            ContentViewLRFour(selectedView: $selectedView)
                .background(Color.gray)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
