//
// Created by ALEKSANDR KUNDRYUKOV on 31.05.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit



protocol ClickListenerProtocol: class {
    func onBirthdayPropertyClick()
    func onSexPropertyClick()
}

class ProfileView: UIView,
    UITableViewDataSource,
    UITableViewDelegate,
    TextChangedProtocol {

    var data: ProfileFruit!

    let PROPERTY_CELL_IDENTIFIER = "cell"

    var vPropertiesTableContainer: UITableView!

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

    func makeDataForCell(property: ProfileFruit.Property) -> (name: String, value: String, isSingleLine: Bool) {
        switch property.type {
        case .Birthday:
            let birthdayDate = property.value as! Date
            let birthdayText = birthdayDate.toString(dateFormat: "dd.MM.yyyy")
            return ("Дата Рождения", birthdayText, true)

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

    func getValueFieldView(rowIndex index: Int) -> PropertyViewCell {
        return vPropertiesTableContainer.cellForRow(at: IndexPath(item: index, section: 0)) as! PropertyViewCell
    }
}

extension Date {
    func toString(dateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
