//
//  MyBookShelfResponse.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/08.
//

import Foundation

// MARK: - MyBookShelfResponse

struct MyBookShelfResponse: Codable {
    let myIntro: Intro
    let friendList: [Intro]
    let pickList: [Pick]
    let bookTotalNum: Int
    let bookList: [Book]
}

// MARK: - Book
struct Book: Codable {
    let bookID, pickIndex: Int
    let book: String

    enum CodingKeys: String, CodingKey {
        case bookID = "bookId"
        case pickIndex
        case book = "Book"
    }
}

// MARK: - MyIntro
struct Intro: Codable {
    let userId: Int
    let nickname, profileImage: String
    let intro: String?
}

// MARK: - Pick
struct Pick: Codable {
    let pickIndex: Int
    let book: PickBook
    let description: String

    enum CodingKeys: String, CodingKey {
        case pickIndex
        case book = "Book"
        case description
    }
}

// MARK: - PickBook
struct PickBook: Codable {
    let bookId: Int
    let bookImage, bookTitle: String
}
