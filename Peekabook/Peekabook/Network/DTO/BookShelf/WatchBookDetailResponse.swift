//
//  WatchBookDetailResponse.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/11.
//

// MARK: - DataClass
struct WatchBookDetailResponse: Codable {
    let description, memo: String
    let book: BookDetail

    enum CodingKeys: String, CodingKey {
        case description, memo
        case book = "Book"
    }
}

// MARK: - Book
struct BookDetail: Codable {
    let bookImage: String
    let bookTitle, author: String
}
