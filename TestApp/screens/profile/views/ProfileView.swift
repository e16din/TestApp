//
// Created by ALEKSANDR KUNDRYUKOV on 31.05.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

class ProfileData {

    struct Property {
        enum PropertyType {
            case Name, Surname, Patronymic, Birthday, Sex

            func toString() -> String {
                switch self {
                case .Name:
                    return "Name"
                case .Surname:
                    return "Surname"
                case .Patronymic:
                    return "Patronymic"
                case .Birthday:
                    return "Birthday"
                case .Sex:
                    return "Sex"
                }
            }
        }

        var type: PropertyType
        var value: Any
    }

    var properties: [Property] = [
        Property(type: .Name, value: "Иван"),
        Property(type: .Surname, value: "Иванов"),
        Property(type: .Patronymic, value: "Иванович"),
        Property(type: .Birthday, value: {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            return dateFormatter.date(from: "13.05.1992")
        }()),
        Property(type: .Sex, value: 1),
    ]

    var editModeEnabled = false
}

protocol ClickListenerProtocol: class {
    func onBirthdayPropertyClick()
    func onSexPropertyClick()
}

class ProfileView: UIView,
    UITableViewDataSource,
    UITableViewDelegate,
    TextChangedProtocol {

    var data: ProfileData!

    let PROPERTY_CELL_IDENTIFIER = "cell"

    var vTableContainer: UITableView!
    var vDatePicker: UIDatePicker!

    var clickListenerDelegate: ClickListenerProtocol?

    // Events
    override init(frame: CGRect) {
        super.init(frame: frame)

        showView()
        showProfileProperties()
    }

    required public init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.properties.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PROPERTY_CELL_IDENTIFIER) as! PropertyViewCell
        cell.selectionStyle = .none


        updatePropertyCell(cell: cell, indexPath: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch data.properties[indexPath.row].type {
        case .Birthday:
            clickListenerDelegate?.onBirthdayPropertyClick()
        case .Sex:
            clickListenerDelegate?.onSexPropertyClick()
        case .Name, .Surname, .Patronymic:
            "Set focus to any PropertyViewCell.UITextView"
        }
    }

    func onTextHeightChanged(cell: PropertyViewCell) {
        updateProfileProperties()
    }

    func onTextChanged(text: String!, rowIndex: Int!) {
        changePropertyValue(rowIndex: rowIndex, text: text)
    }

    func onBirthdayPropertyClick() {
        showBirthdayPicker()
    }

    @objc func onBirthdayPickerValueChanged() {
//        changeBirthdayPropertyValue()
    }

    @objc func onBirthdayPickerCancel() {

    }

    func onSexPropertyClick() {//todo set as listener
//        showSexPicker()
    }

    @objc func onSexPickerValueChanged() {
//        changeBirthdayPropertyValue()
    }

    @objc func onSexPickerCancel() {

    }

    // Actions

    func showView() {
        backgroundColor = .white
    }

    func showProfileProperties() {
        vTableContainer = UITableView()
        vTableContainer.delegate = self
        vTableContainer.dataSource = self
        vTableContainer.translatesAutoresizingMaskIntoConstraints = false
        vTableContainer.register(PropertyViewCell.self, forCellReuseIdentifier: PROPERTY_CELL_IDENTIFIER)
        addSubview(vTableContainer)

        vTableContainer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        vTableContainer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        vTableContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vTableContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func updateProfileProperties() {
        vTableContainer.beginUpdates()
        vTableContainer.endUpdates()
    }

    func updatePropertyCell(cell: PropertyViewCell, indexPath: IndexPath) {
        cell.cellDelegate = self
        cell.rowIndex = indexPath.row

        let property = data.properties[indexPath.row]

        if property.type == .Sex || property.type == .Birthday {
            cell.isEditableProperty = false
        } else {
            cell.isEditableProperty = data.editModeEnabled
        }

        cell.updatePropertyView(values: makeDataForCell(property: property))
    }

    func showBirthdayPicker() {
        vDatePicker = UIDatePicker()
        vDatePicker.translatesAutoresizingMaskIntoConstraints = false

        vDatePicker.datePickerMode = .date
        vDatePicker.addTarget(self, action: #selector(onBirthdayPickerValueChanged), for: .valueChanged)
        vDatePicker.addTarget(self, action: #selector(onBirthdayPickerCancel), for: .touchUpOutside)

        addSubview(vDatePicker)

        vDatePicker.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        vDatePicker.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        vDatePicker.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vDatePicker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

//    func showDatePicker(){ // todo
//        //Formate Date
//
//
//        //ToolBar
//        let toolbar = UIToolbar();
//        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
//
//        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
//
//        txtDatePicker.inputAccessoryView = toolbar
//        txtDatePicker.inputView = datePicker
//
//    }
//
//    @objc func cancelDatePicker(){
//        self.view.endEditing(true)
//    }

//    @objc func donedatePicker(){
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy"
//        txtDatePicker.text = formatter.string(from: datePicker.date)
//        self.view.endEditing(true)
//    }

    func makeDataForCell(property: ProfileData.Property) -> (name: String, value: String, isSingleLine: Bool) {
        switch property.type {
        case .Birthday:
            return ("Дата Рождения", "property.value as! String", true)

        case .Sex:
            let sexType = property.value as! Int
            var sexText = ""

            switch sexType {
            case 1:
                sexText = "мужской"
            case 2:
                sexText = "женский"
            default:
                sexText = "не выбран"
            }

            return ("Пол", sexText, true)

        case .Name:
            return ("Имя", property.value as! String, true)

        case .Surname:
            return ("Фамилия", property.value as! String, false)

        case .Patronymic:
            return ("Отчество", property.value as! String, true)
        }
    }

    func changePropertyValue(rowIndex: Int!, text: String!) {
        let property = data.properties[rowIndex]

        switch property.type {
        case .Name, .Surname, .Patronymic:
            data.properties[rowIndex].value = text

        default:
            print("Do nothing") //todo: remove it
        }
    }
}
