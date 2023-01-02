//
//  setStatusBarBackgroundColor.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

extension UIViewController {
    func setStatusBarBackgroundColor(_ color: UIColor?) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let statusBarManager = window?.windowScene?.statusBarManager
            let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
            statusBarView.backgroundColor = color
            window?.addSubview(statusBarView)
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = color
        }
    }
}
