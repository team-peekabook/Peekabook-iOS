//
//  UITextField+.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/09.
//

import UIKit

extension UITextField {
    
    // 글자 시작위치 변경 메소드
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: -14, height: -10))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addLeftPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func addRightPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
