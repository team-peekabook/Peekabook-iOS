//
//  delayWithSeconds.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

extension UIViewController {
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}
