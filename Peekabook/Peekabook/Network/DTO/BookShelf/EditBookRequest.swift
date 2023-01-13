//
//  EditBookRequest.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/14.
//

import Foundation

// MARK: - EditBookRequest
struct EditBookRequest: Codable {
    let description, memo: String?
}
