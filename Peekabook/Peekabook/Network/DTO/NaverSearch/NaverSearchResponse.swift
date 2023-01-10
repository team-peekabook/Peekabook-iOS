//
//  NaverSearchResponse.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/10.
//

import Foundation

// 네이버 책검색 API 호출 메소드
class DataManager {
    static let shared: DataManager = DataManager()
    var searchResult: NaverSearchResponse?
    
    private init() {
        
    }
}

// MARK: - NaverSearchResponse

struct NaverSearchResponse: Codable {
    let items: [BookDetail]
}

// MARK: - Item

struct BookDetail: Codable {
    let title: String
    let image: String
    let author: String
}
