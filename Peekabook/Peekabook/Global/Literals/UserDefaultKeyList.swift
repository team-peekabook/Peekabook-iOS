//
//  UserDefaultKeyList.swift
//  Peekabook
//
//  Created by devxsby on 2023/04/07.
//

import Foundation

struct UserDefaultKeyList {
    struct Onboarding {
        static let onboardingComplete = "onboardingComplete"
    }
    
    struct Auth {
//        static let accessToken = "accessToken"
        static let userNickName = "nickName"
        static let userIntro = "intro"
        static let userProfileImage = "profileImage"
    }
}
