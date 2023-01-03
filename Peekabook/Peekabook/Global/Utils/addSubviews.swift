//
//  addSubviews.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
