//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation

// Fruit
class ProfileModelController {

    let sexTypes = [
        0: "Не выбран",
        1: "Мужской",
        2: "Женский"
    ]

    struct Property {
        enum PropertyType: String {
            case Name, Surname, Patronymic, Birthday, Sex
        }

        var type: PropertyType
        var value: String
    }

    var properties: [Property] = [
        Property(type: .Name, value: ""),
        Property(type: .Surname, value: ""),
        Property(type: .Patronymic, value: ""),
        Property(type: .Birthday, value: ""),
        Property(type: .Sex, value: ""),
    ]
}
