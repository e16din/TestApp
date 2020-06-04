//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

@objc protocol ItemPickerDelegate {
    func onItemPickerValueChanged(selectedItemPosition: Int)
    func onItemPickerCancel()
    func onItemPickerValueSelected(selectedItemPosition: Int)
    func onTouchOutsideItemPicker()
}

class ItemPickerView: UIView,
    UIPickerViewDataSource,
    UIPickerViewDelegate {

    var itemsDictionary: [Int: String]!

    var itemPickerDelegate: ItemPickerDelegate!

    var vItemPicker = UIPickerView()
    let vOutsideStub = UIView()
    let vToolBar = UIToolbar()

    // Events

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func initPicker(items: [Int: String], selectedRow: Int) {
        itemsDictionary = items

        showItemPicker(selectedRow: selectedRow)
        showToolbar()
        showOutsideStub()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsDictionary.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemsDictionary[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        itemPickerDelegate.onItemPickerValueChanged(selectedItemPosition: row)
    }

    @objc func onItemPickerValueSelected() {
        itemPickerDelegate.onItemPickerValueSelected(selectedItemPosition: vItemPicker.selectedRow(inComponent: 0))
    }

    // Actions

    func showItemPicker(selectedRow: Int) {
        vItemPicker.translatesAutoresizingMaskIntoConstraints = false
        vItemPicker.dataSource = self
        vItemPicker.delegate = self
        vItemPicker.backgroundColor = .white
        vItemPicker.selectRow(selectedRow, inComponent: 0, animated: false)

        addSubview(vItemPicker)

        vItemPicker.translatesAutoresizingMaskIntoConstraints = false
        vItemPicker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        vItemPicker.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        vItemPicker.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }

    //todo: extract vToolBar and vOutsideStub to base class for pickers

    func showToolbar() {
        let vDoneButton = UIBarButtonItem(title: "Выбрать", style: .plain, target: self,
            action: #selector(onItemPickerValueSelected));
        let vCancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: itemPickerDelegate,
            action: #selector(itemPickerDelegate.onItemPickerCancel));
        let vSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)

        vToolBar.setItems([vDoneButton, vSpaceButton, vCancelButton], animated: false)
        addSubview(vToolBar)

        vToolBar.translatesAutoresizingMaskIntoConstraints = false
        vToolBar.bottomAnchor.constraint(equalTo: vItemPicker.topAnchor).isActive = true
        vToolBar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        vToolBar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    func showOutsideStub() {
        addSubview(vOutsideStub)

        let gesture = UITapGestureRecognizer(target: itemPickerDelegate,
            action: #selector(itemPickerDelegate.onTouchOutsideItemPicker))
        vOutsideStub.addGestureRecognizer(gesture)

        vOutsideStub.translatesAutoresizingMaskIntoConstraints = false
        vOutsideStub.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vOutsideStub.bottomAnchor.constraint(equalTo: vToolBar.topAnchor).isActive = true
        vOutsideStub.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        vOutsideStub.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

}
