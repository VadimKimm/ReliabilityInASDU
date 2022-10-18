//
//  SchemeObservable.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 06.10.2022.
//

import Foundation

class SchemeObservable: ObservableObject {
    @Published var firstBlock = SchemeBlockType.firstType.block
    @Published var secondBlock = SchemeBlockType.secondType.block
    @Published var thirdBlock = SchemeBlockType.thirdType.block
}
