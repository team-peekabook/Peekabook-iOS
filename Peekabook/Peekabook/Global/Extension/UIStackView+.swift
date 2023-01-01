//
//  UIStackView+.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

extension UIStackView {
     func addArrangedSubviews(_ views: UIView...) {
         for view in views {
             self.addArrangedSubview(view)
         }
     }
}
