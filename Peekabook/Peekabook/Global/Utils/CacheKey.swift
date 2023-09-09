//
//  CacheKey.swift
//  Peekabook
//
//  Created by devxsby on 2023/09/08.
//

import Foundation

struct CacheKey {
    static let myBookShelfInfo = "cachedMyBookShelfInfo"
    static let recommendBooks = "cachedRecommendBooks"
}

extension UserDefaults {
    
    func setEncodable<T: Encodable>(_ value: T, forKey key: String) {
        do {
            let encoded = try JSONEncoder().encode(value)
            self.set(encoded, forKey: key)
        } catch {
            print("Failed to encode object: \(error)")
        }
    }
    
    func getDecodable<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let savedData = self.data(forKey: key) else { return nil }
        do {
            let decoded = try JSONDecoder().decode(T.self, from: savedData)
            return decoded
        } catch {
            print("Failed to decode object: \(error)")
            return nil
        }
    }
    
    func setMyBookShelfInfo(_ info: MyBookShelfResponse) {
        setEncodable(info, forKey: CacheKey.myBookShelfInfo)
    }
    
    func getMyBookShelfInfo() -> MyBookShelfResponse? {
        return getDecodable(MyBookShelfResponse.self, forKey: CacheKey.myBookShelfInfo)
    }
    
    func setRecommendBooks(_ info: GetRecommendResponse) {
        setEncodable(info, forKey: CacheKey.recommendBooks)
    }
    
    func getRecommendBooks() -> GetRecommendResponse? {
        return getDecodable(GetRecommendResponse.self, forKey: CacheKey.recommendBooks)
    }
    
    func clearCachedData() {
        self.removeObject(forKey: CacheKey.myBookShelfInfo)
        self.removeObject(forKey: CacheKey.recommendBooks)
    }
}
