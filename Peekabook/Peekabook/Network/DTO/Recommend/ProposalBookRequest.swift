//
//  ProposalBookRequest.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/13.
//

import Foundation

struct ProposalBookRequest: Codable {
    let recommendDesc: String
    let bookTitle, author, bookImage: String
}
