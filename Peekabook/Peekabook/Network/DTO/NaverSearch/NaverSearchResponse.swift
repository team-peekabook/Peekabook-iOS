//
//  NaverSearchResponse.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/10.
//

import Foundation

// MARK: - NaverResponse

struct NaverResponse: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [NaverSearchResponse]
}

struct NaverSearchResponse: Codable {
    let title, image, author: String
}

struct BookInfoModel: Codable {
    var image: String
    var title: String
    var author: String
}
