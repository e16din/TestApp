//
//  EditProfileScreen.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit


class EditProfileViewController: UIViewController, ProfileViewProtocol {

    var oldValues: [Any]!

    var vNavigationBar: UINavigationBar!
    var vProfileContainer: ProfileView!
    var vBirthdayPicker: DatePickerView!
    var vSexPicker: ItemPickerView!

    func getPropertyIndex(propertyType: ProfileFruit.Property.PropertyType) -> Int {
        vProfileContainer.data.properties.firstIndex(where: { $0.type == propertyType })!
    }

    // Events

    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationBar()
        showProfileView()
    }

    @objc func onActionSaveClick() {
        saveProfileProperties()
        showValidationFailedAlert()
    }

    func onBirthdayPropertyClick() {
        showBirthdayPicker()
    }

    func onSexPropertyClick() {
        showSexPicker()
    }

    // Actions

    func showValidationFailedAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Все поля, за исключением отчества являются обязательными", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style { //todo
            case .default:
                print("default")

            case .cancel:
                print("cancel")

            case .destructive:
                print("destructive")


            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func saveProfileProperties() {
        let defaults = UserDefaults.standard

        for property in vProfileContainer.data.properties {
            switch property.type {
            case .Birthday:
                let birthdayDate = property.value as? Date
                let birthdayText = birthdayDate?.toString(dateFormat: "dd.MM.yyyy") ?? ProfileFruit.DEFAULT_BIRTHDAY
                defaults.set(birthdayText, forKey: property.type.toString())

            default:
                defaults.set(property.value, forKey: property.type.toString())
            }
        }
    }

    func showNavigationBar() {
        let vBackButton = UIBarButtonItem()
        vBackButton.title = "Назад"
        navigationController?.navigationBar.topItem?.backBarButtonItem = vBackButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(onActionSaveClick))
        navigationItem.title = "Редактирование"
    }

    func showProfileView() {
        vProfileContainer = ProfileView(frame: view.frame)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        vProfileContainer.data = appDelegate.profileFruit
        vProfileContainer.data.editModeEnabled = true
        vProfileContainer.delegate = self

        view.addSubview(vProfileContainer)
    }

    func updatePropertyValue(value: Any, propertyType: ProfileFruit.Property.PropertyType) {
        let propertyIndex = getPropertyIndex(propertyType: propertyType)
        vProfileContainer.data.properties[propertyIndex].value = value
        vProfileContainer.vPropertiesTableContainer.reloadRows(at: [IndexPath(item: propertyIndex, section: 0)], with: .none)
    }
}

// Pick Birthday
extension EditProfileViewController: DatePickerDelegate {

    // Events

    func onDatePickerValueChanged(selectedDate: Date) {
        updatePropertyValue(value: selectedDate, propertyType: .Birthday)
    }

    func onDatePickerValueSelected(selectedDate: Date) {
        hideDatePicker()
        updatePropertyValue(value: selectedDate, propertyType: .Birthday)
    }

    func onDatePickerCancel() {
        hideDatePicker()

        let birthdayPropertyIndex = getPropertyIndex(propertyType: .Birthday)
        let oldBirthdayDate = oldValues[birthdayPropertyIndex]
        updatePropertyValue(value: oldBirthdayDate, propertyType: .Birthday)
    }

    func onTouchOutsideDatePicker() {
        onDatePickerCancel()
    }

    // Actions

    func showBirthdayPicker() {
        if vBirthdayPicker != nil && vBirthdayPicker.isDescendant(of: view) {
            print("The vBirthdayPicker is always shown")
            return
        }

        vBirthdayPicker = DatePickerView()
        vBirthdayPicker.datePickerDelegate = self

        let birthdayPropertyIndex = getPropertyIndex(propertyType: .Birthday)
        let date = vProfileContainer.data.properties[birthdayPropertyIndex].value as? Date ?? Date()
        vBirthdayPicker.initPicker(date: date)

        view.addSubview(vBirthdayPicker)

        vBirthdayPicker.translatesAutoresizingMaskIntoConstraints = false
        vBirthdayPicker.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vBirthdayPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vBirthdayPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vBirthdayPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }

    func hideDatePicker() {
        vBirthdayPicker.removeFromSuperview()
    }
}

// Pick Sex
extension EditProfileViewController: ItemPickerDelegate {

    // Events

    func onItemPickerValueChanged(selectedItemPosition: Int) {
        updatePropertyValue(value: selectedItemPosition, propertyType: .Sex)
    }

    func onItemPickerValueSelected(selectedItemPosition: Int) {
        hideItemPicker()
        updatePropertyValue(value: selectedItemPosition, propertyType: .Sex)
    }

    func onItemPickerCancel() {
        hideItemPicker()

        let sexPropertyIndex = getPropertyIndex(propertyType: .Sex)
        let oldSexType = oldValues[sexPropertyIndex]
        updatePropertyValue(value: oldSexType, propertyType: .Sex)
    }

    func onTouchOutsideItemPicker() {
        onItemPickerCancel()
    }

    // Actions

    func showSexPicker() {
        if vSexPicker != nil && vSexPicker.isDescendant(of: view) {
            print("The vSexPicker is always shown")
            return
        }

        vSexPicker = ItemPickerView()
        vSexPicker.itemPickerDelegate = self
        vSexPicker.initPicker(items: ProfileFruit.SEX_TYPES)

        view.addSubview(vSexPicker)

        vSexPicker.translatesAutoresizingMaskIntoConstraints = false
        vSexPicker.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vSexPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vSexPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vSexPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }

    func hideItemPicker() {
        vSexPicker.removeFromSuperview()
    }
}
