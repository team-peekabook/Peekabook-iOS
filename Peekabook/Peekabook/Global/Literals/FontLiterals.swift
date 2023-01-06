//
//  FontLiterals.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

extension UIFont {
    
    @nonobjc class var h4: UIFont {
        return UIFont.font(.notoSansMedium, ofSize: 16)
    }
    
    @nonobjc class var h3: UIFont {
        return UIFont.font(.notoSansBold, ofSize: 18)
    }
    
    @nonobjc class var h2: UIFont {
        return UIFont.font(.notoSansMedium, ofSize: 14)
    }
    
    @nonobjc class var h1: UIFont {
        return UIFont.font(.notoSansBold, ofSize: 14)
    }
    
    @nonobjc class var s1: UIFont {
        return UIFont.font(.notoSansBold, ofSize: 11)
    }
    
    @nonobjc class var s2: UIFont {
        return UIFont.font(.notoSansMedium, ofSize: 11)
    }
    
    @nonobjc class var s3: UIFont {
        return UIFont.font(.notoSansMedium, ofSize: 12)
    }
    
    @nonobjc class var s4: UIFont {
        return UIFont.font(.notoSansMedium, ofSize: 9)
    }
    
    @nonobjc class var c1: UIFont {
        return UIFont.font(.notoSansBold, ofSize: 10)
    }
    
    @nonobjc class var c2: UIFont {
        return UIFont.font(.notoSansMedium, ofSize: 10)
    }
    
    /// 행간 18은 setLineSpacing 사용
    @nonobjc class var nameBold: UIFont {
        return UIFont.font(.notoSansBold, ofSize: 16)
    }
    
    @nonobjc class var engSb: UIFont {
        return UIFont.font(.montserratSemiBold, ofSize: 22)
    }
    
    @nonobjc class var engC: UIFont {
        return UIFont.font(.montserratBold, ofSize: 14)
    }
}

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
