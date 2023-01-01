//
//  showNetworkAlert.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

extension UIViewController {
    func showNetworkErrorAlert() {
        makeAlert(title: I18N.Alert.error, message: I18N.Alert.networkError)
    }
}
