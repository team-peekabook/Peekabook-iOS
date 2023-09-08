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

extension UserDefaults {
    
    // MyBookShelfInfo 캐싱
    func setMyBookShelfInfo(_ info: MyBookShelfResponse) {
        if let encoded = try? JSONEncoder().encode(info) {
            self.set(encoded, forKey: "cachedMyBookShelfInfo")
        }
    }
    
    func getMyBookShelfInfo() -> MyBookShelfResponse? {
        if let savedData = self.data(forKey: "cachedMyBookShelfInfo") {
            if let decoded = try? JSONDecoder().decode(MyBookShelfResponse.self, from: savedData) {
                return decoded
            }
        }
        return nil
    }
    
    // GetRecommendResponse 캐싱
    func setRecommendBooks(_ info: GetRecommendResponse) {
        if let encoded = try? JSONEncoder().encode(info) {
            self.set(encoded, forKey: "cachedRecommendBooks")
        }
    }
    
    func getRecommendBooks() -> GetRecommendResponse? {
        if let savedData = self.data(forKey: "cachedRecommendBooks") {
            if let decoded = try? JSONDecoder().decode(GetRecommendResponse.self, from: savedData) {
                return decoded
            }
        }
        return nil
    }
    
    func clearCachedData() {
        self.removeObject(forKey: "cachedMyBookShelfInfo")
        self.removeObject(forKey: "cachedRecommendBooks")
    }
}
