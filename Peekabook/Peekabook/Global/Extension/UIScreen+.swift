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
    var isSmallThan712pt: Bool { self.bounds.size.height < 712 }
}
