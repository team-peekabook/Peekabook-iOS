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
                "accessToken": UserDefaults.standard.string(forKey: "socialToken") ?? ""]
    }
    
    static var hasTokenHeader: [String: String] {
        return ["Content-Type": "application/json",
                "accessToken": UserDefaults.standard.string(forKey: "accessToken") ?? ""]
    }
    
    static var multipartWithTokenHeader: [String: String] {
        return ["Content-Type": "multipart/form-data",
                "accessToken": UserDefaults.standard.string(forKey: "accessToken") ?? ""]
    }
    
    static var updateTokenHeader: [String: String] {
        return ["Content-Type": "application/json",
                "accessToken": UserDefaults.standard.string(forKey: "accessToken") ?? "",
                "refreshToken": UserDefaults.standard.string(forKey: "refreshToken") ?? ""]
    }
}
