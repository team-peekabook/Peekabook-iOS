//
//  setTextStyle.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

extension UILabel {
    
    /// 특정 문자열 폰트 및 컬러 변경 메서드
    func setTextStyle(targetStringList: [String], font: UIFont, color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        targetStringList.forEach {
            let range = (fullText as NSString).range(of: $0)
            attributedString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        }
        attributedText = attributedString
    }
}
