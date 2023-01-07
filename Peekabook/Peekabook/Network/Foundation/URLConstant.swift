//
//  URLConstant.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/07.
//

import Foundation

struct URLConstant {
    
    // MARK: - Base URL

    static let baseURL = "https://"
    
    // MARK: - Naver Book Search URL

    static let searchURL = "https://openapi.naver.com/v1/search/book_adv"
    
    // MARK: - Route
    
    static let bookShelf = "/bookshelf"
    static let pick = "/pick"
    static let recommend = "/recommend"
    static let friend = "/friend"
    static let alarm = "/alarm"
}
