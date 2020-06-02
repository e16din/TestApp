//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation

class ProfileFruit {

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
        var value: Any?
    }

    static let DEFAULT_NAME = "Иван"
    static let DEFAULT_SURNAME = "Иванов"
    static let DEFAULT_PATRONYMIC = "Иванович"
    static let DEFAULT_BIRTHDAY = "Не указана"
    static let DEFAULT_SEX = 0

    var properties: [Property] = [
        Property(type: .Name, value: DEFAULT_NAME),
        Property(type: .Surname, value: DEFAULT_SURNAME),
        Property(type: .Patronymic, value: DEFAULT_PATRONYMIC),
        Property(type: .Birthday, value: DEFAULT_BIRTHDAY),
        Property(type: .Sex, value: DEFAULT_SEX),
    ]

    var editModeEnabled = false
}
