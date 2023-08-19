//
//  safeAreaHeight.swift
//  Peekabook
//
//  Created by devxsby on 2023/06/08.
//

import UIKit

public class SafeAreaHeight {
    
    public static let STATUS_HEIGHT = UIApplication.shared.statusBarFrame.size.height // 상태바 높이
    
    public static func safeAreaTopInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            return topPadding ?? SafeAreaHeight.STATUS_HEIGHT
        } else {
            return SafeAreaHeight.STATUS_HEIGHT
        }
    }
    
    public static func safeAreaBottomInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding ??  0.0
        } else {
            return 0.0
        }
    }
}
