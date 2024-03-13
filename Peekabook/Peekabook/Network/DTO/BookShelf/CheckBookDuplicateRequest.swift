//
//  CheckBookDuplicateRequest.swift
//  Peekabook
//
//  Created by 고두영 on 2/29/24.
//

import Foundation

struct CheckBookDuplicateRequest: Codable {
    let bookTitle: String
    let author: String
    let publisher: String
}
