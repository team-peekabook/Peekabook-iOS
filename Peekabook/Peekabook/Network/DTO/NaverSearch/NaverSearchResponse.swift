//
//  NaverSearchResponse.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/10.
//

import Foundation

// MARK: - Item

struct NaverSearchResponse: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let image: String
    let author: String
}
