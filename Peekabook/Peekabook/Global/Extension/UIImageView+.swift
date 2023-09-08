//
//  UIImageView+.swift
//  Peekabook
//
//  Created by devxsby on 2023/07/10.
//

import UIKit

extension UIImageView {
    func loadProfileImage(from urlString: String?) {
        self.kf.indicatorType = .activity
        if let urlString = urlString, let url = URL(string: urlString) {
            self.kf.setImage(with: url)
        } else {
            self.image = ImageLiterals.Icn.emptyProfileImage
        }
    }
}
