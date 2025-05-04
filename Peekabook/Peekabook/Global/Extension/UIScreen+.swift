//
//  UIScreen+.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/08.
//

import UIKit

extension UIScreen {
    /// - Mini, SE: 375.0
    /// - pro: 390.0
    /// - pro max: 428.0
    var isSmallThan712pt: Bool {
        let nativeHeight = UIScreen.main.nativeBounds.height / UIScreen.main.nativeScale
        return nativeHeight < 712
    }
}
