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
    let bookID, pickIndex: Int
    let book: BookBook

    enum CodingKeys: String, CodingKey {
        case bookID = "bookId"
        case pickIndex
        case book = "Book"
    }
}

// MARK: - BookBook
struct BookBook: Codable {
    let bookImage: String
}

// MARK: - MyIntro
struct MyIntro: Codable {
    let id: Int
    let nickname, profileImage: String
    let intro: String?
}

// MARK: - Pick
struct Pick: Codable {
    let pickIndex: Int
    let book: PickBook
    let description: String?

    enum CodingKeys: String, CodingKey {
        case pickIndex
        case book = "Book"
        case description
    }
}

// MARK: - PickBook
struct PickBook: Codable {
    let id: Int
    let bookImage, bookTitle: String
}
