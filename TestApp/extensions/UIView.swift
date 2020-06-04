//
// Created by ALEKSANDR KUNDRYUKOV on 02.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

extension UIView {

    var appDelegate: AppDelegate {
        get {
            return (UIApplication.shared.delegate as! AppDelegate)
        }
        set {
            // do nothing
        }
    }

    var fruits: Fruits {
        get {
            return (UIApplication.shared.delegate as! AppDelegate).fruits
        }
        set {
            // do nothing
        }
    }

}
