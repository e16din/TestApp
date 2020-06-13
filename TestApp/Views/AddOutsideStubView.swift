//
// Created by ALEKSANDR KUNDRYUKOV on 13.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

@objc protocol OutsideStubViewDelegate {
    // Events
    func outsideStubPressed()
}

class AddOutsideStubView {

    func addTo(_ view: UIView, bottomView: UIView, delegate: OutsideStubViewDelegate?) -> UIView {
        var outsideStubView = UIView()
        view.addSubview(outsideStubView)

        let gesture = UITapGestureRecognizer(target: delegate, action: #selector(delegate?.outsideStubPressed))
        outsideStubView.addGestureRecognizer(gesture)

        outsideStubView.translatesAutoresizingMaskIntoConstraints = false
        outsideStubView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        outsideStubView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        outsideStubView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        outsideStubView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        return outsideStubView
    }
}
