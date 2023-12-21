//
//  CheckVersionResponse.swift
//  Peekabook
//
//  Created by 김인영 on 2023/11/08.
//

import Foundation

struct CheckVersionResponse: Codable {
    let imageURL, iosForceVersion, androidForceVersion, text: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case iosForceVersion, androidForceVersion, text
    }
}
