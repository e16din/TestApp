//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation


class ProfileModelController: EditProfileModelControllerDelegate {

    var profile: Profile
    var isProfileLoaded = false

    private var properties: [PropertyViewCell.Property]!

    // MARK: - Events

    init(_ profile: Profile) {
        self.profile = profile
        properties = makeProperties(profile)
    }

    func profileSaved(_ newProfile: Profile) {
        self.profile = newProfile
        properties = makeProperties(profile)
    }

    // MARK: - Actions

    func loadProfileAsync(_ actionDone: (() -> Void)?) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            do {
                let decoder = JSONDecoder()
                if let profileJson = UserDefaults.standard.string(forKey: self.profile.KEY)?.utf8 {
                    let data = Data(profileJson)
                    self.profile = try decoder.decode(Profile.self, from: data)
                    self.properties = self.makeProperties(self.profile)
                }
            } catch {
                print("Error: loadProfileAsync()")
            }

            DispatchQueue.main.async {
                actionDone?()
            }
        }
    }

    func makeProperties(_ profile: Profile) -> [PropertyViewCell.Property] {
        [
            PropertyViewCell.Property(.name,
                name: "Имя",
                value: profile.name.isEmpty ? "Не указано" : profile.name,
                isSingleLine: true,
                isClickable: false),

            PropertyViewCell.Property(.surname,
                name: "Фамилия",
                value: profile.surname.isEmpty ? "Не указана" : profile.surname,
                isSingleLine: false,
                isClickable: false),

            PropertyViewCell.Property(.patronymic,
                name: "Отчество",
                value: profile.patronymic.isEmpty ? "Не указано" : profile.patronymic,
                isSingleLine: true,
                isClickable: false),

            PropertyViewCell.Property(.birthday,
                name: "Дата Рождения",
                value: profile.birthday.isEmpty ? "Не указана" : profile.birthday,
                isSingleLine: true,
                isClickable: true),

            PropertyViewCell.Property(.sex,
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
