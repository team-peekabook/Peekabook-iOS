//
//  GetAccountResponse.swift
//  Peekabook
//
//  Created by 고두영 on 2023/04/12.
//

import Foundation

// MARK: - GetAccountResponse
struct GetAccountResponse: Codable {
    let id: Int
    let nickname: String
    let profileImage: String
    let intro: String?
}
