//
//  safeAreaHeight.swift
//  Peekabook
//
//  Created by devxsby on 2023/06/08.
//

import UIKit

public class SafeAreaHeight {
    
    public static var STATUS_HEIGHT: CGFloat {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    
    public static func safeAreaTopInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            let topPadding = window?.safeAreaInsets.top
            return topPadding ?? SafeAreaHeight.STATUS_HEIGHT
        } else {
            return SafeAreaHeight.STATUS_HEIGHT
        }
    }
    
    public static func safeAreaBottomInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            let bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding ?? 0.0
        } else {
            return 0.0
        }
    }
}
