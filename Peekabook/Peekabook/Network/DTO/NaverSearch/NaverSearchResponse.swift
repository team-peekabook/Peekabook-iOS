//
//  NaverSearchResponse.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/10.
//

import Foundation

// MARK: - NaverSearchResponse

struct NaverSearchResponse: Codable {
    let BookDetailList: [BookDetail]
}

// MARK: - Item

struct BookDetail: Codable {
    let title: String
    let image: String
    let author: String
}
