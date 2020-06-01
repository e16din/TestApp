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

class ProfileView: UIView,
    UITableViewDataSource,
    UITableViewDelegate,
    TextHeightChangedProtocol {

    var vTableContainer: UITableView!

    var data: ProfileData!

    // Events
    override init(frame: CGRect) {
        super.init(frame: frame)

        showView()
        showTableView()
    }

    required public init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.properties.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PropertyViewCell

        updatePropertyCell(cell: cell, indexPath: indexPath)

        return cell
    }

    func onTextHeightChanged(cell: PropertyViewCell) {
        updateTableView()
    }

    func onTextChanged(text: String!, rowIndex: Int!) {
        updateValue(rowIndex: rowIndex, text: text)
    }

    // Actions

    func showView() {
        backgroundColor = .white
    }

    func showTableView() {
        vTableContainer = UITableView()
        vTableContainer.translatesAutoresizingMaskIntoConstraints = false
        vTableContainer.delegate = self
        vTableContainer.dataSource = self
        vTableContainer.register(PropertyViewCell.self, forCellReuseIdentifier: "cell")
        addSubview(vTableContainer)

        let safeArea: UILayoutGuide = layoutMarginsGuide
        vTableContainer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        vTableContainer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        vTableContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vTableContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func updateTableView() {
        vTableContainer.beginUpdates()
        vTableContainer.endUpdates()
    }

    func updatePropertyCell(cell: PropertyViewCell, indexPath: IndexPath) {
        cell.cellDelegate = self
        cell.rowIndex = indexPath.row
        cell.isEditable = data.editModeEnabled

        let property = data.properties[indexPath.row]

        cell.updatePropertyView(values: makeDataForCell(property: property))
    }

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

    func updateValue(rowIndex: Int!, text: String!) {
        var property = data.properties[rowIndex]
        switch property.type {
        case .Name, .Surname, .Patronymic:
            data.properties[rowIndex].value = text

        default:
            print("Do nothing") //todo: remove it
        }
    }
}
