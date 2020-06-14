//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation

protocol EditProfileModelControllerDelegate: class {
    func profileSaved(_ profile: Profile)
}

class EditProfileModelController {

    var profile: Profile

    var properties: [PropertyViewCell.Property]!
    var originProperties: [PropertyViewCell.Property]!

    weak var delegate: EditProfileModelControllerDelegate?

    // MARK: - Events

    init(_ profile: Profile, delegate: EditProfileModelControllerDelegate) {
        self.profile = profile
        self.delegate = delegate

        properties = makeProperties(profile)
        originProperties = makeProperties(profile)
    }

    // MARK: - Actions

    func saveProfile() throws {
        profile = makeProfile(properties)

        let encoder = JSONEncoder()
        let data = try encoder.encode(profile)
        let profileJson = String(data: data, encoding: .utf8)
        UserDefaults.standard.set(profileJson, forKey: profile.KEY)

        originProperties = properties

        delegate?.profileSaved(profile)
    }

    func makeProperties(_ profile: Profile) -> [PropertyViewCell.Property] {
        [
            PropertyViewCell.Property(.Name,
                name: "Имя",
                value: profile.name,
                isSingleLine: true,
                isClickable: false),

            PropertyViewCell.Property(.Surname,
                name: "Фамилия",
                value: profile.surname,
                isSingleLine: false,
                isClickable: false),

            PropertyViewCell.Property(.Patronymic,
                name: "Отчество",
                value: profile.patronymic,
                isSingleLine: true,
                isClickable: false),

            PropertyViewCell.Property(.Birthday,
                name: "Дата Рождения",
                value: profile.birthday.isEmpty ? Date().toString(dateFormat: "dd.MM.yyyy") : profile.birthday,
                isSingleLine: true,
                isClickable: true),

            PropertyViewCell.Property(.Sex,
                name: "Пол",
                value: SexTypes().getString(profile.sex),
                isSingleLine: true,
                isClickable: true),
        ]
    }

    func makeProfile(_ props: [PropertyViewCell.Property]) -> Profile {
        Profile(
            name: getPropertyValue(.Name),
            surname: getPropertyValue(.Surname),
            patronymic: getPropertyValue(.Patronymic),
            birthday: getPropertyValue(.Birthday),
            sex: SexTypes().getType(getPropertyValue(.Sex))
        )
    }

    func updateProperty(_ type: Profile.PropertyType, value: String) {
        let index = getPropertyIndex(type)
        properties[index].value = value
    }

    func updateProperty(_ index: Int, value: String) {
        properties[index].value = value
    }

    func updateSexProperty(sexType: Int) {
        let index = getPropertyIndex(.Sex)
        updateProperty(index, value: SexTypes().getString(sexType))
    }

    func resetSexProperty() {
        let index = getPropertyIndex(.Sex)
        let originSexValue = getOriginPropertyValue(.Sex)
        updateProperty(index, value: originSexValue)
    }

    func resetBirthdayProperty() {
        let originBirthdayDate = getOriginPropertyValue(.Birthday)
        updateProperty(.Birthday, value: originBirthdayDate)
    }

    // MARK: - Support

    func getPropertyValue(_ type: Profile.PropertyType) -> String {
        let index = getPropertyIndex(type)
        return properties[index].value
    }

    func getOriginPropertyValue(_ type: Profile.PropertyType) -> String {
        let index = getPropertyIndex(type)
        return originProperties[index].value
    }

    func isProfileChanged() -> Bool {
        var hasChanges = false

        for (i, property) in properties.enumerated() {
            hasChanges = property.value != originProperties[i].value
            if (hasChanges) {
                break
            }
        }

        return hasChanges
    }

    func areRequiredPropertiesFilled() -> Bool {
        let tempProfile = makeProfile(properties)
        if tempProfile.name.isEmpty {
            return false
        }
        if tempProfile.surname.isEmpty {
            return false
        }
        if tempProfile.sex == 0 {
            return false
        }
        if tempProfile.birthday.isEmpty || tempProfile.birthday == Date().toString(dateFormat: "dd.MM.yyyy") {
            return false
        }

        return true
    }

    func getPropertyCellData(index: Int) -> PropertyViewCell.Property {
        properties[index]
    }

    func getPropertiesCount() -> Int {
        properties.count
    }

    func getPropertyIndex(_ type: Profile.PropertyType) -> Int {
        for (i, item) in properties.enumerated() {
            if (item.type == type) {
                return i
            }
        }

        return -1
    }

    func getPropertyType(_ index: Int) -> Profile.PropertyType {
        properties[index].type
    }
}
