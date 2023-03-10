//
//  Array+.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/07.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
