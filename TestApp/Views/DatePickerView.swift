//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

@objc protocol DatePickerDelegate {
    // Events
    func dateChanged(_ view: DatePickerView, date: Date)
    func dateSelected(_ view: DatePickerView, selectedDate: Date)

    // Actions
    func cancelDatePicker()
}

class DatePickerView: UIView,
    SelectCancelToolbarDelegate,
    OutsideStubViewDelegate {

    var delegate: DatePickerDelegate!

    var datePicker: UIDatePicker!
    var toolBar: UIToolbar!
    var outsideStubView: UIView!

    // Events

    init(_ date: Date) {
        super.init(frame: CGRect())

        showDatePicker(date: date)
        showToolBar()
        showOutsideStubView()
    }

    required init(coder: NSCoder) {
        fatalError("Error: NSCoder is not supported")
    }

    @objc func dateSelected() {
        delegate.dateSelected(self, selectedDate: datePicker.date)
    }

    @objc func dateChanged() {
        delegate.dateChanged(self, date: datePicker.date)
    }

    func toolbarSelectButtonPressed() {
        delegate.dateSelected(self, selectedDate: datePicker.date)
    }

    func toolbarCancelButtonPressed() {
        delegate.cancelDatePicker()
    }

    func outsideStubPressed() {
        delegate.cancelDatePicker()
    }

    // Actions

    func showDatePicker(date: Date) {
        datePicker = UIDatePicker()
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .date

        datePicker.date = date
        datePicker.maximumDate = Date()

        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

        addSubview(datePicker)

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }

    func showToolBar() {
        toolBar = AddSelectCancelToolbar()
            .addTo(self, bottomView: datePicker, delegate: self)
    }

    func showOutsideStubView() {
        outsideStubView = AddOutsideStubView()
            .addTo(self, bottomView: datePicker, delegate: self)
    }
}
