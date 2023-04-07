//
//  UserReportRequest.swift
//  Peekabook
//
//  Created by 고두영 on 2023/04/07.
//

import Foundation

struct UserReportRequest: Codable {
    let reasonIndex: Int
    let specificReason: String?
}
