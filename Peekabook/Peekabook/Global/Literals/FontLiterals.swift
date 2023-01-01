//
//  FontLiterals.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

enum FontName: String {
    case notoSansBold = "NotoSansKR-Bold"
    case notoSansLight = "NotoSansKR-Light"
    case notoSansMedium = "NotoSansKR-Medium"
    case notoSansRegular = "NotoSansKR-Regular"
    case notoSansThin = "NotoSansKR-Thin"
    case montserratBold = "Montserrat-Bold"
    case montserratMedium = "Montserrat-Medium"
    case montserratRegular = "Montserrat-Regular"
    case montserratSemiBold = "Montserrat-SemiBold"
}

extension UIFont {
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}
