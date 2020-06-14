//
// Created by ALEKSANDR KUNDRYUKOV on 14.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation

class SexTypes {
    let sexTypes = [
        0: "Не выбран",
        1: "Мужской",
        2: "Женский"
    ]

    func getString(_ type: Int) -> String {
        sexTypes[type] ?? String(type)
    }

    func getType(_ value: String) -> Int {
        if let index = sexTypes.firstIndex(where: { $0.value == value }) {
            return sexTypes[index].key
        }

        return 0
    }
}
