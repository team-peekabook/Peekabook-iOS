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
    let friendList: [MyIntro]
    let friendIntro: MyIntro
    let picks: [Pick]
    let bookTotalNum: Int
    let books: [Book]
}

// MARK: - MyIntro
struct MyIntro2: Codable {
    let nickname, profileImage: String?
}
