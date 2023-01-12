//
//  EditPickRequest.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/12.
//

import Foundation

// MARK: - EditPickRequest

struct EditPickRequest: Codable {
    let firstPick, secondPick, thirdPick: Int
}
