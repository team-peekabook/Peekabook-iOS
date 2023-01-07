//
//  UserDefaultsKey.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/07.
//

import Foundation

extension NetworkConstant {
    
    struct UserDefaultsKey {
        
        // MARK: - Token
        
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        
        // MARK: - User Information
        
        static let userId: Int = 0
        static let userName: String = "userName"
        static let userImageUrl: String = "userImage"
        static let userIntro: String = "userIntro"
    }
}
