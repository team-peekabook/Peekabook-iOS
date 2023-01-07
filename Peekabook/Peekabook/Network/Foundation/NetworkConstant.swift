//
//  NetworkConstant.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/07.
//

import Foundation

struct NetworkConstant {
    
    static let defaultHeader = ["Content-Type": "application/json"]
    static let hasUserIdHeader = ["Content-Type": "application/json",
                                  "userId": NetworkConstant.UserDefaultsKey.userId] as [String : Any]
}
