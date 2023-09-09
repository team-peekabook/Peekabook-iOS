//
//  UserDefaultKeyList.swift
//  Peekabook
//
//  Created by devxsby on 2023/06/13.
//

import Foundation

struct UserDefaultKeyList {
    @UserDefaultWrapper<String>(key: "userNickname") static var userNickname
    @UserDefaultWrapper<String>(key: "userIntro") static var userIntro
    @UserDefaultWrapper<String>(key: "userProfileImage") static var userProfileImage
}
