//
//  SearchUserResponse.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/10.
//

import Foundation

// MARK: - SearchUserResponse
struct SearchUserResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: SearchUserData
}

// MARK: - DataClass
struct SearchUserData: Codable {
    let friendID: Int
    let nickname, profileImage: String
    let isFollowed: Bool

    enum CodingKeys: String, CodingKey {
        case friendID = "friendId"
        case nickname, profileImage, isFollowed
    }
}
