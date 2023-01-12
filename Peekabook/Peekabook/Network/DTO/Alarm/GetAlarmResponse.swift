//
//  GetAlarmResponse.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/12.
//

// MARK: - GetAlarmResponse

struct GetAlarmResponse: Codable {
    let alarmID, typeID, senderID: Int
    let senderName: String
    let profileImage: String?
    let bookTitle: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case alarmID = "alarmId"
        case typeID = "typeId"
        case senderID = "senderId"
        case senderName, profileImage, bookTitle, createdAt
    }
}
