//
//  EditProfileScreen.swift
//  TestApp
//
//  Created by ALEKSANDR KUNDRYUKOV on 28.03.2020.
//  Copyright © 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit


class EditProfileViewController: UIViewController, ClickListenerProtocol {

    var vNavigationBar: UINavigationBar!
    var vProfileContainer: ProfileView!
    var vDatePicker: UIDatePicker!
    var vDatePickerToolBar: UIToolbar!
    let vOutsideStub = UIView()

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

    @objc func onBirthdayPickerValueSelected() {
        let selectedDate = vDatePicker.date

        hideDatePicker()

        let birthdayParameterIndex = getBirthdayParameterIndex()
        vProfileContainer.data.properties[birthdayParameterIndex].value = selectedDate

        vProfileContainer.vPropertiesTableContainer.reloadRows(at: [IndexPath(item: birthdayParameterIndex, section: 0)], with: .none)
    }

    @objc func onBirthdayPickerValueChanged() {
        updateBirthdayValue(date: vDatePicker.date)
    }

    @objc func onBirthdayPickerCancel() {
        hideDatePicker()
        updateBirthdayValue(date: vProfileContainer.data.properties[getBirthdayParameterIndex()].value as? Date)
    }

    @objc func onTouchOutsideDatePicker() {
        hideDatePicker()
        updateBirthdayValue(date: vProfileContainer.data.properties[getBirthdayParameterIndex()].value as? Date)
    }

    func onSexPropertyClick() {
        print("2")
    }

    @objc func onSexPickerValueChanged() {//todo
//        changeBirthdayPropertyValue()
    }

    @objc func onSexPickerCancel() {//todo

    }

    // Actions

    func showBirthdayPicker() {
        if vDatePicker != nil && vDatePicker.isDescendant(of: view) {
            print("The vDatePicker is always shown")
            return
        }

        // vDatePicker

        vDatePicker = UIDatePicker()
        vDatePicker.translatesAutoresizingMaskIntoConstraints = false
        vDatePicker.backgroundColor = .white
        vDatePicker.datePickerMode = .date

        vDatePicker.date = vProfileContainer.data.properties[getBirthdayParameterIndex()].value as? Date ?? Date()
        vDatePicker.maximumDate = Date()

        vDatePicker.addTarget(self, action: #selector(onBirthdayPickerValueChanged), for: .valueChanged)
        vDatePicker.addTarget(self, action: #selector(onBirthdayPickerCancel), for: .touchUpOutside)

        let birthdayParameterIndex = getBirthdayParameterIndex()
        view.addSubview(vDatePicker)

        vDatePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vDatePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        vDatePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // vDatePickerToolBar

        vDatePickerToolBar = UIToolbar();
        vDatePickerToolBar.translatesAutoresizingMaskIntoConstraints = false

        let vDoneButton = UIBarButtonItem(title: "Выбрать", style: .plain, target: self, action: #selector(onBirthdayPickerValueSelected));
        let vSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let vCancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(onBirthdayPickerCancel));

        vDatePickerToolBar.setItems([vDoneButton, vSpaceButton, vCancelButton], animated: false)
        view.addSubview(vDatePickerToolBar)

        vDatePickerToolBar.bottomAnchor.constraint(equalTo: vDatePicker.topAnchor).isActive = true
        vDatePickerToolBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        vDatePickerToolBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        // vOutsideStub

        view.addSubview(vOutsideStub)
        vOutsideStub.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTouchOutsideDatePicker))
        vOutsideStub.addGestureRecognizer(gesture)

        vOutsideStub.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vOutsideStub.bottomAnchor.constraint(equalTo: vDatePickerToolBar.topAnchor).isActive = true
        vOutsideStub.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        vOutsideStub.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
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
        vProfileContainer.clickListenerDelegate = self

        view.addSubview(vProfileContainer)
    }

    func updateBirthdayValue(date: Date?) {
        let vBirthdayValueField = vProfileContainer.getValueFieldView(rowIndex: getBirthdayParameterIndex()).vPropertyField
        vBirthdayValueField?.text = date?.toString(dateFormat: "dd.MM.yyyy") ??  ProfileFruit.DEFAULT_BIRTHDAY
    }

    func hideDatePicker() {
        vDatePickerToolBar.removeFromSuperview()
        vDatePicker.removeFromSuperview()
        vOutsideStub.removeFromSuperview()
    }

    func getBirthdayParameterIndex() -> Int {
        vProfileContainer.data.properties.firstIndex(where: { $0.type == .Birthday })!
    }
}


