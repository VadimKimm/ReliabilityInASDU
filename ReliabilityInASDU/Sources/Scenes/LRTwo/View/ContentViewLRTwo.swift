//
//  ContentViewLRTwo.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import SwiftUI

struct ContentViewLRTwo: View {

    @ObservedObject var schemeModel = SchemeObservable()

    @State private var firstSelectedBlock: SchemeBlockType = .firstType
    @State private var secondSelectedBlock: SchemeBlockType = .secondType
    @State private var thirdSelectedBlock: SchemeBlockType = .thirdType

    @State private var isFirstBlockEditButtonPressed = false
    @State private var isSecondBlockEditButtonPressed = false
    @State private var isThirdBlockEditButtonPressed = false

    @State private var targetReliabilityFactor = "0.95"

    init() {
        let theNumber = "1e-1"
        print(theNumber)

        let doubleValue = Double(theNumber)
        print(String(format: "%.4f", doubleValue ?? 0))
        print("\n\n------------------------------------")
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
            }
            .frame(width: 80)
            .padding(.top, 40)

            VStack {
                //Верхний стэк
                VStack {
                    Text("Схема")
                        .font(.title)
                        .bold()

                    HStack(alignment: .top, spacing: 10) {
                        SchemeView(
                            selection: $firstSelectedBlock,
                            block: $schemeModel.firstBlock,
                            action: { isFirstBlockEditButtonPressed = true }
                        )
                        .sheet(isPresented: $isFirstBlockEditButtonPressed) {
                            SchemeEditBlockView(isVisible: $isFirstBlockEditButtonPressed,
                                                block: $schemeModel.firstBlock)
                        }

                        SchemeView(
                            selection: $secondSelectedBlock,
                            block: $schemeModel.secondBlock,
                            action: { isSecondBlockEditButtonPressed = true }
                        )
                        .sheet(isPresented: $isSecondBlockEditButtonPressed) {
                            SchemeEditBlockView(isVisible: $isSecondBlockEditButtonPressed,
                                                block: $schemeModel.secondBlock)
                        }
                        
                        SchemeView(
                            selection: $thirdSelectedBlock,
                            block: $schemeModel.thirdBlock,
                            action: { isThirdBlockEditButtonPressed = true }
                        )
                        .sheet(isPresented: $isThirdBlockEditButtonPressed) {
                            SchemeEditBlockView(isVisible: $isThirdBlockEditButtonPressed,
                                                block: $schemeModel.thirdBlock)
                        }
                    }
                    .frame(width: 730, height: 200)
                    .border(.white)
                }

                //Средний стэк
                VStack {
                    Text("Компоненты")
                        .font(.title)
                        .bold()

                    HStack(alignment: .top, spacing: 0) {
                        SchemeComponentsView(block: $schemeModel.firstBlock)
                        SchemeComponentsView(block: $schemeModel.secondBlock)
                        SchemeComponentsView(block: $schemeModel.thirdBlock)
                    }
                    .frame(width: 730, height: 200)
                    .border(.white)
                }

                //Нижний стэк
                VStack {
                    HStack {
                        Text("Критич. уровень надежности")
                            .font(.title3)
                            .padding(.horizontal, 10)
                        TextField("", text: $targetReliabilityFactor)
                            .frame(width: 60)
                    }
                }
            }
            .frame(width: 750)

            // TODO: тут должны быть кнопки для сохранения/импорта в базу данных
            VStack(alignment: .leading) {

            }
            .frame(width: 150)
            .padding(.top, 40)
        }
        .frame(minWidth: 1000, minHeight: 600)
    }
}

struct ContentViewLRTwo_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewLRTwo()
    }
}
