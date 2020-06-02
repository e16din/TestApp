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
        var value: Any
    }

    var properties: [Property] = [
        Property(type: .Name, value: "Иван"),
        Property(type: .Surname, value: "Иванов"),
        Property(type: .Patronymic, value: "Иванович"),
        Property(type: .Birthday, value: {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.date(from: "13.05.1992")
        }()),
        Property(type: .Sex, value: 1),
    ]

    var editModeEnabled = false
}
