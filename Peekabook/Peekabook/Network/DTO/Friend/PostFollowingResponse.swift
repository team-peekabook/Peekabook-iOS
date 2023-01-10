//
//  PostFollowingResponse.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/11.
//

import Foundation

// MARK: - PostFollowingResponse

struct PostFollowingResponse: Codable {
    let followID, receiverID, senderID: Int

    enum CodingKeys: String, CodingKey {
        case followID = "followId"
        case receiverID = "receiverId"
        case senderID = "senderId"
    }
}
