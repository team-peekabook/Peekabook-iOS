//
//  MyBookShelfResponse.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/08.
//

import Foundation

typealias Intro = MyIntro

// MARK: - MyBookShelfResponse

struct MyBookShelfResponse: Codable {
    let friendList: [Intro]
    let myIntro: Intro
    let picks: [Pick]
    let bookTotalNum: Int
    let books: [Book]
}

// MARK: - Book
struct Book: Codable {
    let id, bookID, pickIndex: Int
    let book: BookDetail

    enum CodingKeys: String, CodingKey {
        case id
        case bookID = "bookId"
        case pickIndex
        case book = "Book"
    }
}

// MARK: - BookBook
struct BookDetail: Codable {
    let bookImage: String
}

// MARK: - MyIntro
struct MyIntro: Codable {
    let id: Int
    let nickname: String
    let intro, profileImage: String?
}

// MARK: - Pick
struct Pick: Codable {
    let pickIndex: Int
    let book: PickBookDetail
    let description: String?

    enum CodingKeys: String, CodingKey {
        case pickIndex
        case book = "Book"
        case description
    }
}

// MARK: - PickBook
struct PickBookDetail: Codable {
    let id: Int
    let bookImage, bookTitle: String
}
