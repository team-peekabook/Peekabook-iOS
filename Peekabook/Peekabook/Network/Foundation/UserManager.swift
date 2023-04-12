//
//  UserManager.swift
//  Peekabook
//
//  Created by 김인영 on 2023/04/12.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    
    var userName: String?
    
    var isLoggedIn: Bool = false
    var imageURL: String?
    
    private init() { }
}
