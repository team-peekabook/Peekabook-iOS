//
//  APIConstants.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/07.
//

import Foundation

struct APIConstants {
    
    // MARK: - Base URL

    static let baseURL: String = "https://"
    
    // MARK: - Naver Book Search URL

    static let searchURL: String = "https://openapi.naver.com/v1/search/book_adv"
    
    // MARK: - Route
    
    static let bookShelf: String = "/bookshelf"
    static let pick: String = "/pick"
    static let recommend: String "/recommend"
    static let friend: String = "/friend"
    static let alarm: String = "/alarm"
}
