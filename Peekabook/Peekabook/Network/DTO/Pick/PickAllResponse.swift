//
//  PickAllResponse.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/12.
//

import Foundation

// MARK: - PickAllResponse

struct PickAllResponse: Codable {
    let id, pickIndex: Int
    let book: EachBook

    enum CodingKeys: String, CodingKey {
        case id, pickIndex
        case book = "Book"
    }
}

// MARK: - BookPick
struct EachBook: Codable {
    let id: Int
    let bookImage: String
}
