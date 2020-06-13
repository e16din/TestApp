//
// Created by ALEKSANDR KUNDRYUKOV on 12.06.2020.
// Copyright (c) 2020 ALEKSANDR KUNDRYUKOV. All rights reserved.
//

import Foundation

extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[self.index(startIndex, offsetBy: i)]
    }
}
