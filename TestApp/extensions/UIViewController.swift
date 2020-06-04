//
// Created by ALEKSANDR KUNDRYUKOV on 04.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import UIKit

extension UIViewController {

    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
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
