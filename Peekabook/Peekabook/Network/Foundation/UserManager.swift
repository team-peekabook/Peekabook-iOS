//
//  UserManager.swift
//  Peekabook
//
//  Created by 김인영 on 2023/04/12.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    
    var userName: String = ""
    var userIntro: String = ""
    
    var imageURL: String?
    
    private init() { }
}
