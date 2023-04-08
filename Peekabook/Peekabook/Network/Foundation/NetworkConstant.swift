//
//  NetworkConstant.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/07.
//

import Foundation

struct NetworkConstant {
    
    static let defaultHeader = ["Content-Type": "application/json"]
    
    // 릴리즈 이전 더미 유저 때 사용. 삭제 예정
    static let hasUserIdHeader = ["Content-Type": "application/json",
                                  "auth": "1"] as [String: String]
    
    static let socialTokenHeader = ["Content-Type": "application/json",
                                    "accessToken": Config.socialToken] as [String: String]
    
    static let hasTokenHeader = ["Content-Type": "application/json",
                                 "accessToken": Config.accessToken] as [String: String]
    
    static let multipartWithTokenHeader = ["Content-Type": "multipart/form-data",
                                           "accessToken": Config.accessToken] as [String: String]
    
}
