//
//  FileExporter.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.01.2023.
//

import Foundation
import SwiftUI

class FileExporter {
    static func exportPDF(text: String) {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.text]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Сохранение"
        savePanel.message = "Выберите папку для сохранения файла"
        savePanel.nameFieldLabel = "Имя файла:"
        let response = savePanel.runModal()
        if response == .OK {
            let urlToSave = savePanel.url
            guard let urlToSave = urlToSave else { return }

            do {
                try text.write(to: urlToSave, atomically: false, encoding: .utf8)
            } catch {
                print(error)
            }
        }
    }
}
