//
//  GetRecommendResponse.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/11.
//

// MARK: - GetRecommendResponse
struct GetRecommendResponse: Codable {
    let recommendedBook, recommendingBook: [RecommendBook]
}

// MARK: - RecommendBook
struct RecommendBook: Codable {
    let recommendID: Int
    let recommendDesc: String?
    let createdAt: String
    let friendID: Int
    let friendNickname: String
    let friendImage: String
    let bookID: Int
    let bookTitle, author: String
    let bookImage: String

    enum CodingKeys: String, CodingKey {
        case recommendID = "recommendId"
        case recommendDesc, createdAt
        case friendID = "friendId"
        case friendNickname, friendImage
        case bookID = "bookId"
        case bookTitle, author, bookImage
    }
}
