//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

@objc protocol ItemPickerDelegate {
    // Events
    func itemChanged(_ view: ItemPickerView, index: Int)
    func itemSelected(_ view: ItemPickerView, index: Int)

    // Actions
    func cancelItemPicker()
}

class ItemPickerView: UIView, SelectCancelToolbarDelegate, OutsideStubViewDelegate {

    var items: [Int: String]!

    var delegate: ItemPickerDelegate?

    var selectedRow = 0

    var pickerView: UIPickerView!
    var toolBar: UIToolbar!
    var outsideStubView: UIView!

    // Events

    init(_ items: [Int: String], selectedRow: Int) {
        super.init(frame: CGRect())

        self.items = items

        showItemPicker(selectedRow: selectedRow)
        showToolBar()
        showOutsideStubView()
    }

    required init(coder: NSCoder) {
        fatalError("Error: NSCoder is not supported")
    }

    // NOTE: to send 'index'
    @objc func itemSelected() {
        delegate?.itemSelected(self, index: pickerView.selectedRow(inComponent: 0))
    }

    func toolbarSelectButtonPressed() {
        delegate?.itemSelected(self, index: selectedRow)
    }

    func toolbarCancelButtonPressed() {
        delegate?.cancelItemPicker()
    }

    func outsideStubPressed() {
        delegate?.cancelItemPicker()
    }

    // Actions

    func showItemPicker(selectedRow: Int) {
        pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)

        addSubview(pickerView)

        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        pickerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }

    func showToolBar() {
        toolBar = AddSelectCancelToolbar()
            .addTo(self, bottomView: pickerView, delegate: self)
    }

    func showOutsideStubView() {
        outsideStubView = AddOutsideStubView()
            .addTo(self, bottomView: toolBar, delegate: self)
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension ItemPickerView: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }

    // Events

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        delegate?.itemChanged(self, index: row)
    }
}
