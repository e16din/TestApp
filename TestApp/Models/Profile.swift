//
// Created by ALEKSANDR KUNDRYUKOV on 11.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation

struct Profile: Codable {

    enum PropertyType: String, CodingKey {
        case name
        case surname
        case patronymic
        case birthday
        case sex
    }

    let KEY = "Profile"

    var name = ""
    var surname = ""
    var patronymic = ""
    var birthday = ""
    var sex = 0

    init() {
        // do nothing
    }

    init(name: String, surname: String, patronymic: String, birthday: String, sex: Int) {
        self.name = name
        self.surname = surname
        self.patronymic = patronymic
        self.birthday = birthday
        self.sex = sex
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PropertyType.self)
        name = try container.decode(String.self, forKey: .name)
        surname = try container.decode(String.self, forKey: .surname)
        patronymic = try container.decode(String.self, forKey: .patronymic)
        birthday = try container.decode(String.self, forKey: .birthday)
        sex = try container.decode(Int.self, forKey: .sex)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PropertyType.self)
        try container.encode(name, forKey: .name)
        try container.encode(surname, forKey: .surname)
        try container.encode(patronymic, forKey: .patronymic)
        try container.encode(birthday, forKey: .birthday)
        try container.encode(sex, forKey: .sex)
    }
}