//
//  GeneralResponse.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/07.
//

import Foundation

struct GeneralResponse<T: Decodable>: Decodable {
    var status: Int
    var success: Bool
    var message: String?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case status
        case success
        case message
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? 0
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
    }
}

struct GeneralArrayResponse<T: Decodable>: Decodable {
    let status: Int
    let message: String?
    let success: Bool?
    let data: [T]?
    
    enum CodingKeys: String, CodingKey {
        case message
        case data
        case status
        case success
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? 0
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode([T].self, forKey: .data)) ?? []
    }
}

/// status, message, success 이외에 정보를 사용하지 않는 경우에 VoidType를 설정
struct VoidType: Decodable {}
