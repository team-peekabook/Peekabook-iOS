//
//  PickRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

enum PickRouter {
    case sample
    case getPickAll
}

extension PickRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .sample:
            return URLConstant.pick
        case .getPickAll:
            return "/pick/all"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sample:
            return .get
        case .getPickAll:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .sample:
            return .requestPlain
        case .getPickAll:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasUserIdHeader
    }
}
