//
//  NetworkConstant.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/07.
//

import Foundation

struct NetworkConstant {
    
    static let defaultHeader = ["Content-Type": "application/json"]
    
    static var socialTokenHeader: [String: String] {
        return ["Content-Type": "application/json",
                "accessToken": UserManager.shared.socialToken ?? ""]
    }
    
    static var hasTokenHeader: [String: String] {
        return ["Content-Type": "application/json",
                "accessToken": UserManager.shared.accessToken ?? ""]
    }
    
    static var multipartWithTokenHeader: [String: String] {
        return ["Content-Type": "multipart/form-data",
                "accessToken": UserManager.shared.accessToken ?? ""]
    }
    
    static var updateTokenHeader: [String: String] {
        return ["Content-Type": "application/json",
                "accessToken": UserManager.shared.accessToken ?? "",
                "refreshToken": UserManager.shared.refreshToken ?? ""]
    }
}
