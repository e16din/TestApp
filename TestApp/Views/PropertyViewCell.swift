//
// Created by ALEKSANDR KUNDRYUKOV on 29.05.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

protocol PropertyViewCellDelegate {
    // Events
    func propertyTextChanged(_ cell: PropertyViewCell, text: String, rowIndex: Int)

    // Actions
    func updatePropertyCellHeight(_ cell: PropertyViewCell)
}

class PropertyViewCell: UITableViewCell, UITextViewDelegate {

    let DEFAULT_WIDTH: CGFloat = UIScreen.main.bounds.width / 2

    var delegate: PropertyViewCellDelegate?

    var rowIndex = 0

    var isSingleLine = false
    var isEditableProperty = false

    var propertyLabelView: UILabel? {
        textLabel
    }
    var propertyFieldView: UITextView!


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
            propertyFieldView.becomeFirstResponder()

        } else {
            super.touchesBegan(touches, with: event)
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        if !isSingleLine {
            updateCellHeight()
        }

        delegate?.propertyTextChanged(self, text: textView.text, rowIndex: rowIndex)
    }

    // Actions

    func showPropertyView() {
        let frame = CGRect(x: DEFAULT_WIDTH - 16, y: 8, width: DEFAULT_WIDTH, height: 40)
        propertyFieldView = UITextView(frame: frame)
        propertyFieldView.delegate = self
        propertyFieldView.translatesAutoresizingMaskIntoConstraints = true
        propertyFieldView.textAlignment = .right
        propertyFieldView.textColor = .gray
        propertyFieldView.font = propertyLabelView?.font

        contentView.addSubview(propertyFieldView)

        let leftConstraint = NSLayoutConstraint(
            item: propertyFieldView,
            attribute: .left,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .left,
            multiplier: 1,
            constant: 50
        )
        let rightConstraint = NSLayoutConstraint(
            item: propertyFieldView,
            attribute: .right,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .right,
            multiplier: 1,
            constant: -16
        )
        let topConstraint = NSLayoutConstraint(
            item: propertyFieldView,
            attribute: .top,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .top,
            multiplier: 1,
            constant: 8
        )
        let bottomConstraint = NSLayoutConstraint(
            item: propertyFieldView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .bottom,
            multiplier: 1,
            constant: -8
        )

        contentView.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }

    func updateCell(values: (name: String, value: String, isSingleLine: Bool)) {
        propertyLabelView?.text = values.name
        propertyFieldView.text = values.value
        isSingleLine = values.isSingleLine

        if isSingleLine {
            propertyFieldView.textContainer.maximumNumberOfLines = 1

        } else {
            propertyFieldView.textContainer.maximumNumberOfLines = 30
            updateCellHeight()
        }

        propertyFieldView.isEditable = isEditableProperty
        propertyFieldView.isUserInteractionEnabled = isEditableProperty
        propertyFieldView.textContainer.lineBreakMode = isEditableProperty ? .byTruncatingHead : .byTruncatingTail
    }

    func updateCellHeight() {
        let startHeight = propertyFieldView.frame.size.height
        let calcHeight = propertyFieldView.sizeThatFits(propertyFieldView.frame.size).height
        print("startHeight: \(startHeight) | calcHeight: \(calcHeight)")

        let delta = CGFloat(4)
        if startHeight + delta < calcHeight || startHeight - delta > calcHeight {
            UIView.setAnimationsEnabled(false)
            propertyFieldView.sizeToFit()
            if propertyFieldView.frame.size.width < DEFAULT_WIDTH {
                propertyFieldView.frame.size.width = DEFAULT_WIDTH
            }

            delegate?.updatePropertyCellHeight(self)

            UIView.setAnimationsEnabled(true)
        }
    }
}
