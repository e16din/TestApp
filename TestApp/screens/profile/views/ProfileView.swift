//
// Created by ALEKSANDR KUNDRYUKOV on 31.05.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit


protocol ProfileViewProtocol: class {
    func onBirthdayPropertyClick()
    func onSexPropertyClick()
}

class ProfileView: UIView,
    UITableViewDataSource,
    UITableViewDelegate,
    TextChangedProtocol {

    var editModeEnabled = false

    let PROPERTY_CELL_IDENTIFIER = "cell"

    var vPropertiesTableContainer: UITableView!

    var delegate: ProfileViewProtocol?

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
        return fruits.profile.properties.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PROPERTY_CELL_IDENTIFIER) as! PropertyViewCell
        cell.selectionStyle = .none


        showProperty(cell: cell, indexPath: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch fruits.profile.properties[indexPath.row].type {
        case .Birthday:
            delegate?.onBirthdayPropertyClick()
        case .Sex:
            delegate?.onSexPropertyClick()
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

    // Actions

    func showView() {
        backgroundColor = .white
    }

    func showProfileProperties() {
        vPropertiesTableContainer = UITableView()
        vPropertiesTableContainer.delegate = self
        vPropertiesTableContainer.dataSource = self
        vPropertiesTableContainer.translatesAutoresizingMaskIntoConstraints = false
        vPropertiesTableContainer.register(PropertyViewCell.self, forCellReuseIdentifier: PROPERTY_CELL_IDENTIFIER)
        addSubview(vPropertiesTableContainer)

        vPropertiesTableContainer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        vPropertiesTableContainer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        vPropertiesTableContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vPropertiesTableContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func updateProfileProperties() {
        vPropertiesTableContainer.beginUpdates()
        vPropertiesTableContainer.endUpdates()
    }

    func showProperty(cell: PropertyViewCell, indexPath: IndexPath) {
        cell.cellDelegate = self
        cell.rowIndex = indexPath.row

        let property = fruits.profile.properties[indexPath.row]

        if property.type == .Sex || property.type == .Birthday {
            cell.isEditableProperty = false
        } else {
            cell.isEditableProperty = editModeEnabled
        }

        cell.updatePropertyView(values: makeDataForCell(property: property))
    }

    func makeDataForCell(property: ProfileFruit.Property) -> (name: String, value: String, isSingleLine: Bool) {
        switch property.type {
        case .Birthday:
            let birthdayDate = property.value as? Date
            let birthdayText = birthdayDate?.toString(dateFormat: "dd.MM.yyyy") ?? ProfileFruit.DEFAULT_BIRTHDAY
            return ("Дата Рождения", birthdayText, true)

        case .Sex:
            let sexType = property.value as? Int ?? ProfileFruit.DEFAULT_SEX_TYPE
            let sexText  = ProfileFruit.SEX_TYPES[sexType] ?? ProfileFruit.SEX_TYPES[0]!

            return ("Пол", sexText, true)

        case .Name:
            return ("Имя", property.value as? String ?? ProfileFruit.DEFAULT_NAME, true)

        case .Surname:
            return ("Фамилия", property.value as? String ?? ProfileFruit.DEFAULT_SURNAME, false)

        case .Patronymic:
            return ("Отчество", property.value as? String ?? ProfileFruit.DEFAULT_PATRONYMIC, true)
        }
    }

    func updateProperty(index: Int) {
        vPropertiesTableContainer.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
    }

    func changePropertyValue(rowIndex: Int!, text: String!) {
        let profile = fruits.profile!

        let property = profile.properties[rowIndex]

        switch property.type {
        case .Name, .Surname, .Patronymic:
            profile.properties[rowIndex].value = text

        default:
            "Do nothing"
        }
    }

    func getValueFieldView(rowIndex index: Int) -> PropertyViewCell {
        return vPropertiesTableContainer.cellForRow(at: IndexPath(item: index, section: 0)) as! PropertyViewCell
    }
}

extension Date {
    func toString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
