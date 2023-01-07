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
        
        static let accessToken: String = "accessToken"
        static let refreshToken: String = "refreshToken"
        
        // MARK: - User Information
        
        static let userId: Int = 0
        static let userName: String = "userName"
        static let userImage: String = "userImage"
        static let userIntro: String = "userIntro"
    }
}
