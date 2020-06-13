//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation

protocol EditProfileModelControllerDelegate {
    func profileSaved(_ profile: Profile)
}

class EditProfileModelController {

    var profile: Profile!
    var originProperties: [Profile.Property]!

    var delegate: EditProfileModelControllerDelegate?


    // Events

    init(_ profile: Profile, delegate: EditProfileModelControllerDelegate) {
        self.profile = profile
        self.delegate = delegate

        originProperties = profile.properties.map({ it in
            it.copy()
        })
    }

    // Actions

    func saveProfileProperties() {
        let defaults = UserDefaults.standard
        for property in profile.properties {
            defaults.set(property.value, forKey: property.name.rawValue)
        }

        originProperties = profile.properties.map { property -> Profile.Property in
            property
        }

        delegate?.profileSaved(profile.copy())
    }

    func updateProperty(_ index: Int, value: String) {
        profile.properties[index].value = value
    }

    func updateProperty(_ name: Profile.Property.Name, value: String) {
        let propertyIndex = getPropertyIndex(name)
        profile.properties[propertyIndex].value = value
    }

    // Support

    func getPropertyIndex(_ name: Profile.Property.Name) -> Int {
        profile.getPropertyIndex(name: name)
    }

    func getPropertyValue(_ name: Profile.Property.Name) -> String {
        let index = getPropertyIndex(name)
        let value = profile.properties[index].value
        return value
    }

    func getOriginPropertyValue(_ name: Profile.Property.Name) -> String {
        let index = getPropertyIndex(name)
        let originValue = originProperties[index].value
        return originValue
    }

    func isProfileChanged() -> Bool {
        var hasChanges = false

        for (index, property) in profile.properties.enumerated() {
            hasChanges = property.value != originProperties[index].value
            if (hasChanges) {
                break
            }
        }
        return hasChanges
    }

    func areRequiredPropertiesFilled() -> Bool {
        for property in profile.properties {
            if (property.name != .Patronymic && property.value.isEmpty) {
                return false
            }
        }

        return true
    }

    func makeDataForPropertyCell(index: Int) -> (name: String, value: String, isSingleLine: Bool) {
        let property = profile.properties[index]
        let isEmptyValue = property.value.isEmpty

        var result = ("Unknown", "Unknown", true)

        switch property.name {
        case .Birthday:
            result = ("Дата Рождения", isEmptyValue ? "" : property.value, true)

        case .Sex:
            let sexType = Profile.SexTypes().getString(Int(property.value) ?? 0)
            result = ("Пол", sexType, true)

        case .Name:
            result = ("Имя", isEmptyValue ? "" : property.value, true)

        case .Surname:
            result = ("Фамилия", isEmptyValue ? "" : property.value, false)

        case .Patronymic:
            result = ("Отчество", isEmptyValue ? "" : property.value, true)
        }

        return result
    }

    func getPropertiesCount() -> Int {
        profile.properties.count
    }

    func isClickableProperty(_ index: Int) -> Bool {
        let propertyName = profile.properties[index].name

        switch propertyName {
        case .Birthday, .Sex:
            return true
        default:
            return false
        }

    }
}
