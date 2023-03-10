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
    let items: [BookInfoModel]
}

struct BookInfoModel: Codable {
    let title, image, author: String
}
