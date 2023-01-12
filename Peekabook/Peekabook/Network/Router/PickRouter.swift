//
//  PickRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

enum PickRouter {
    case getPickAll
}

extension PickRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPickAll:
            return URLConstant.pick + "/all"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPickAll:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPickAll:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasUserIdHeader
    }
}
