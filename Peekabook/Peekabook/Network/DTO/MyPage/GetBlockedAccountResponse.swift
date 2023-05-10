//
//  GetBlockedAccountResponse.swift
//  Peekabook
//
//  Created by devxsby on 2023/05/10.
//

import Foundation

struct GetBlockedAccountResponse: Decodable {
    let id: Int
    let nickname: String
    let profileImage: String
}
