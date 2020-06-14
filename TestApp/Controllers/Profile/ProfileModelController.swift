//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation


class ProfileModelController: EditProfileModelControllerDelegate {

    var profile: Profile

    var properties: [PropertyViewCell.Property]!

    // MARK: - Events

    init(_ profile: Profile) {
        self.profile = profile
        properties = makeProperties(profile)
    }

    func profileSaved(_ newProfile: Profile) {
        profile = newProfile
        properties = makeProperties(profile)
    }

    // MARK: - Actions

    func loadProfile() throws {
        let decoder = JSONDecoder()
        if let profileJson = UserDefaults.standard.string(forKey: profile.KEY)?.utf8 {
            let data = Data(profileJson)
            profile = try decoder.decode(Profile.self, from: data)
            properties = makeProperties(profile)
        }
    }

    func makeProperties(_ profile: Profile) -> [PropertyViewCell.Property] {
        [
            PropertyViewCell.Property(.Name,
                name: "Имя",
                value: profile.name.isEmpty ? "Не указано" : profile.name,
                isSingleLine: true,
                isClickable: false),

            PropertyViewCell.Property(.Surname,
                name: "Фамилия",
                value: profile.surname.isEmpty ? "Не указана" : profile.surname,
                isSingleLine: false,
                isClickable: false),

            PropertyViewCell.Property(.Patronymic,
                name: "Отчество",
                value: profile.patronymic.isEmpty ? "Не указано" : profile.patronymic,
                isSingleLine: true,
                isClickable: false),

            PropertyViewCell.Property(.Birthday,
                name: "Дата Рождения",
                value: profile.birthday.isEmpty ? "Не указана" : profile.birthday,
                isSingleLine: true,
                isClickable: true),

            PropertyViewCell.Property(.Sex,
                name: "Пол",
                value: SexTypes().getString(profile.sex),
                isSingleLine: true,
                isClickable: true),
        ]
    }

    // MARK: - Support

    func getPropertiesCount() -> Int {
        properties.count
    }

    func getPropertyCellData(_ index: Int) -> PropertyViewCell.Property {
        properties[index]
    }
}