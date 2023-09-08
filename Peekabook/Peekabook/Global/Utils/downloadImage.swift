//
//  downloadImage.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

import Kingfisher

extension NSObject {
    func downloadImage(with urlString: String, imageCompletionHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL.init(string: urlString) else {
            return  imageCompletionHandler(nil)
        }
        let resource = KF.ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                imageCompletionHandler(value.image)
            case .failure:
                imageCompletionHandler(nil)
            }
        }
    }
}
