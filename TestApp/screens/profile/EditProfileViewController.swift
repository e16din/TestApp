//
//  EditProfileScreen.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit


class EditProfileViewController: UIViewController,
    ProfileViewProtocol,
    UIPickerViewDataSource,
    UIPickerViewDelegate {

    var vNavigationBar: UINavigationBar!
    var vProfileContainer: ProfileView!
    var vBirthdayPicker = DatePickerView(frame: UIScreen.main.bounds)
    var vSexPicker = ItemPickerView()

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

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vProfileContainer.data.sexDictionary.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vProfileContainer.data.sexDictionary[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        typeBarButton.title = array[row]["type1"] as? String
//        typePickerView.hidden = false
    }

    @objc func onSexPickerValueChanged() {//todo
//        changeBirthdayPropertyValue()
    }

    @objc func onSexPickerCancel() {//todo

    }

    // Actions

    func showSexPicker() {
        if vSexPicker != nil && vSexPicker.isDescendant(of: view) {
            print("The vDatePicker is always shown")
            return
        }
    }

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
}

// Pick Birthday
extension EditProfileViewController: DatePickerDelegate {

    // Events

    func onDatePickerValueChanged(selectedDate: Date) {
        updateBirthdayValue(date: selectedDate)
    }

    func onDatePickerCancel() {
        hideDatePicker()
        updateBirthdayValue(date: vProfileContainer.data.properties[getBirthdayParameterIndex()].value as? Date)
    }

    func onDatePickerValueSelected(selectedDate: Date) {
        let selectedDate = selectedDate

        hideDatePicker()

        let birthdayParameterIndex = getBirthdayParameterIndex()
        vProfileContainer.data.properties[birthdayParameterIndex].value = selectedDate

        vProfileContainer.vPropertiesTableContainer.reloadRows(at: [IndexPath(item: birthdayParameterIndex, section: 0)], with: .none)
    }

    func onTouchOutsideDatePicker() {
        hideDatePicker()
        updateBirthdayValue(date: vProfileContainer.data.properties[getBirthdayParameterIndex()].value as? Date)
    }

    // Actions

    func showBirthdayPicker() {
        if vBirthdayPicker.isDescendant(of: view) {
            print("The vDatePicker is always shown")
            return
        }

        vBirthdayPicker.datePickerDelegate = self
        let birthdayParameterIndex = getBirthdayParameterIndex()
        let date = vProfileContainer.data.properties[birthdayParameterIndex].value as? Date ?? Date()
        vBirthdayPicker.show(date: date)

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

    func updateBirthdayValue(date: Date?) {
        let vBirthdayValueField = vProfileContainer.getValueFieldView(rowIndex: getBirthdayParameterIndex()).vPropertyField
        vBirthdayValueField?.text = date?.toString(dateFormat: "dd.MM.yyyy") ?? ProfileFruit.DEFAULT_BIRTHDAY
    }

    func getBirthdayParameterIndex() -> Int {
        vProfileContainer.data.properties.firstIndex(where: { $0.type == .Birthday })!
    }
}
