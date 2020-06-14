//
// Created by ALEKSANDR KUNDRYUKOV on 11.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation

struct Profile: Codable {

    enum PropertyType: String, CodingKey {
        case Name
        case Surname
        case Patronymic
        case Birthday
        case Sex
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
        name = try container.decode(String.self, forKey: .Name)
        surname = try container.decode(String.self, forKey: .Surname)
        patronymic = try container.decode(String.self, forKey: .Patronymic)
        birthday = try container.decode(String.self, forKey: .Birthday)
        sex = try container.decode(Int.self, forKey: .Sex)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PropertyType.self)
        try container.encode(name, forKey: .Name)
        try container.encode(surname, forKey: .Surname)
        try container.encode(patronymic, forKey: .Patronymic)
        try container.encode(birthday, forKey: .Birthday)
        try container.encode(sex, forKey: .Sex)
    }
}