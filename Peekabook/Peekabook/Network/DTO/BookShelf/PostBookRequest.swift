//
//  PostBookResponse.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/13.
//

import Foundation

// MARK: - PostBookResponse
struct PostBookRequest: Codable {
    let bookImage, bookTitle, author, publisher: String
    let description, memo: String?
}
