//
// Created by ALEKSANDR KUNDRYUKOV on 29.05.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

protocol TextChangedProtocol: class {
    func onTextHeightChanged(cell: PropertyViewCell)
    func onTextChanged(text: String!, rowIndex: Int!)
}

class PropertyViewCell: UITableViewCell, UITextViewDelegate {

    let DEFAULT_WIDTH: CGFloat = UIScreen.main.bounds.width / 2

    var vPropertyField: UITextView!
    var vPropertyLabel: UILabel {
        get {
            return textLabel!
        }
    }

    weak var cellDelegate: TextChangedProtocol?

    var isSingleLine = false
    var isEditableProperty = false
    var rowIndex: Int!

    // Events

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        showPropertyView()
    }

    required public init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isEditableProperty) {
            vPropertyField.becomeFirstResponder()

        } else {
            super.touchesBegan(touches, with: event)
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        if !isSingleLine {
            updateCellHeight()
        }
        cellDelegate!.onTextChanged(text: textView.text, rowIndex: rowIndex)
    }

    // Actions

    func showPropertyView() {
        vPropertyField = UITextView(frame: CGRect(x: DEFAULT_WIDTH - 16, y: 8, width: DEFAULT_WIDTH, height: 40))
        vPropertyField.delegate = self
        vPropertyField.translatesAutoresizingMaskIntoConstraints = true
        vPropertyField.textAlignment = .right
        vPropertyField.textColor = .gray
        vPropertyField.font = vPropertyLabel.font

        contentView.addSubview(vPropertyField)

        let leftConstraint = NSLayoutConstraint(
            item: vPropertyField,
            attribute: .left,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .left,
            multiplier: 1,
            constant: 50
        )
        let rightConstraint = NSLayoutConstraint(
            item: vPropertyField,
            attribute: .right,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .right,
            multiplier: 1,
            constant: -16
        )
        let topConstraint = NSLayoutConstraint(
            item: vPropertyField,
            attribute: .top,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .top,
            multiplier: 1,
            constant: 8
        )
        let bottomConstraint = NSLayoutConstraint(
            item: vPropertyField,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .bottom,
            multiplier: 1,
            constant: -8
        )

        contentView.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }

    func updateCellHeight() {
        let startHeight = vPropertyField.frame.size.height
        let calcHeight = vPropertyField.sizeThatFits(vPropertyField.frame.size).height
        print("startHeight: \(startHeight) | calcHeight: \(calcHeight)")

        let delta: CGFloat = 4
        if startHeight + delta < calcHeight || startHeight - delta > calcHeight {
            UIView.setAnimationsEnabled(false)
            vPropertyField.sizeToFit()
            if vPropertyField.frame.size.width < DEFAULT_WIDTH {
                vPropertyField.frame.size.width = DEFAULT_WIDTH
            }

            cellDelegate!.onTextHeightChanged(cell: self)

            UIView.setAnimationsEnabled(true)
        }
    }

    func updatePropertyView(values: (name: String, value: String, isSingleLine: Bool)) {
        vPropertyLabel.text = values.name
        vPropertyField.text = values.value
        isSingleLine = values.isSingleLine

        if isSingleLine {
            vPropertyField.textContainer.maximumNumberOfLines = 1

        } else {
            vPropertyField.textContainer.maximumNumberOfLines = 30
            updateCellHeight()
        }

        vPropertyField.isEditable = isEditableProperty
        vPropertyField.isUserInteractionEnabled = isEditableProperty
        vPropertyField.textContainer.lineBreakMode = isEditableProperty ? .byTruncatingHead : .byTruncatingTail
    }
}
