//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation

class ProfileFruit {

    static let SEX_TYPES = [
        0: "Не выбран",
        1: "Мужской",
        2: "Женский"
    ]

    struct Property {
        enum PropertyType {
            case Name, Surname, Patronymic, Birthday, Sex

            func toString() -> String {
                switch self {
                case .Name:
                    return "Name"
                case .Surname:
                    return "Surname"
                case .Patronymic:
                    return "Patronymic"
                case .Birthday:
                    return "Birthday"
                case .Sex:
                    return "Sex"
                }
            }
        }

        var type: PropertyType
        var value: String

        func copy() -> Property {
            return Property(type: type, value: value)
        }
    }

    var properties: [Property] = [
        Property(type: .Name, value: ""),
        Property(type: .Surname, value: ""),
        Property(type: .Patronymic, value: ""),
        Property(type: .Birthday, value: ""),
        Property(type: .Sex, value: ""),
    ]
}
