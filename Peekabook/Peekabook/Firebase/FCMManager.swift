//
//  FCMManager.swift
//  Peekabook
//
//  Created by 김인영 on 2024/02/25.
//

import Foundation

final class FCMManager {
    static let shared: FCMManager = FCMManager()
    private init() {}
    var fcmToken: String?
}
