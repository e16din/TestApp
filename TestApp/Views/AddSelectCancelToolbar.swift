//
// Created by ALEKSANDR KUNDRYUKOV on 13.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

@objc protocol SelectCancelToolbarDelegate {
    // MARK: - Events
    func toolbarSelectButtonPressed()
    func toolbarCancelButtonPressed()
}

class AddSelectCancelToolbar {

    func addTo(_ view: UIView, bottomView: UIView, delegate: SelectCancelToolbarDelegate?) -> UIToolbar {
        var toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Выбрать", style: .plain, target: delegate,
            action: #selector(delegate?.toolbarSelectButtonPressed));
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: delegate,
            action: #selector(delegate?.toolbarCancelButtonPressed));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil,
            action: nil)

        toolBar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        view.addSubview(toolBar)

        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        toolBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        toolBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        return toolBar
    }
}
