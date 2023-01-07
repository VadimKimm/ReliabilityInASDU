//
//  ForecastElementReplacementView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 02.12.2022.
//

import SwiftUI

struct ForecastElementReplacementView: View {

    var subsystems: [SubsystemBlock]
    @Binding var isVisible: Bool
    @State var date = Date()
    @State var numberOfReplacements = "0"
    @State var replacementsDescription = String()

    var body: some View {
        VStack {
            Text("Укажите дату")
                .font(.title)
                .bold()

            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .frame(width: 100)

            Text("Количество замен:  \(numberOfReplacements)")

            ScrollView(.vertical, showsIndicators: false) {
                Text(replacementsDescription)
            }
            .frame(width: 220, height: 200)

            Button("Прогноз") {
                makeForecast()
            }

            Button("Сохранить в файл") {
                let text = makeStringToSave()
                FileExporter.exportPDF(text: text)
            }

            Button("Закрыть") {
                isVisible = false
            }

        }
        .frame(width: 400, height: 400)
    }
}

extension ForecastElementReplacementView {
    func makeForecast() {
        var counter = Int()
        var description = String()

        for (sysIndex, subsystem) in subsystems.enumerated() {
            for (elIndex, element) in subsystem.elements.enumerated() {
                if date > element.dateToReplacement ?? Date() {
                    counter += 1
                    description += "Подсистема №\(sysIndex + 1) - элемент №\(elIndex + 1)\n"
                }
            }
            description += "\n"
        }

        numberOfReplacements = String(counter)
        replacementsDescription = description
    }
}

// MARK: - Save to file

extension ForecastElementReplacementView {
    func makeStringToSave() -> String {
        var text = "ПЛАН ЗАМЕНЫ ОБОРУДОВАНИЯ\n\n"
        text += "К \(date.convertToExtendedString()) должно быть заменено \(numberOfReplacements) элементов:\n"

        for (index, subsystem) in subsystems.enumerated() {
            text += "Подсистема #\(index + 1)\n"

            for (elIndex, element) in subsystem.elements.enumerated() {
                text += " Элемент #\(elIndex + 1)\n"
                text += "  Название элемента: \(element.title)\n"
                text += "  Дата установки: \(element.installationDate.convertToExtendedString())\n\n"
            }

        }

        return text
    }
}
