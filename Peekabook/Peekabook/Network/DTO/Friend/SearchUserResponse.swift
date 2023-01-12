//
//  SearchUserResponse.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/10.
//

import Foundation

// MARK: - SearchUserResponse

struct SearchUserResponse: Codable {
    let friendID: Int
    let nickname, profileImage: String
    let isFollowed: Bool

    enum CodingKeys: String, CodingKey {
        case friendID = "friendId"
        case nickname, profileImage, isFollowed
    }
}
