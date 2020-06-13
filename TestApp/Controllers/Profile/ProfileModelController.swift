//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation


class ProfileModelController: EditProfileModelControllerDelegate {

    var profile: Profile

    // Events

    init(_ profile: Profile) {
        self.profile = profile
    }

    func profileSaved(_ newProfile: Profile) {
        self.profile = newProfile
    }

    // Actions

    func loadProfileProperties() {
        let defaults = UserDefaults.standard

        for (index, property) in profile.properties.enumerated() {
            if let value = defaults.string(forKey: property.name.rawValue) {
                profile.properties[index].value = value
            }
        }
    }

    // Support

    func makeDataForPropertyCell(index: Int) -> (name: String, value: String, isSingleLine: Bool) {
        let property = profile.properties[index]
        let isEmptyValue = property.value.isEmpty

        var result = ("Unknown", "Unknown", true)

        switch property.name {
        case .Birthday:
            result = ("Дата Рождения", isEmptyValue ? "Не указана" : property.value, true)

        case .Sex:
            let sexType = Profile.SexTypes().getString(Int(property.value) ?? 0)
            result = ("Пол", sexType, true)

        case .Name:
            result = ("Имя", isEmptyValue ? "Не указано" : property.value, true)

        case .Surname:
            result = ("Фамилия", isEmptyValue ? "Не указана" : property.value, false)

        case .Patronymic:
            result = ("Отчество", isEmptyValue ? "Не указано" : property.value, true)
        }

        return result
    }

    func getPropertiesCount() -> Int {
        profile.properties.count
    }
}
