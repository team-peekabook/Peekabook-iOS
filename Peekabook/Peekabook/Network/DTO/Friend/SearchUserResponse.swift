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
    let nickname: String
    let profileImage: String?
    let isFollowed, isBlocked: Bool

    enum CodingKeys: String, CodingKey {
        case friendID = "friendId"
        case nickname, profileImage, isFollowed, isBlocked
    }
}
