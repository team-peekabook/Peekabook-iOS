//
//  UserDefaultsKey.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/07.
//

import Foundation

struct UserDefaultsKey {
    
    // MARK: - Token
    
    static let loginComplete: Bool = false
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
    
    // MARK: - User Information
    
    static let userId: String = "userId"
    static let userNickname: String = "userName"
    static let userImageUrl: String = "userImage"
    static let userIntro: String = "userIntro"
    
}
