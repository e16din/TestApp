//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

@objc protocol DatePickerDelegate {
    func onDatePickerValueChanged(selectedDate: Date)
    func onDatePickerCancel()
    func onDatePickerValueSelected(selectedDate: Date)
    func onTouchOutsideDatePicker()
}

class DatePickerView: UIView {

    var datePickerDelegate: DatePickerDelegate!

    let vOutsideStub = UIView()
    let vToolBar = UIToolbar()
    let vDatePicker = UIDatePicker()

    // Events

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func onDatePickerValueSelected() {
        datePickerDelegate.onDatePickerValueSelected(selectedDate: vDatePicker.date)
    }

    @objc func onDatePickerValueChanged() {
        datePickerDelegate.onDatePickerValueChanged(selectedDate: vDatePicker.date)
    }

    func initPicker(date: Date) {
        showDatePicker(date: date)
        showToolbar()
        showOutsideStub()
    }

    // Actions

    func showDatePicker(date: Date) {
        vDatePicker.backgroundColor = .white
        vDatePicker.datePickerMode = .date

        vDatePicker.date = date
        vDatePicker.maximumDate = Date()

        vDatePicker.addTarget(self, action: #selector(onDatePickerValueChanged), for: .valueChanged)

        addSubview(vDatePicker)

        vDatePicker.translatesAutoresizingMaskIntoConstraints = false
        vDatePicker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        vDatePicker.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        vDatePicker.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }

    func showToolbar() {
        let vDoneButton = UIBarButtonItem(title: "Выбрать", style: .plain, target: self,
            action: #selector(onDatePickerValueSelected));
        let vCancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: datePickerDelegate,
            action: #selector(datePickerDelegate.onDatePickerCancel));
        let vSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)

        vToolBar.setItems([vDoneButton, vSpaceButton, vCancelButton], animated: false)
        addSubview(vToolBar)

        vToolBar.translatesAutoresizingMaskIntoConstraints = false
        vToolBar.bottomAnchor.constraint(equalTo: vDatePicker.topAnchor).isActive = true
        vToolBar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        vToolBar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    func showOutsideStub() {
        addSubview(vOutsideStub)

        let gesture = UITapGestureRecognizer(target: datePickerDelegate,
            action: #selector(datePickerDelegate.onTouchOutsideDatePicker))
        vOutsideStub.addGestureRecognizer(gesture)

        vOutsideStub.translatesAutoresizingMaskIntoConstraints = false
        vOutsideStub.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vOutsideStub.bottomAnchor.constraint(equalTo: vToolBar.topAnchor).isActive = true
        vOutsideStub.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        vOutsideStub.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
