//
//  FriendBookShelfResponse.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/11.
//

import Foundation

// MARK: - FriendBookShelfResponse

struct FriendBookShelfResponse: Codable {
    let myIntro: MyIntro2
    let friendList: [Friend2]
    let friendIntro: Friend2
    let picks: [Pick2]
    let bookTotalNum: Int
    let books: [Book2]
}

// MARK: - Book
struct Book2: Codable {
    let id, bookID, pickIndex: Int
    let book: BookBook2
}

// MARK: - BookBook
struct BookBook2: Codable {
    let bookImage: String
}

// MARK: - Friend
struct Friend2: Codable {
    let id: Int
    let nickname, profileImage: String
    let intro: String?
}

// MARK: - MyIntro
struct MyIntro2: Codable {
    let nickname, profileImage: String
}

// MARK: - Pick
struct Pick2: Codable {
    let pickIndex: Int
    let book: PickBook
    let description: String
}
