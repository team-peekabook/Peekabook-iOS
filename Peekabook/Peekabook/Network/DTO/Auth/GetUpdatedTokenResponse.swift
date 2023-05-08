//
//  UpdateTokenRequest.swift
//  Peekabook
//
//  Created by 김인영 on 2023/05/05.
//

import Foundation

struct GetUpdatedTokenResponse: Codable {
    let newAccessToken, refreshToken: String
}
