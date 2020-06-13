//
// Created by ALEKSANDR KUNDRYUKOV on 11.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation

class Profile {

    struct Property {
        enum Name: String {
            case Name
            case Surname
            case Patronymic
            case Birthday
            case Sex
        }

        var name: Name
        var value: String

        func copy() -> Property {
            return Property(name: name, value: value)
        }
    }

    class SexTypes {
        let sexTypes = [
            0: "Не выбран",
            1: "Мужской",
            2: "Женский"
        ]

        func getString(_ type: Int) -> String {
            sexTypes[type] ?? String(type)
        }
    }

    var properties: [Property]

    init(_ properties: [Property]) {
        self.properties = properties
    }

    func copy() -> Profile {
        Profile(properties.map { property -> Profile.Property in
            property.copy()
        })
    }

    func getPropertyIndex(name: Property.Name) -> Int {
        properties.firstIndex(where: { $0.name == name }) ?? -1
    }
}