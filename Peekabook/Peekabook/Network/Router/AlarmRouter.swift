//
//  AlarmRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

enum AlarmRouter {
    case sample
}

extension AlarmRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .sample:
            return URLConstant.alarm
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sample:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .sample:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasUserIdHeader
    }
}
