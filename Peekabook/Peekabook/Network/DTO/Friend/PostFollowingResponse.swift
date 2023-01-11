//
//  PostFollowingResponse.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/11.
//


import Foundation

// MARK: - PostFollowingResponse
struct PostFollowingResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
}
